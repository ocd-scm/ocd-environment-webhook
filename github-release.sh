#!/bin/bash

NAME=ocd-environment-webhook

if [ -z "$GITHUB_USER" ]; then
    >&2 echo "please define GITHUB_USER as an env var"
    exit 2
fi

if [ -z "$GITHUB_OAUTH_TOKEN" ]; then
    >&2 echo "please define GITHUB_OAUTH_TOKEN as an env var"
    exit 2
fi

mkdir -p ~/.config
# https://github.com/github/hub/issues/978#issuecomment-131964409
cat >~/.config/hub <<EOL
---
github.com:
- protocol: https
  user: ${GITHUB_USER}
  oauth_token: ${GITHUB_OAUTH_TOKEN}
EOL

cd $NAME

NAME=$(cat Chart.yaml | yq .name | sed 's/"//g' )
VERSION=$(cat Chart.yaml | yq .version | sed 's/"//g')
echo NAME=$NAME VERSION=$VERSION

helm package . 

hub release create -a "$NAME-$VERSION.tgz" -m "$NAME helm chart $VERSION" $NAME-$VERSION
