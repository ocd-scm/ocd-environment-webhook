# ocd-environment-webhook

## Status

This repo close to a milestone release. You can watch the repo to get notified when it has something to show.

## Installation

See the installer: 

```
$./installer.bash
Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.
Usage: ./installer.bash [--insecure-no-tls-verify <arg>] [--webhook-secret <arg>] [--release-hook <arg>] [-h|--help] <oc-server> <tiller-namespace> <namespace> <build-amespace> <git-url> <git-name> <webhook-ref-regex> <env>
        <oc-server>: mandatory server e.g. 192.168.99.100:8443
        <tiller-namespace>: mandatory namespace where tiller is running
        <namespace>: mandatory namespace to install into
        <build-amespace>: mandatory namespace where images are built
        <git-url>: mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git
        <git-name>: mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build
        <webhook-ref-regex>: mandatory the regex to match the git ref e.g. refs/heads/master to match a branch or .*-RELEASEto match a release tag
        <env>: mandatory the env prefix to make the installed chart unique e.g. live
        --insecure-no-tls-verify: optional skip TLS verify needed for minishift (default: 'false')
        --webhook-secret: optional webhook secret will otherwise be generated (no default)
        --release-hook: optional match a release event rather than a push event (default: 'false')
        -h, --help: Prints help
```

See the [wiki minishift](https://github.com/ocd-scm/ocd-meta/wiki/Minishift) page for setting up minishift with helm tiller. 

See the [wiki openshift](https://github.com/ocd-scm/ocd-meta/wiki/OpenShift-Online-Pro-(openshift-dot-com)) page for setting up on openshift online pro. 


