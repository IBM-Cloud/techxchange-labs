#! /bin/bash

#
# this function generates values that will be used as deploy values during the validation of the offering version.
function generateValidationValues() {
    local validationValues=$1

    # we only need to do this once.
    FILE=$1
    if [ -f "$FILE" ]; then
        return
    fi

    # generate an ssh key that can be used as a validation value. overwrite file if already there.
    ssh-keygen -f ./id_rsa -t rsa -N '' <<<y

    SSH_KEY=$(cat ./id_rsa.pub)
    SSH_PRIVATE_KEY="$(cat ./id_rsa)"

    # use a unique prefix string value
    SUFFIX="$(date +%m%d-%H-%M)"
    PREFIX="val-${SUFFIX}"

    # format offering validation values into json format
    jq -n --arg IBMCLOUD_API_KEY "$IBMCLOUD_API_KEY" --arg PREFIX "$PREFIX" --arg SSH_KEY "$SSH_KEY" --arg SSH_PRIVATE_KEY "$SSH_PRIVATE_KEY" '{ "ibmcloud_api_key": $IBMCLOUD_API_KEY, "prefix": $PREFIX, "ssh_key": $SSH_KEY, "ssh_private_key": $SSH_PRIVATE_KEY }' > "$validationValues"
}

function createOffering() {
  echo "Creating offering using CLI"
  if [ -n "$FLAVOR" ]; then
    FLAVOR_PARAM="--flavor $FLAVOR"
  fi
  echo "ibmcloud catalog offering create --catalog $CATALOG_NAME --name $OFFERING_NAME $FLAVOR_PARAM --include-config  --format-kind $FORMAT_KIND --variation $VARIATION --target-version $VERSION --token XXX --zipurl $ZIP_URL"
  # shellcheck disable=SC2086
  if ibmcloud catalog offering create --catalog "$CATALOG_NAME" \
   --name "$OFFERING_NAME" \
   $FLAVOR_PARAM \
   --include-config \
   --format-kind "$FORMAT_KIND" \
   --variation "$VARIATION" \
   --target-version "$VERSION" \
   --token "$(cat "$WORKSPACE/app-token")" \
   --zipurl "$ZIP_URL"; then
     echo "Offering $OFFERING_NAME created"
   else
     echo "Fail to create offering $OFFERING_NAME"
     return 1
   fi
}

#
# this function imports an offering version into a catalog.
function importVersionToCatalog() {
    echo ibmcloud catalog offering import-version --zipurl "$ZIP_URL" --target-version "$VERSION" --catalog "$CATALOG_NAME" --offering "$OFFERING_NAME" --include-config --variation "$VARIATION" --format-kind "$FORMAT_KIND" || ret=$?

    ibmcloud catalog offering import-version --zipurl "$ZIP_URL" --target-version "$VERSION" --catalog "$CATALOG_NAME" --offering "$OFFERING_NAME" --include-config --variation "$VARIATION" --format-kind "$FORMAT_KIND" || ret=$?
    if [[ ret -ne 0 ]]; then
        exit 1
    fi
}

#
# this function querys the catalog and retrieves the version locator for a version.
function getVersionLocator() {
    # get the catalog version locator for an offering version
    ibmcloud catalog offering get --catalog "$CATALOG_NAME" --offering "$OFFERING_NAME" --output json > offering.json
    VERSION_LOCATOR=$(jq -r --arg version "$VERSION" --arg format_kind "$FORMAT_KIND" '.kinds[] | select(.format_kind==$format_kind).versions[] | select(.version==$version).version_locator' < offering.json)
    echo "version locator is:${VERSION_LOCATOR}"
}

#
# this function calls the schematics service and validates the version.
function validateVersion() {
    local validationValues="validation-values.json"
    local timeOut=10800         # 3 hours - sufficiently large.  will not run this long.

    generateValidationValues "${validationValues}"
    getVersionLocator

    # need to target a resource group - deployed resources will be in this resource group
    # TODO: what is this for ? I assume this is what to be used for tf plan/apply
    # so TF_VAR_resource_group value or variables.tf default or tfavras file content ?
    ibmcloud target -g "${RESOURCE_GROUP}"
    cat "${validationValues}"
    echo "${validationValues}"
    echo ibmcloud catalog offering version validate --vl "${VERSION_LOCATOR}" --override-values "${validationValues}" --timeout $timeOut || ret=$?

    # invoke schematics service to validate the version
    ibmcloud catalog offering version validate --vl "${VERSION_LOCATOR}" --override-values "${validationValues}" --timeout $timeOut || ret=$?

    if [[ ret -ne 0 ]]; then
        exit 1
    fi
}

#
# this function invokes a CRA scan on a validated version.
function scanVersion() {
    if [ "$CRA_SCAN" = SCAN ]; then
        ibmcloud catalog offering version cra --vl "${VERSION_LOCATOR}"
    else
        echo "CRA scan skipped"
    fi
}

#
# this function marks a validated version as 'Ready'
function publishVersion() {
    ibmcloud catalog offering ready --vl "${VERSION_LOCATOR}"
}

# ------------------------------------------------------------------------------------
#  main
# ------------------------------------------------------------------------------------

CATALOG_NAME="$(get_env catalog-name)"
OFFERING_NAME="$(jq -r '.products[0].name' "$WORKSPACE/$(load_repo app-repo path)/ibm_catalog.json")"
FLAVOR="$(jq -r '.products[0].flavors[0].name // empty' "$WORKSPACE/$(load_repo app-repo path)/ibm_catalog.json")"
VARIATION="$(get_env variation "")"
VERSION="$(get_env release-version "")"
FORMAT_KIND="$(get_env format-kind "terraform")"
# Catalog is handling browser download url
ZIP_URL="$(load_artifact iac sources_tar_gz_url)"
RESOURCE_GROUP="$(get_env "validation-resource-group" "$(jq -r .container.guid /toolchain/toolchain.json)")"
CRA_SCAN=$7

IBMCLOUD_API_KEY="$(get_env ibmcloud-api-key)"

echo "CatalogName: $CATALOG_NAME"
echo "OfferingName: $OFFERING_NAME"
echo "ZipUrl: $ZIP_URL"
echo "Version: $VERSION"
echo "Variation: $VARIATION"
echo "Flavor: $FLAVOR"
echo "ResourceGroup: $RESOURCE_GROUP"
echo "FormatKind: $FORMAT_KIND"

# steps
ibmcloud plugin install catalogs-management
ibmcloud login --apikey "$IBMCLOUD_API_KEY" --no-region

# find out if this offering is existing or not
if ! ibmcloud catalog offering get --catalog "$CATALOG_NAME" --offering "$OFFERING_NAME" --output json > offering.json 2>/dev/null; then
  # offering not found - create it
  if ! createOffering; then
    exit 1
  fi
else
  # ensure the offering returned by get is matching the real name
  # terraform-sample-1.1.0 offering name is returned terraform-sample
  if [ "$(jq -r '.name' offering.json)" == "$OFFERING_NAME" ]; then
    # offering already exist so import the version
    importVersionToCatalog
  else
    if ! createOffering; then
      exit 1
    fi
  fi
fi

validateVersion
scanVersion
publishVersion