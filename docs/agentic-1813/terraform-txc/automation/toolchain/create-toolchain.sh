#!/bin/bash

echo "Creating DevOps Toolchain for catalog developement.."

token=$(ibmcloud iam oauth-tokens | head -1 | sed 's/.*:[ \t]*//')
api_key=$(ibmcloud iam api-key-create "api-key created on $(date)" | grep "API Key" | sed 's/API Key[ ]*\([^ ]*\)[ ]*/\1/g')

resource_group_id=$(ibmcloud resource groups --output json | jq -r '.[0].id')

host="https://cloud.ibm.com"

region=${region:-"us-south"}
env_id="ibm:yp:$region"

template="https://$region.git.cloud.ibm.com/open-toolchain/iac-compliance-ci-toolchain"

# copy contents of the root folder not the examples folder
tmp_folder=$(mktemp -d)
echo "Preparing repository content in $tmp_folder"
cp -r ../../. $tmp_folder
mv $tmp_folder/automation/toolchain/content/scripts $tmp_folder
mv $tmp_folder/automation/toolchain/content/.gitignore $tmp_folder
mv $tmp_folder/automation/toolchain/content/.*.yaml $tmp_folder
mv $tmp_folder/automation/toolchain/content/.*.json $tmp_folder
rm -r -f $tmp_folder/.git
rm -r -f $tmp_folder/automation

pushd $tmp_folder

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    # linux
    base64_param="-w0"
    ;;
  darwin*)
    # osx
    base64_param=""
    ;;
  msys*)
    # windows
    base64_param="-w0"
    ;;
  freebsd*)
    # freebsd
    base64_param="-w0"
    ;;
  *)
    # unknown
    base64_param="-w0"
    ;;
esac
encodedZip=$(zip -r - . | base64 ${base64_param} | jq -rR @uri)
popd

body="autocreate=true"
body="${body}&repository=${template}"
body="${body}&env_id=${env_id}"
body="${body}&apiKey=${api_key}"
body="${body}&resourceGroupId=${resource_group_id}"
body="${body}&sourceRepoUrl=data-application/zip-base64-${encodedZip}"

url="${host}/devops/setup/deploy?env_id=${env_id}"
url="${url}&repository=${template}"

echo "POST url is: $url"
#echo "POST body is: $body"

echo "date is: $(date)"

response_file=$(mktemp)

curl -k -D $response_file -X POST \
  -H "Authorization: ${token}" \
  -H "Accept: application/json" \
  -d "${body}" \
  "${url}"

# Retrieve the toolchain id out of the location
toolchain_url=$(sed -e '/location:/!d' $response_file | awk '{print $2}')
toolchain_id=$(echo "$toolchain_url" | awk -F/ '{print $6}' | awk -F? '{print $1}')

# Post-actions
# retrieve the tools for the given toolchain
toolchain_api_base_url="https://api.$region.devops.cloud.ibm.com/toolchain/v2"
pipeline_api_base_url="https://api.$region.devops.cloud.ibm.com/pipeline/v2"

tools_file_json=$(mktemp)

# ensure tools are not in a configuring state - wait
all_configured="false"
while [ "$all_configured" != "true" ]; do
  curl -X GET --location --header "Authorization: $token" \
    --header "Accept: application/json" "$toolchain_api_base_url/toolchains/$toolchain_id/tools" > $tools_file_json
  if [ -z "$(jq '.tools[] | select(.state == "configuring") | .name // empty' $tools_file_json)" ]; then
    all_configured="true"
  else
    echo "Waiting for tools to be configured. Tools still configuring:"
    jq -r '.tools[] | select(.state == "configuring") | .name // empty' $tools_file_json
    echo "Wait 5s"
    sleep 5s
  fi
done

# Remove the unneeded tools
tools_to_remove="secretsmanager slack hashicorpvault keyprotect customtool"
for tool_type in $tools_to_remove; do
  tool_id=$(jq -r --arg tool_type_id "$tool_type" '.tools[] | select(.tool_type_id == $tool_type_id) | .id // empty' $tools_file_json)
  if [ -n "$tool_id" ]; then
    echo "Deleting tool $tool_type $tool_id"
    curl -X DELETE --location --header "Authorization: $token" \
        --header "Accept: application/json" \
        "$toolchain_api_base_url/toolchains/$toolchain_id/tools/$tool_id"
    echo ""
  else
    echo "Tool $tool_type not found in the toolchain $toolchain_id"
  fi
done

issues_repo_id=$(jq -r '.tools[] | select(.name == "issues-repo") | .id // empty' $tools_file_json)
if [ -n "$issues_repo_id" ]; then
  echo "Deleting created issues-repo"
  curl -X DELETE --location --header "Authorization: $token" \
    --header "Accept: application/json" \
    "$toolchain_api_base_url/toolchains/$toolchain_id/tools/$issues_repo_id"
  echo ""
fi

