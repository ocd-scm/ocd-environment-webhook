#!/bin/bash
# find all the the *secret files and delete the unecrypted version
find . -type f -name '*secret' | while read -r SECRET ; do 
    if [ -f "${SECRET%.*}" ]; then
        echo "disabled due to https://github.com/roboll/helmfile/issues/412"
        #rm "${SECRET%.*}"
    fi
done