#!/bin/bash

set +x

REPO_REF=$1

cd ${OCD_CHECKOUT_PATH}/..

# we are running in a random assigned uid with no matching /etc/password
# so we sythesis an entry as per https://docs.openshift.com/enterprise/3.1/creating_images/guidelines.html#openshift-enterprise-specific-guidelines
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
cat /etc/passwd > /tmp/passwd
echo ocd:x:${USER_ID}:${GROUP_ID}:OCD Env Webhookr:${HOME}:/bin/bash > ./passwd.template
envsubst < ./passwd.template >> /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

# Convert  /opt/app-root/work/checkout to checkout
FOLDER_NAME=$(basename ${OCD_CHECKOUT_PATH})

# checkout the code
if [ ! -d $FOLDER_NAME ]; then
  git clone --depth 1 --single-branch $ENV_GIT_URL $FOLDER_NAME
fi

cd $FOLDER_NAME; 

if [[ "${HOOKS_RELEASE}" == "true" ]]; then
  git fetch origin $REPO_REF
  git fetch --all
  git checkout tags/$REPO_REF
else 
  git checkout $REPO_REF
  git pull -X theirs
fi