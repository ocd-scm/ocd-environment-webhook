#!/bin/bash

set -e

helm upgrade --install \
    --set "insecureSkipTlsVerify=true,webhookRepFullname=simbo1905/demo1,envGitUrl=https://github.com/ocd-scm/ocd-demo-env-staging.git" \
    ocd-environment-webhook \
    ocd-environment-webhook-1.0.0.tgz

# oc expose service/ocd-builder-webhook

# PROJECT=$(oc project --short)
# echo $PROJECT

# HOSTNAME=$(oc get routes | grep ocd-builder-webhook | awk '{print $2}' | sed "s/^[^\.]*/gitea-$PROJECT/1")
# echo $HOSTNAME

# # install gitea https://github.com/wkulhanek/docker-openshift-gitea
# oc new-app -f https://raw.githubusercontent.com/wkulhanek/docker-openshift-gitea/master/openshift/gitea-persistent-template.yaml --param=HOSTNAME=$HOSTNAME
