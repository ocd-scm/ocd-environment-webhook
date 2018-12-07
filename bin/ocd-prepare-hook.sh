#!/bin/bash

export GNUPGHOME=/opt/app-root/work/.gnupg/

${OCD_SCRIPTS_PATH}/ocd-import-gpg-key.sh

# this wrapper will detected session timeout and login
oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}

oc project $PROJECT 

PASSPHRASE=$(oc get secrets openshift-passphrase -o yaml | grep passphrase: | awk '{print $2}' | base64 --decode)

# gpg decrypt all the *secret files
find ${OCD_CHECKOUT_PATH} -type f -name '*secret' | while read -r SECRET ; do 
    if [ ! -f "${SECRET%.*}" ]; then
        echo $PASSPHRASE | gpg --pinentry loopback --passphrase-fd 0 --output "${SECRET%.*}" --decrypt "${SECRET%.*}.secret"
        if [ ! -f "${SECRET%.*}" ]; then
            >&2 echo "PANIC! Could not decrypt ${SECRET%.*}.secret. Check 'git secret whoknows' against 'gpg --list-secret-keys'"
            exit 1
        fi
    fi
done
