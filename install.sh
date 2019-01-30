#!/bin/bash

# This script is sourced by argbash.m4 that sets the variables

if [ -z "$_arg_oc_server" ]; then
    >&2 echo "Please define 'oc-server'"
    exit 1
fi

if [ -z "$_arg_tiller_namespace" ]; then
    >&2 echo "Please define 'tiller-namespace'"
    exit 2
fi

if [ -z "$_arg_namespace" ]; then
    >&2 echo "Please define 'namespace'"
    exit 3
fi

if [ -z "$_arg_git_url" ]; then
    >&2 echo "Please define 'git-url'"
    exit 4
fi

if [ -z "$_arg_git_name" ]; then
    >&2 echo "Please define 'git-name'"
    exit 5
fi

printf 'Value of --%s: %s\n' 'oc-server' "$_arg_oc_server"
printf 'Value of --%s: %s\n' 'tiller-namespace' "$_arg_tiller_namespace"
printf 'Value of --%s: %s\n' 'namespace' "$_arg_namespace"
printf 'Value of --%s: %s\n' 'insecure-no-tls-verify' "$_arg_insecure_no_tls_verify"
printf 'Value of --%s: %s\n' 'git-url' "$_arg_git_url"
printf 'Value of --%s: %s\n' 'git-name' "$_arg_git_name"
printf "Value of '%s': %s\\n" 'webhook-ref' "$_arg_webhook_ref"

set -e
set -x

(
set -a
OPENSHIFT_SERVER="$_arg_oc_server"
TILLER_NAMESPACE="$_arg_tiller_namespace"
PROJECT="$_arg_namespace"
INSECURE_NO_TLS_VERIFY="$_arg_insecure_no_tls_verify"
GIT_URL="$_arg_git_url"
GIT_NAME="$_arg_git_name"
WEBHOOK_REF_REGEX="$_arg_webhook_ref_regex"
ENV_PREFIX="$_arg_env"
WEBHOOK_SECRET="$_arg_webhook_secret"
HOOKS_RELEASE="$_arg_release_hook"
BUILD_NAMESPACE="$_arg_build_amespace"
set +a

echo WARNING is will fail unless you have run: oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

# create a release of the ocd-environment-webhook
helmfile --log-level debug apply

export USER="system:serviceaccount:${PROJECT}:sa-ocd-${PROJECT}"

# ensure that the service account can access tiller
if ! oc policy who-can list pods -n "$TILLER_NAMESPACE" | grep  "$USER" 2>/dev/null 1>/dev/null
then
    if ! oc get roles -n  "$TILLER_NAMESPACE" | grep podreadertiller 2>/dev/null 1>/dev/null
    then
        oc create role podreadertiller --verb=get,list,watch --resource=pod -n "$TILLER_NAMESPACE"
        oc create role portforwardtiller --verb=create,get,list,watch --resource=pods/portforward -n "$TILLER_NAMESPACE"
    fi
    oc policy add-role-to-user podreadertiller "$USER" --role-namespace="$TILLER_NAMESPACE" -n "$TILLER_NAMESPACE"
    oc policy add-role-to-user portforwardtiller "$USER" --role-namespace="$TILLER_NAMESPACE" -n "$TILLER_NAMESPACE"
fi

# ensure the service account can promote images
if ! oc policy who-can get imagestreams -n "$BUILD_NAMESPACE" | grep  "$USER" 1>/dev/null 2>/dev/null
then
    oc policy add-role-to-user ocd-environment-webhookisreader "$USER" --role-namespace="$BUILD_NAMESPACE" -n "$BUILD_NAMESPACE"
fi


)
