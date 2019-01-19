#!/bin/bash

# try assuming our previous login hasn't timed out
oc ${INSECURE_SKIP_TLS_VERIFY} "$@" 2>/dev/null

# if it didn't work assume that we have yet to login or it timed out
if [[ "$?" != "0" ]]; then

    # do login
    oc login ${INSECURE_SKIP_TLS_VERIFY} \
        ${OPENSHIFT_SERVER} \
        --certificate-authority='/sa-secret-volume/ca.crt' \
        --token="$(< /sa-secret-volume/token)"

    if [[ "$?" != "0" ]]; then
        (>&2 echo "ERROR Could not oc login. Exiting")
        exit 3
    fi

    #try again
    oc ${INSECURE_SKIP_TLS_VERIFY} "$@"
fi
