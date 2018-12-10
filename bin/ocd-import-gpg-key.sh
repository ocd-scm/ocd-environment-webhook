#!/bin/bash

# this wrapper will detected session timeout and login

oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}

if [ "$(ls gpg/*.prv.key | wc -l)" -ne "1" ]; then
    >2& echo "more than one prv.key found at gpg/*.prv.key"
    exit 1
fi

# parse the fingerprint out of the private key name
FINGERPRINT=$(ls gpg/*.prv.key | sed 's/gpg\/\(.*\)\.prv\.key/\1/g')

# check the key is there
gpg --list-secret-keys | grep $FINGERPRINT

if [ "$?" -ne "0" ]; then
    oc project $PROJECT 
    PASSPHRASE=$(oc get secrets openshift-passphrase -o yaml | grep passphrase: | awk '{print $2}' | base64 --decode)
    KEY=$(find ${OCD_CHECKOUT_PATH} -name ocd-private.key)
    echo $PASSPHRASE | gpg --pinentry loopback --import --passphrase-fd 0 $(ls gpg/*.prv.key)
    # check the key is there
    gpg --list-secret-keys | grep $FINGERPRINT
    if [ "$?" -ne "0" ]; then
        >&2 echo "Could not import key from $(ls gpg/*.prv.key)"
    fi
fi
