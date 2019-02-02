#!/bin/bash

PROMOTE_PROJECT_FROM=$1
PROMOTE_PROJECT_TO=$2
IMAGE=$3
TAG=$4

oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@"
}

if [ -z ${PROMOTE_PROJECT_FROM} ]; then
    >&2 echo "ERROR - $0 please define PROMOTE_PROJECT_FROM."
    exit 1
fi

if [ -z ${PROMOTE_PROJECT_TO} ]; then
    >&2 echo "ERROR - $0 please define PROMOTE_PROJECT_TO."
    exit 2
fi

if [ -z ${IMAGE} ]; then
    >&2 echo "ERROR - $0 please IMAGE."
    exit 3
fi

if [ -z ${TAG} ]; then
    >&2 echo "ERROR - $0 please specify an TAG."
    exit 4
fi

set +x

if ! oc get imagestream  "$IMAGE" -n "${PROMOTE_PROJECT_TO}"
then
    echo "Creating image stream  $IMAGE in ${PROMOTE_PROJECT_TO}"
    oc create imagestream "$IMAGE" -n  "${PROMOTE_PROJECT_TO}"
fi

if [ -n "${IMAGE}" ] && [ -n "${PROMOTE_PROJECT_FROM}" ] && [ -n "${PROMOTE_PROJECT_TO}" ]; then 
    echo promoting "$IMAGE" using tag "$TAG" from "$PROMOTE_PROJECT_FROM" to "$PROMOTE_PROJECT_TO"
    oc tag "$PROMOTE_PROJECT_FROM/$IMAGE:$TAG" "$PROMOTE_PROJECT_TO/$IMAGE:$TAG"
fi