# Updating the pipelines
# retrieving pr_pipeline id and ci_pipeline id
pr_pipeline_id=$(jq -r '.tools[] | select(.name == "pr" and .tool_type_id=="pipeline") | .id // empty' $tools_file_json)
ci_pipeline_id=$(jq -r '.tools[] | select(.name == "ci" and .tool_type_id=="pipeline") | .id // empty' $tools_file_json)

echo "Update Set signing-key property to empty in $ci_pipeline_id"
curl -X PUT --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{ "name": "branch", "value": "master", "type": "text" }' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/properties/branch"
echo ""

echo "Set signing-key property to empty in $ci_pipeline_id"
curl -X PUT --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{ "name": "signing-key", "value": "", "type": "secure" }' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/properties/signing-key"

pipeline_ids="$pr_pipeline_id $ci_pipeline_id"
for pipeline_id in $pipeline_ids; do
  echo "Updating pipeline-config-branch property in $pipeline_id"
  curl -X PUT --location --header "Authorization: $token" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --data '{ "name": "pipeline-config-branch", "value": "master", "type": "text" }' \
    "$pipeline_api_base_url/tekton_pipelines/$pipeline_id/properties/pipeline-config-branch"
  echo ""
  to_delete_properties="TF_VAR_key_protect_instance TF_VAR_key_protect_root_key_name git-token opt-in-checkov opt-in-tfsec pre-commit-skip-hooks slack-notifications"
  echo "Deleting un-needed environment properties ($to_delete_properties) from $pipeline_id"
  for property in $to_delete_properties; do
    curl -X DELETE --location --header "Authorization: $token" \
      --header "Accept: application/json" \
      --header "Content-Type: application/json" \
      "$pipeline_api_base_url/tekton_pipelines/$pipeline_id/properties/$property"
  done
done
to_delete_properties="cos-api-key cos-bucket-name cos-endpoint schematics-workspace-name"
echo "Deleting un-needed environment properties ($to_delete_properties) from $ci_pipeline_id"
for property in $to_delete_properties; do
  curl -X DELETE --location --header "Authorization: $token" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/properties/$property"
done

echo "Creating a new property catalog-name in $ci_pipeline_id"
curl -X POST --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{ "name": "catalog-name", "value": "'${CATALOG_NAME:-"my-private-catalog"}'", "type": "text" }' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/properties"
echo ""

echo "Updating property incident-repo in $ci_pipeline_id to app-repo"
app_repo_id=$(jq -r '.tools[] | select(.name == "app-repo") | .id // empty' $tools_file_json)
curl -X PUT --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{ "name": "incident-repo", "value": "'$app_repo_id'", "type": "integration", "path": "parameters.repo_url" }' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/properties/incident-repo"
echo ""

app_repo_url=$(jq -r '.tools[] | select(.name == "app-repo") | .parameters.repo_url // empty' $tools_file_json)

pr_git_trigger_id=$(curl -X GET --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  "$pipeline_api_base_url/tekton_pipelines/$pr_pipeline_id/triggers?type=scm" | jq -r '.triggers[0] | .id')

echo "Updating branch source of PR pipeline's git trigger $pr_git_trigger_id in $pr_pipeline_id"
curl -X PATCH --location --header "Authorization: $token" \
  --header "Accept: application/json" --header "Content-Type: application/merge-patch+json" \
  --data '{"source": {"type": "git","properties": {"url": "'$app_repo_url'", "branch":"master"}}}' \
  "$pipeline_api_base_url/tekton_pipelines/$pr_pipeline_id/triggers/$pr_git_trigger_id"
echo ""

ci_git_trigger_id=$(curl -X GET --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/triggers?type=scm" | jq -r '.triggers[0] | .id')

echo "Updating event-listener and branch source of CI Pipeline's git trigger $ci_git_trigger_id in $ci_pipeline_id"
curl -X PATCH --location --header "Authorization: $token" \
  --header "Accept: application/json" --header "Content-Type: application/merge-patch+json" \
  --data '{"event_listener": "dev-mode-listener", "source": {"type": "git","properties": {"url": "'$app_repo_url'", "branch":"master"}}}' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/triggers/$ci_git_trigger_id"

ci_manual_trigger_id=$(curl -X GET --location --header "Authorization: $token" \
  --header "Accept: application/json" \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/triggers?type=manual" | jq -r '.triggers[0] | .id')
echo "Updating event-listener trigger $ci_manual_trigger_id in $ci_pipeline_id"
curl -X PATCH --location --header "Authorization: $token" \
  --header "Accept: application/json" --header "Content-Type: application/merge-patch+json" \
  --data '{"event_listener": "dev-mode-listener"}' \
  "$pipeline_api_base_url/tekton_pipelines/$ci_pipeline_id/triggers/$ci_manual_trigger_id"

echo "=================================================="
echo "The created toolchain is located at $toolchain_url"
echo "=================================================="

#
# User flow:
# - Update the ibm-catalog.json to specifiy a customized offering name
# - Customize the terraform definitions
# - git commit push using semantic-release/angularjs format:
#   - feat: XXXX or fix: XXX => new release will be created
#   - chore: XXX => no release created
#   - other commit message => no release created