#!/usr/bin/env bash

if [ "$PIPELINE_DEBUG" = "1" ]; then
  pwd
  env
  trap env EXIT
  set -x +e

  export IBMCLOUD_TRACE=true
fi

source "${ONE_PIPELINE_PATH}/tools/get_repo_params"

cd "${WORKSPACE}/$(load_repo app-repo path)" || exit 1

APP_REPO="$(load_repo app-repo url)"
APP_ABSOLUTE_SCM_TYPE=$(get_absolute_scm_type "$APP_REPO")
APP_TOKEN_PATH="$WORKSPACE/app-token"
# shellcheck disable=SC2034
read -r APP_REPO_NAME APP_REPO_OWNER APP_SCM_TYPE APP_API_URL < <(get_repo_params "$(get_env APP_REPO)" "$APP_TOKEN_PATH")

# Find associated email and user.name for the GIT token
if [[ $APP_SCM_TYPE == "gitlab" ]]; then
  # shellcheck disable=SC2086
  git_user=$(curl --location --header "Accept: application/json" --header "PRIVATE-TOKEN: $(cat $APP_TOKEN_PATH)" "${APP_API_URL}/user")
  set_env git-user-email "$(echo "$git_user" | jq -r '.email')"
  set_env git-user-name "$(echo "$git_user" | jq -r '.name')"
else
  # shellcheck disable=SC2086
  git_user=$(curl --location --header "Accept: application/vnd.github.v3+json" --header "Authorization: Bearer $(cat ${APP_TOKEN_PATH})" "${APP_API_URL}/user")
  set_env git-user-email "$(echo "$git_user" | jq -r '.email')"
  set_env git-user-name "$(echo "$git_user" | jq -r '.name')"
fi

# define semantic release version to use - latest verified version
# https://github.com/semantic-release/semantic-release/issues/2533
semantic_release_version="$(get_env semantic-release-version "19.0.3")"
# ensure some plugins to be installed will be compatible with semantic-release default if none defined
# based on the sample provided
if [ -z "$(get_env "semantic-release-plugin-version-gitlab" "")" ]; then
  set_env "semantic-release-plugin-version-gitlab" "9.5.1"
fi
if [ -z "$(get_env "semantic-release-plugin-version-changelog" "")" ]; then
  set_env "semantic-release-plugin-version-changelog" "6.0.2"
fi
# default plugins installed by semantic-release
default_plugins=("@semantic-release/commit-analyzer" "@semantic-release/release-notes-generator" "@semantic-release/npm" "@semantic-release/github")
if [ -n "$semantic_release_version" ]; then
  semantic_release_package="semantic-release@${semantic_release_version}"
else
  semantic_release_package="semantic-release"
fi
npm config set update-notifier false
# install semantic-release and packages
export NODE_ENV=production
echo "Installing $semantic_release_package"
npm install --location=global --silent "$semantic_release_package"
configuration_file=$(get_env semantic-release-configuration-file "")
# if configuration_file is not defined or empty, stick to default one
if [ -z "$configuration_file" ]; then
  configuration_file=".releaserc"
fi
if [ -f "$configuration_file" ]; then
  jq -c -r '.plugins[] | if type=="string" then . else .[0] end' "$configuration_file" | while read -r plugin; do
    # try to install if the plugin is not a default installed one
    # shellcheck disable=SC2199,SC2076
    if [[ ! " ${default_plugins[@]} " =~ " ${plugin} " ]]; then
      # this is not a default plugin
      # look for the version of the semantic release plugin version to install
      # remove the root of the plugin name as environment properties does not support @
      alias="${plugin#"@semantic-release/"}"
      plugin_version="$(get_env "semantic-release-plugin-version-$alias" "")"
      if [ -z "$plugin_version" ]; then
        echo "Installing $plugin latest version"
        npm install --silent "$plugin"
      else
        echo "Installing $plugin@$plugin_version"
        npm install --silent "$plugin@$plugin_version"
      fi
    else
        echo "$plugin is installed by default with semantic-release"
    fi
  done
else
  echo "No $configuration_file file found to inspect package(s)/plugin(s) to install"
fi

