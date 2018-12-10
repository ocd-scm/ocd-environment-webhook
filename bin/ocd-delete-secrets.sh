#!/bin/bash

# find all the the *secret files and delete the unecrypted version
find ${OCD_CHECKOUT_PATH} -type f -name '*secret' | while read -r SECRET ; do 
    if [ -f "${SECRET%.*}" ]; then
        rm "${SECRET%.*}"
    fi
done