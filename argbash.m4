#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.7.1
# ARG_OPTIONAL_SINGLE([oc-server], [s], [mandatory e.g. 192.168.99.100:8443])
# ARG_OPTIONAL_SINGLE([oc-user], [u], [mandatory username e.g. admin])
# ARG_OPTIONAL_SINGLE([oc-passwd], [p], [mandatory password e.g. admin])
# ARG_OPTIONAL_SINGLE([tiller-namespace], [t], [mandatory namespace where tiller is running])
# ARG_OPTIONAL_SINGLE([namespace], [n], [mandatory namespace to instal into])
# ARG_OPTIONAL_SINGLE([insecure-no-tls-verify], [], [optional skip TLS verify needed for minishift])
# ARG_POSITIONAL_SINGLE([git-url], [mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git ])
# ARG_POSITIONAL_SINGLE([git-name], [mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build])
# ARG_POSITIONAL_SINGLE([webhook-ref], [mandatory the git ref that fires the webhook e.g. refs/heads/master])
# ARG_HELP([Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.])
# ARGBASH_GO

# [ <-- needed because of Argbash

source ./install.sh

# ] <-- needed because of Argbash
