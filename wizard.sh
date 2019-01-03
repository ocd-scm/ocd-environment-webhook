#!/bin/bash

[ -z "${TILLER_NAMESPACE}" ] && >&2 echo "ERROR you must define TILLER_NAMESPACE" && exit -1

OCD_PROJECT=$(oc project --short)
echo "OCD_PROJECT=${OCD_PROJECT}"

OCD_SERVER=$(oc project | sed 's/.*"https:\/\/\([^"].*\)".*/\1/g')
echo "OCD_SERVER=${OCD_SERVER}"

read -p "User to run the environment webhook? " OCD_USER

if [ -z "${OCD_USER}" ] || [ "${OCD_USER}" == "" ]; then
     >&2 echo "ERROR you must provide a user"
     exit 1
fi

read -p "Password of the user? " OCD_PASSWORD

if [ -z "${OCD_PASSWORD}" ] || [ "${OCD_PASSWORD}" == "" ]; then
     >&2 echo "ERROR you must provide a password"
     exit 2
fi

read -p "The git repo url (consider using a person access token)? " OCD_GIT_URL

if [ -z "${OCD_GIT_URL}" ] || [ "${OCD_GIT_URL}" == "" ]; then
     >&2 echo "ERROR you must provide a git url"
     exit 2
fi

OCD_REPO_FULLNAME_GUESS=$(echo $OCD_GIT_URL | awk -F '/' '{print $(NF-1) "/" $NF}' | sed 's/\.git$//1')

read -p "Repo name? (default: $OCD_REPO_FULLNAME_GUESS): " OCD_REPO_FULLNAME
[ -z "${OCD_REPO_FULLNAME}" ] && OCD_REPO_FULLNAME=$OCD_REPO_FULLNAME_GUESS

read -p "Branch ref? (default: refs/heads/master): " OCD_BRANCH
[ -z "${OCD_BRANCH}" ] && OCD_BRANCH="refs/heads/master"

read -p "Chart instance prefix? (default: $OCD_PROJECT): " OCD_PREFIX
[ -z "${OCD_PREFIX}" ] && OCD_PREFIX=$OCD_PROJECT

set +x

./installer.bash \
  $OCD_SERVER   \
  $OCD_USER   \
  $OCD_PASSWORD  \
  $TILLER_NAMESPACE \
  $OCD_PROJECT \
  $OCD_GIT_URL \
  $OCD_REPO_FULLNAME \
  $OCD_BRANCH  \
  $OCD_PREFIX
