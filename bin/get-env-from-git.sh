#!/bin/bash

# we are running in a random assigned uid with no matching /etc/password
# so we sythesis as per https://docs.openshift.com/enterprise/3.1/creating_images/guidelines.html#openshift-enterprise-specific-guidelines
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
cat /etc/passwd > /tmp/passwd
echo ocd:x:${USER_ID}:${GROUP_ID}:OCD Env Webhookr:${HOME}:/bin/bash > ./passwd.template
envsubst < ./passwd.template >> /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

# checkout or update the code
if [ ! -d checkout ]; then
  git clone --depth 1 --single-branch $ENV_GIT_URL checkout
else
  cd checkout; git pull -Xthiers origin master
fi