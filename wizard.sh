#!/bin/bash

[ -z "${TILLER_NAMESPACE}" ] && >&2 echo "ERROR you must define TILLER_NAMESPACE" && exit -1

OCD_PROJECT=$(oc project --short)
echo "OCD_PROJECT=${OCD_PROJECT}"

OCD_SERVER=$(oc project | sed 's/.*"https:\/\/\([^"].*\)".*/\1/g')
echo "OCD_SERVER=${OCD_SERVER}"

read -p "The git repo url? " OCD_GIT_URL

if [ -z "${OCD_GIT_URL}" ] || [ "${OCD_GIT_URL}" == "" ]; then
     >&2 echo "ERROR you must provide a git url"
     exit 2
fi

read -p "The project where the images are built and promoted from? " OCD_BUILD_NAMESPACE

if [ -z "${OCD_BUILD_NAMESPACE}" ] || [ "${OCD_BUILD_NAMESPACE}" == "" ]; then
     >&2 echo "ERROR you must provide a build namespace (e.g., your-eng)"
     exit 2
fi

OCD_REPO_FULLNAME_GUESS=$(echo $OCD_GIT_URL | awk -F '/' '{print $(NF-1) "/" $NF}' | sed 's/\.git$//1')

read -p "Repo name? (default: $OCD_REPO_FULLNAME_GUESS): " OCD_REPO_FULLNAME
[ -z "${OCD_REPO_FULLNAME}" ] && OCD_REPO_FULLNAME=$OCD_REPO_FULLNAME_GUESS

read -p "Branch ref? (default: refs/heads/master): " OCD_BRANCH
[ -z "${OCD_BRANCH}" ] && OCD_BRANCH="refs/heads/master"

read -p "Chart instance prefix? (default: $OCD_PROJECT): " OCD_PREFIX
[ -z "${OCD_PREFIX}" ] && OCD_PREFIX=$OCD_PROJECT

read -p "Use --insecure-no-tls-verify? (default: false): " OCD_NO_TLS_VERIFY
[ -z "${OCD_NO_TLS_VERIFY}" ] && OCD_NO_TLS_VERIFY=false

read -p "Chatbot base64 encoded notify script? " OCD_CHATBOT_NOTIFY

set +x

./installer.bash \
  --insecure-no-tls-verify="$OCD_NO_TLS_VERIFY" \
  --chatbot-announce="$OCD_CHATBOT_NOTIFY" \
  "$OCD_SERVER"   \
  "$TILLER_NAMESPACE" \
  "$OCD_PROJECT" \
  "$OCD_BUILD_NAMESPACE" \
  "$OCD_GIT_URL" \
  "$OCD_REPO_FULLNAME" \
  "$OCD_BRANCH"  \
  "$OCD_PREFIX"
