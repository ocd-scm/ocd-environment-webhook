#!/bin/bash

if [ -z "${TILLER_NAMESPACE}" ]; then
  >&2 echo "ERROR: TILLER_NAMESPACE is not defined. Exiting."
  exit 1
fi

# this wrapper will detected session timeout and login
oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}

# force a login to the the correct project if the session has timed out
oc project $PROJECT

# this show the curren state but also forces an eror if helm needs init after container restart
helm repo list
if [ "$?" != "0" ]; then
  # restart
  helm init --client-only  
fi

set -x

# down to work. rather than one monster helmfile we check for many and run each
find ${OCD_CHECKOUT_PATH} -name helmfile.yaml | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  pushd $folder

  # it would be nice if helmfile had this event hook
  if [ -f ./ocd-pre-apply-hook ]; then
    echo running $folder/ocd-pre-apply-hook
    ./ocd-pre-apply-hook
  fi

  # here we use a subshell to jail the env vars loaded fro the file in the current folder
  (

    if [ -f ./envvars ]; then
      echo loading $folder/envvars
      set -a 
      # shellcheck disable=SC1091
      source ./envvars
      set +a
    fi
     
    helmfile --log-level debug apply 
  )

  # it would be nice if helmfile had this event hook
  if [ -f ./ocd-post-apply-hook ]; then
    echo running $folder/ocd-post-apply-hook
    ./ocd-post-apply-hook
  fi

  popd
done
