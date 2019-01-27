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
set +a

echo WARNING is will fail unless you have run: oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

# create a release of the ocd-environment-webhook
helmfile --log-level debug apply

# mount the servie account secret so that the app can login and talk to tiller
MOUNTABLE_SECRETS='Mountable secrets:'
SECRET_NAME=$(oc describe sa sa-ocd-${PROJECT} | sed $(printf 's/./&,/%s' ${#MOUNTABLE_SECRETS}) | awk  'BEGIN{FS=OFS=","} {if ($1 ~ /^[ \t]*$/) $1=ch; else ch=$1} 1'  | grep "$MOUNTABLE_SECRETS" | sed 's/[, ]*//g' | awk -F':' '{print $2}' | grep -v docker | grep token)
echo "mounting service account secret named '$SECRET_NAME' into dc/ocd-environment-webhook"
oc set volume dc/ocd-environment-webhook --add --name=sa-secret-volume --mount-path=/sa-secret-volume --secret-name=$SECRET_NAME

# ensure that the service account can access tiller
oc get role podreadertiller 2>/dev/null
if [[ "$?" != "0" ]]; then
    oc create role podreadertiller --verb=get,list,watch --resource=pod -n "$TILLER_NAMESPACE"
    oc create role portforwardtiller --verb=create,get,list,watch --resource=pods/portforward -n "$TILLER_NAMESPACE"
    oc policy add-role-to-user podreadertiller "system:serviceaccount:${PROJECT}:sa-ocd-${PROJECT}" --role-namespace="$TILLER_NAMESPACE" -n "$TILLER_NAMESPACE"
    oc policy add-role-to-user portforwardtiller "system:serviceaccount:${PROJECT}:sa-ocd-${PROJECT}" --role-namespace="$TILLER_NAMESPACE" -n "$TILLER_NAMESPACE"
fi


)
