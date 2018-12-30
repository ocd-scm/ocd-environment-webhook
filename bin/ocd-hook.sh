#!/bin/bash
REPO_REF=$1
${OCD_SCRIPTS_PATH}/ocd-checkout-env.sh $REPO_REF && ${OCD_SCRIPTS_PATH}/ocd-environment.sh