# configure semantic-release
GIT_URL=$(echo "$APP_API_URL" | awk -F/ '{ print $1 $2 "//" $3}')
GIT_API_PREFIX=${APP_API_URL:${#GIT_URL}}
if [ "$APP_ABSOLUTE_SCM_TYPE" == "hostedgit" ]; then
  export GITLAB_TOKEN;
  GITLAB_TOKEN="$(cat "$APP_TOKEN_PATH")"
  export GIT_CREDENTIALS="oauth2:$GITLAB_TOKEN" # pragma: allowlist secret
  export GITLAB_URL=$GIT_URL
  export GITLAB_PREFIX=$GIT_API_PREFIX
elif [ "$APP_ABSOLUTE_SCM_TYPE" == "github_integrated" ]; then
  export GITHUB_TOKEN
  GITHUB_TOKEN="$(cat "$APP_TOKEN_PATH")"
  export GIT_CREDENTIALS="x-token-auth:$GITHUB_TOKEN" # pragma: allowlist secret
  export GITHUB_URL=$GIT_URL
  export GITHUB_PREFIX=$GIT_API_PREFIX
else
  export GITHUB_TOKEN
  GITHUB_TOKEN="$(cat "$APP_TOKEN_PATH")"
  export GIT_CREDENTIALS="x-oauth-basic:$GITHUB_TOKEN" # pragma: allowlist secret
  export GITHUB_URL=$GIT_URL
  export GITHUB_PREFIX=$GIT_API_PREFIX
fi

# run semantic-release
sr_output="$WORKSPACE/app-repo_semantic-release.out"
# use --extends parameter to specify a specific configuration file
# https://github.com/semantic-release/semantic-release/issues/1592
if [[ "$configuration_file" != ".releaserc" ]]; then
  # extends parameter expect a directory and file path along with proper suffix
  extends="--extends ./$configuration_file"
fi
if [ -z "$(get_env semantic-release-tag-format "")" ]; then
  tag_format_parameter=""
else
  # shellcheck disable=SC2016,SC2089
  tag_format_parameter="--tag-format '$(get_env semantic-release-tag-format)'"
fi
echo "semantic-release run command is: semantic-release --branches $(cat /config/git-branch) $extends --no-ci $tag_format_parameter"
# shellcheck disable=SC2016,SC2086,SC2046,SC2090
semantic-release --branches "$(cat /config/git-branch)" $extends --no-ci $tag_format_parameter | tee "$sr_output"
semantic_release_exit_code="${PIPESTATUS[0]}"
if [ "$semantic_release_exit_code" -ne "0" ]; then
  echo "semantic-release failed invocation failed. Exiting $semantic_release_exit_code"
  # shellcheck disable=SC2086
  exit $semantic_release_exit_code
fi

semantic_release_mark_as_pre_release=$(get_env semantic-release-mark-as-pre-release "")
# Process semantic release outcome
# TODO: should extend the .releaserc plugin list to have an additional exec that will export the release version
# it would be more robust than parsing using some sed incantation
if grep -q "next release version is" "$sr_output"; then
  NEXT_VERSION=$(grep 'next release version is ' "$sr_output" | sed -E 's/.* ([[:digit:].]+)$/\1/')
  NEXT_TAG=$(grep 'Created tag ' "$sr_output")
  NEXT_TAG="${NEXT_TAG#*Created tag }"
  echo "Semantic Release log NEXT_VERSION as $NEXT_VERSION"
  echo "Semantic Release log NEXT_TAG as  $NEXT_TAG"
  set_env release-version "$NEXT_VERSION"
  set_env release-tag "$NEXT_TAG"
  if [[ $APP_SCM_TYPE == "gitlab" ]]; then
      if [ -n "$semantic_release_mark_as_pre_release" ]; then
        echo "pre-release mark is not available for this Git flavor"
      fi
      # shellcheck disable=SC2086
      curl -H "PRIVATE-TOKEN: $(cat ${APP_TOKEN_PATH})" "${APP_API_URL}/projects/$(echo ${APP_REPO_OWNER}/${APP_REPO_NAME} | jq -rR @uri)/releases/$(get_env release-tag)" | tee "$WORKSPACE/release.json"
      # Find the sources tar.gz download url
      sources_tar_gz_url=$(jq -r '.assets.sources[] | select(.format == "tar.gz") | .url' "$WORKSPACE/release.json")
      # Find the artifact url for download
      jq --arg file "$(load_artifact iac name)" '.assets.links[] | select(.url | endswith($file))' "$WORKSPACE/release.json" > "$WORKSPACE/asset_link.json"
      browser_download_url=$(jq -r -c '.url' "$WORKSPACE/asset_link.json")
      # Gitlab lacks api to download asset content
      # only use browser_download_url for now
      # - https://gitlab.com/gitlab-org/gitlab/-/issues/25838
      # - https://gitlab.com/gitlab-org/gitlab/-/issues/358188
      artifact_url=$browser_download_url
  else
      # find the release id from tag name
      # shellcheck disable=SC2086
      release_id=$(curl -H "Authorization: Bearer $(cat ${APP_TOKEN_PATH})" "${APP_API_URL}/repos/${APP_REPO_OWNER}/${APP_REPO_NAME}/releases/tags/$(get_env release-tag)" | jq '.id')
      echo "release id for $(get_env release-tag) is $release_id"
      if [ -n "$semantic_release_mark_as_pre_release" ]; then
        echo "Patching $release_id to make it a pre-release and find artifact url"
        # shellcheck disable=SC2086
        curl -H "Authorization: Bearer $(cat ${APP_TOKEN_PATH})" "${APP_API_URL}/repos/${APP_REPO_OWNER}/${APP_REPO_NAME}/releases/$release_id" -X PATCH -d '{"prerelease":true}' | tee "$WORKSPACE/$release_id.json"
      else
        echo "Finding artifact url for $release_id"
        # shellcheck disable=SC2086
        curl -H "Authorization: Bearer $(cat ${APP_TOKEN_PATH})" "${APP_API_URL}/repos/${APP_REPO_OWNER}/${APP_REPO_NAME}/releases/$release_id" | tee "$WORKSPACE/$release_id.json"
      fi
      # Compute the sources tar.gz download url
      sources_tar_gz_url="${APP_REPO}/archive/refs/tags/$(get_env release-tag).tar.gz"
      # Compute browser download url
      browser_download_url="${APP_REPO}/releases/download/$(get_env release-tag)/$(load_artifact iac name)"
      # Find the artifact url for download
      artifact_url=$(jq -r --arg browser_download_url "$browser_download_url" '.assets[] | select(.browser_download_url==$browser_download_url) | .url' "$WORKSPACE/$release_id.json")
  fi
  save_artifact iac "tag=$(get_env release-tag)" "url=$artifact_url" "browser_download_url=$browser_download_url" "sources_tar_gz_url=$sources_tar_gz_url"
elif grep -q "so no new version is released" "$sr_output"; then
  EXISTING_VERSION=$(grep 'associated with version ' "$sr_output" | awk '{ sub(/.*associated with version /, ""); sub(/on branch.*/, ""); print }')
  echo "Semantic Release log EXISTING_VERSION as $EXISTING_VERSION"
  set_env existing-version "$EXISTING_VERSION"
else
  echo "No Semantic Release created version found in log"
  exit 1
fi