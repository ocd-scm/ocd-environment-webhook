#!/bin/bash

# this wrapper will detected session timeout and login

export GNUPGHOME=/opt/app-root/work/.gnupg/

oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}

oc project $PROJECT 

PASSPHRASE=$(oc get secrets openshift-passphrase -o yaml | grep passphrase: | awk '{print $2}' | base64 --decode)

if [ ! -d /opt/app-root/work/.gnupg ]; then
    mkdir /opt/app-root/work/.gnupg
    chmod og-wrx /opt/app-root/work/.gnupg
fi

KEY=$(find ${OCD_CHECKOUT_PATH} -name ocd-private.key)
echo $PASSPHRASE | gpg --pinentry loopback --import --passphrase-fd 0 $KEY
