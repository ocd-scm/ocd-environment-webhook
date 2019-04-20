# ocd-environment-webhook

The `ocd-environment-webhook` is the cornerstone of OCD. It catches webhook events in a configuration repo then checks out the code in the repo and run any `helmfile.yaml` configuration the configured openshift project. The following diagram shows the overall picture. 

![ocd environment sequence diagram](https://ocd-scm.github.io/ocd-meta/imgs/ocd-env-webhook-sequence-gitea.png)

## Usage

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

## Details

The entrypoint to the logic is `ocd-hook.sh` which:

 1. Checks out the code in the repo using `ocd-checkout-env.sh`
 1. Runs `ocd-environment.sh` to update the environment

The `ocd-environment.sh` runs the following algoritm: 

 1. Sources an optional `envvar` file in the top folder to load environment variables
 1. Runs an optional top level `ocd-pre-apply-hook` script
 1. Locates all subfolders containing `helmfile.yaml` and within each: 
   - Creates a subshell
   - Sources an optional `envvar` file
   - Runs an optional `ocd-pre-apply-hook` script
   - Runs `helmfile --log-level debug apply `
   - Runs an optional `ocd-post-apply-hook` script
 5. Runs an optional top level `ocd-post-apply-hook` script

Helmfile itself anticipates that you might want to run many helmfiles so has the concept of adding many uniqely named hemlfiles into a helmfile.d folder. Unfortunately Helmfile doesn't have global hooks [/helmfile/issues/331](https://github.com/roboll/helmfile/issues/331) or file hooks. Also our script uses a seperate subshell per helmfile and loads an optional per folder `envvar` that is scoped to the subshell. This means that we search for folders that contain `helmfile.yaml` and handle them using the algorithm described above. 

## Examples

See the wiki entry [Example Environment Layout](https://github.com/ocd-scm/ocd-meta/wiki/Example-Environment-Layout) for an overview of a realist example. 

