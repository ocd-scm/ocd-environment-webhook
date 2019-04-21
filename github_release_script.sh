#!/bin/bash

# https://github.com/travis-ci/dpl/issues/155
# https://gist.github.com/Jaskaranbir/d5b065173b3a6f164e47a542472168c1

REPO_NAME=ocd-scm/ocd-environment-webhook

LAST_RELEASE_TAG=$(curl https://api.github.com/repos/$REPO_NAME/releases/latest 2>/dev/null | jq .tag_name | sed 's/"//g')

echo "LAST_RELEASE_TAG=$LAST_RELEASE_TAG"

# An automatic changelog generator
if ! gem list | grep github_changelog_generator; then 
    gem install github_changelog_generator
fi

# move the manual log out of the way else it will be used by the tool. 
rm CHANGELOG.md

# Generate CHANGELOG.md
github_changelog_generator \
  -u $(cut -d "/" -f1 <<< $REPO_NAME) \
  -p $(cut -d "/" -f2 <<< $REPO_NAME) \
  --token $GITHUB_OAUTH_TOKEN \
  --since-tag ${LAST_RELEASE_TAG}

body="$(cat CHANGELOG.md)"

# GitHub API needs json data. here we use the mighty jq from https://stedolan.github.io/jq/
jq -n \
  --arg body "$body" \
  --arg name "$TRAVIS_TAG" \
  --arg tag_name "$TRAVIS_TAG" \
  --arg target_commitish "$GIT_BRANCH" \
  '{
    body: $body,
    name: $name,
    tag_name: $tag_name,
    target_commitish: $target_commitish,
    draft: true,
    prerelease: false
  }' > CHANGELOG.md

echo "Create release $TRAVIS_TAG for repo: $REPO_NAME, branch: $GIT_BRANCH"
curl -H "Authorization: token $GITHUB_OAUTH_TOKEN" --data @CHANGELOG.md "https://api.github.com/repos/$REPO_NAME/releases"
