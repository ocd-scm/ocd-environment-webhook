#!/bin/bash

# this wrapper will detected session timeout and login
oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}

# later logic assumes one private key and many sounds wrong
if [ "$(ls gpg/*.prv.key | wc -l)" -ne "1" ]; then
    >2& echo "ERROR Did not find exactly one file at gpg/*.prv.key"
    exit 1
fi

# see https://github.com/ocd-scm/ocd-meta/wiki/Encrypting-Secrets#using-a-gnupg-private-key
# parse the fingerprint out of the private key name
FINGERPRINT=$(ls gpg/*.prv.key | sed 's/gpg\/\(.*\)\.prv\.key/\1/g')

# check the key has alredy been imported
gpg --list-secret-keys | grep $FINGERPRINT

# if the key hasn't been imported load the key passphrase from the environment
if [ "$?" -ne "0" ]; then
    oc project $PROJECT 
    # see https://github.com/ocd-scm/ocd-meta/wiki/Encrypting-Secrets#using-a-gnupg-private-key
    PASSPHRASE=$(oc get secrets openshift-passphrase -o yaml | grep passphrase: | awk '{print $2}' | base64 --decode)
    echo $PASSPHRASE | gpg --pinentry loopback --import --passphrase-fd 0 $(ls gpg/*.prv.key)
    # check the key is there
    gpg --list-secret-keys | grep $FINGERPRINT
    if [ "$?" -ne "0" ]; then
        >&2 echo "ERROR: Could not import key from $(ls gpg/*.prv.key)"
        exit 2
    fi
fi
