#!/usr/bin/env bash

if [ "$PIPELINE_DEBUG" = "1" ]; then
  pwd
  env
  trap env EXIT
  set -x +e

  export IBMCLOUD_TRACE=true
fi

#
# prepare data for the release step. Here we upload all the metadata to the Inventory Repo.
# If you want to add any information or artifact to the inventory repo then use the "cocoa inventory add command"
#
source "${ONE_PIPELINE_PATH}/tools/get_repo_params"

cd "${WORKSPACE}/$(load_repo app-repo path)" || exit 1

COMMIT_SHA="$(load_repo app-repo commit)"

INVENTORY_TOKEN_PATH="$WORKSPACE/inventory-token"
read -r INVENTORY_REPO_NAME INVENTORY_REPO_OWNER INVENTORY_SCM_TYPE INVENTORY_API_URL < <(get_repo_params "$(get_env INVENTORY_URL)" "$INVENTORY_TOKEN_PATH")

# if version is found, then refers to the tag of the version
# if not, only refers to the commit of the repo for the deployment
if [ -z "$(get_env release-tag "")" ]; then
  echo "NO NEW VERSION RELEASED - Existing version is $(get_env existing-version)"
else

  app_artifacts=$(jq --null-input -c --arg tag "$(load_artifact iac tag)" \
    --arg browser_download_url "$(load_artifact iac browser_download_url)" \
    --arg artifact_download_url "$(load_artifact iac url)" \
    --arg public_key "$(load_artifact iac public_key)" \
    '.artifact_download_url=$artifact_download_url | .browser_download_url=$browser_download_url | .tag=$tag | .public_key=$public_key')

  # Workaround: use type image as collect-evidence and evaluator-v2 are expected artifact to be of type image
  # to compute an asset id and provide the expected image format for provenance
  cocoa inventory add \
    --name="$(basename "$(load_artifact iac name)" .tar.gz)" \
    --artifact="$(load_artifact iac name)" \
    --type="image" \
    --provenance="$(load_artifact iac name)@$(load_artifact iac digest)" \
    --sha256="$(load_artifact iac digest)" \
    --signature="$(load_artifact iac signature)" \
    --app-artifacts="${app_artifacts}" \
    --repository-url="$(load_repo app-repo url)" \
    --commit-sha="${COMMIT_SHA}" \
    --version="$(get_env release-version "${COMMIT_SHA}")" \
    --build-number="${BUILD_NUMBER}" \
    --pipeline-run-id="${PIPELINE_RUN_ID}" \
    --org="$INVENTORY_REPO_OWNER" \
    --repo="$INVENTORY_REPO_NAME" \
    --git-provider="$INVENTORY_SCM_TYPE" \
    --git-token-path="$INVENTORY_TOKEN_PATH" \
    --git-api-url="$INVENTORY_API_URL"
fi