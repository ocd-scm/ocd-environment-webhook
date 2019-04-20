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
  # reinit
  helm init --client-only  
fi

set -x

# source envvar in the top level folder
if [ -f "${OCD_CHECKOUT_PATH}/envvars" ]; then
  echo "loading ${OCD_CHECKOUT_PATH}/envvars"
  set -a 
  # shellcheck disable=SC1091
  source "${OCD_CHECKOUT_PATH}/envvars"
  set +a
fi

# run any ocd-pre-apply-hook in the top level folder
# it would be nice if helmfile had this pre global event hook
if [ -f "${OCD_CHECKOUT_PATH}/ocd-pre-apply-hook" ]; then
  echo running ${OCD_CHECKOUT_PATH}/ocd-pre-apply-hook
  pushd ${OCD_CHECKOUT_PATH}
  ./ocd-pre-apply-hook
  popd
fi

# down to work. rather than one monster helmfile can have on per microservice in own folder with own env vars
find ${OCD_CHECKOUT_PATH} -name helmfile.yaml | sort | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  pushd $folder

  # here we use a subshell to jail the env vars loaded from the file in the current folder
  (

    if [ -f ./envvars ]; then
      echo "loading $folder/envvars"
      set -a 
      # shellcheck disable=SC1091
      source ./envvars
      set +a
    fi

    # it would be nice if helmfile had this event hook
    if [ -f ./ocd-pre-apply-hook ]; then
      echo running $folder/ocd-pre-apply-hook
      ./ocd-pre-apply-hook
    fi

    if [ -z "${OCD_LOG_LEVEL}" ]; then
      OCD_LOG_LEVEL=info
    fi

    helmfile --log-level $OCD_LOG_LEVEL apply 

    # it would be nice if helmfile had this event hook
    if [ -f ./ocd-post-apply-hook ]; then
      echo running $folder/ocd-post-apply-hook
      ./ocd-post-apply-hook
    fi

  )

  popd
done

# run any ocd-post-apply-hook in the top level folder
# it would be nice if helmfile had this pre global event hook
if [ -f "${OCD_CHECKOUT_PATH}/ocd-post-apply-hook" ]; then
  echo running ${OCD_CHECKOUT_PATH}/ocd-post-apply-hook
  pushd ${OCD_CHECKOUT_PATH}
  ./ocd-post-apply-hook
  popd
fi
