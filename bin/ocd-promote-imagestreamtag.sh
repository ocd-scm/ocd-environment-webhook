#!/bin/bash

PROMOTE_PROJECT_FROM=$1
PROMOTE_PROJECT_TO=$2
IMAGE=$3
TAG=$4

oc() { 
    bin/oc_wrapper.sh $@ 
}

if [ -z ${PROMOTE_PROJECT_FROM} ]; then
    echo "please define PROMOTE_PROJECT_FROM"
fi

if [ -z ${PROMOTE_PROJECT_TO} ]; then
    echo "please define PROMOTE_PROJECT_TO"
fi

IMAGE=$1

if [ -z ${IMAGE} ]; then
    echo "please specify an image."
fi

if [ -n ${IMAGE} ] && [ -n ${PROMOTE_PROJECT_FROM} ] && [ -n ${PROMOTE_PROJECT_TO} ]; then 
    echo promoting $IMAGE using tag $TAG from $PROMOTE_PROJECT_FROM to $PROMOTE_PROJECT_TO
    oc tag $PROMOTE_PROJECT_FROM/$IMAGE:$TAG $PROMOTE_PROJECT_TO/$IMAGE:$TAG
fi