#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.7.1
# ARG_OPTIONAL_SINGLE([insecure-no-tls-verify], [], [optional skip TLS verify needed for minishift], [false])
# ARG_OPTIONAL_SINGLE([webhook-secret], [], [optional webhook secret will otherwise be generated], [])
# ARG_OPTIONAL_SINGLE([release-hook], [], [optional match a release event rather than a push event], [false])
# ARG_OPTIONAL_SINGLE([chatbot-announce], [], [optional base64 encoded shell script to announce deployments into a chatroom])
# ARG_POSITIONAL_SINGLE([oc-server], [mandatory server e.g. 192.168.99.100:8443])
# ARG_POSITIONAL_SINGLE([tiller-namespace], [mandatory namespace where tiller is running])
# ARG_POSITIONAL_SINGLE([namespace], [mandatory namespace to install into])
# ARG_POSITIONAL_SINGLE([build-namespace], [mandatory namespace where images are built])
# ARG_POSITIONAL_SINGLE([git-url], [mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git ])
# ARG_POSITIONAL_SINGLE([git-name], [mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build])
# ARG_POSITIONAL_SINGLE([webhook-ref-regex], [mandatory the regex to match the git ref e.g. "refs/heads/master" to match a branch or ".*-RELEASE" to match a release tag])
# ARG_POSITIONAL_SINGLE([env], [mandatory the env prefix to make the installed chart unique e.g. live])
# ARG_DEFAULTS_POS
# ARG_HELP(Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.)
# ARGBASH_GO

# [ <-- needed because of Argbash

source ./install.sh

# ] <-- needed because of Argbash
