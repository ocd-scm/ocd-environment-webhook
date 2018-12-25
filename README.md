# ocd-environment-webhook

## Status

This repo close to a milestone release. You can watch the repo to get notified when it has something to show.

## Installation

See the installer: 

```
Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodicall
y login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permission
s to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this
 in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.
Usage: ./installer.bash [--insecure-no-tls-verify <arg>] [-h|--help] <oc-server> <oc-user> <oc-passwd> <tiller-namespace> <namespace> <git-url> <git-name> <webhook-ref> <env>
        <oc-server>: mandatory server e.g. 192.168.99.100:8443
        <oc-user>: mandatory username e.g. admin
        <oc-passwd>: mandatory password e.g. admin
        <tiller-namespace>: mandatory namespace where tiller is running
        <namespace>: mandatory namespace to install into
        <git-url>: mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git
        <git-name>: mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build
        <webhook-ref>: mandatory the git ref that fires the webhook e.g. refs/heads/master
        <env>: mandatory the env prefix to make the installed chart unique e.g. live
        --insecure-no-tls-verify: skip TLS verify needed for minishift (default: 'false')
        -h, --help: Prints help
```

An example of installing it into the current project on Minishift deploying an environment from `simbo1905/env-build` running on Gitea is:

```
./installer.bash \
  --insecure-no-tls-verify true \
  192.168.99.100:8443 \
  admin \
  admin \
  ocd \
  $(oc project --short) \
  http://ffdbaa5f8689920e9389ad321760a65f0ead6d91@gitea-gitea.192.168.99.100.nip.io/simbo1905/env-build.git \
  simbo1905/env-build \
  refs/heads/master \
  build
```

See the [wiki](https://github.com/ocd-scm/ocd-meta/wiki/Minishift) for setting up minishift with helm tiller. 

