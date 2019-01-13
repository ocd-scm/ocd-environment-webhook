#!/bin/bash

# This script is sourced by argbash.m4 that sets the variables

if [ -z "$_arg_oc_server" ]; then
    >&2 echo "Please define 'oc-server'"
    exit 1
fi

if [ -z "$_arg_oc_user" ]; then
    >&2 echo "Please define 'oc-user'"
    exit 2
fi

if [ -z "$_arg_oc_passwd" ]; then
    >&2 echo "Please define 'oc-passwd'"
    exit 3
fi

if [ -z "$_arg_tiller_namespace" ]; then
    >&2 echo "Please define 'tiller-namespace'"
    exit 4
fi

if [ -z "$_arg_namespace" ]; then
    >&2 echo "Please define 'namespace'"
    exit 5
fi

if [ -z "$_arg_git_url" ]; then
    >&2 echo "Please define 'git-url'"
    exit 5
fi

if [ -z "$_arg_git_name" ]; then
    >&2 echo "Please define 'git-name'"
    exit 5
fi

printf 'Value of --%s: %s\n' 'oc-server' "$_arg_oc_server"
printf 'Value of --%s: %s\n' 'oc-user' "$_arg_oc_user"
printf 'Value of --%s: %s\n' 'oc-passwd' "$_arg_oc_passwd"
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
OPENSHIFT_USER="$_arg_oc_user"
OPENSHIFT_PASSWORD="$_arg_oc_passwd"
TILLER_NAMESPACE="$_arg_tiller_namespace"
PROJECT="$_arg_namespace"
INSECURE_NO_TLS_VERIFY="$_arg_insecure_no_tls_verify"
GIT_URL="$_arg_git_url"
GIT_NAME="$_arg_git_name"
WEBHOOK_REF_REGEX="$_arg_webhook_ref_regex"
ENV_PREFIX="$_arg_env"
WEBHOOK_SECRET="$_arg_webhook_secret"
HOOKS_RELEASE="$_arg_release_hook"

echo WARNING is will fail unless you have run: oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

helmfile --log-level debug apply

set +a
)
