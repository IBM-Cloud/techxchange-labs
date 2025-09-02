#!/usr/bin/env bash

if [ "$PIPELINE_DEBUG" = "1" ]; then
  pwd
  env
  trap env EXIT
  set -x +e

  export IBMCLOUD_TRACE=true
fi

source "${ONE_PIPELINE_PATH}"/tools/get_repo_params

APP_TOKEN_PATH="$WORKSPACE/app-token"
read -r APP_REPO_NAME APP_REPO_OWNER APP_SCM_TYPE APP_API_URL < <(get_repo_params "$(get_env APP_REPO)" "$APP_TOKEN_PATH")

if [[ $APP_SCM_TYPE == "gitlab" ]]; then
  # shellcheck disable=SC2086
  curl --location --request PUT "${APP_API_URL}/projects/$(echo ${APP_REPO_OWNER}/${APP_REPO_NAME} | jq -rR @uri)" \
    --header "PRIVATE-TOKEN: $(cat "$APP_TOKEN_PATH")" \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "only_allow_merge_if_pipeline_succeeds": true
    }'
else
  # If PR, then target branch of the PR is the branch to protect
  branch=$(get_env base-branch "")
  if [ -z "$branch" ]; then
    branch="$(cat /config/git-branch)"
  fi
  curl -H "Authorization: Bearer $(cat "${APP_TOKEN_PATH}")" "${APP_API_URL}/repos/${APP_REPO_OWNER}/${APP_REPO_NAME}/branches/$branch/protection" \
    -XPUT -d '{"required_pull_request_reviews":{"dismiss_stale_reviews":true},"required_status_checks":{"strict":true,"contexts":["tekton/code-branch-protection","tekton/code-unit-tests","tekton/code-cis-check","tekton/code-vulnerability-scan","tekton/code-detect-secrets"]},"enforce_admins":null,"restrictions":null}'
fi