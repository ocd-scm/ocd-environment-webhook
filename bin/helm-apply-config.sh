#!/bin/bash

REPO=$1
REF=$2

echo "called for repo $REPO and ref $REF"

echo "repo url $ENV_GIT_URL"



# echo running all helm scripts at "$(dirname $0)/secrets"

# # gpg decrypt all the *secret files
# find . -type f -name '*secret' | while read -r SECRET ; do 
#     if [ ! -f "${SECRET%.*}" ]; then
#         gpg --output "${SECRET%.*}" --decrypt "${SECRET%.*}.secret" 2>/dev/null
#         if [ ! -f "${SECRET%.*}" ]; then
#             echo "PANIC! could not decript ${SECRET%.*}.secret Have you git secret told the hubot user?"
#             exit 1
#         fi
#     fi
# done

# # apply all the secrets
# find $(dirname $0)/secrets -name helm-\*.sh | while read HELM_SCRIPT; do
#     echo "$HELM_SCRIPT"
#     $HELM_SCRIPT
# done