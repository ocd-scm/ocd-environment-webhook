# ocd-environment-webhook

## Status

This repo close to a milestone release. You can watch the repo to get notified when it has something to show.

## Installation

See the installer: 

```
$ ./installer.bash -h
Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.
Usage: ./installer.bash [-s|--oc-server <arg>] [-u|--oc-user <arg>] [-p|--oc-passwd <arg>] [-t|--tiller-namespace <arg>] [-n|--namespace <arg>] [--insecure-no-tls-verify <arg>] [-h|--help] <git-url> <git-name> <webhook-ref>
	<git-url>: mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git 
	<git-name>: mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build
	<webhook-ref>: mandatory the git ref that fires the webhook e.g. refs/heads/master
	-s, --oc-server: mandatory e.g. 192.168.99.100:8443 (no default)
	-u, --oc-user: mandatory username e.g. admin (no default)
	-p, --oc-passwd: mandatory password e.g. admin (no default)
	-t, --tiller-namespace: mandatory namespace where tiller is running (no default)
	-n, --namespace: mandatory namespace to instal into (no default)
	--insecure-no-tls-verify: optional skip TLS verify needed for minishift (no default)
	-h, --help: Prints help
```

An example of installing it into Minishift running the Gitea is:

```
./installer.bash \
        --insecure-no-tls-verify true \
        -s 192.168.99.100:8443 \
        -u admin \
        -p admin \
        -t ocd 
        -n ocd-builder \
        http://7784f8c5766f9fc074a3d77fb426bc3058abd4a5@gitea.ocd-builder.svc:3000/simbo1905/env-build.git \
        simbo1905/env-build \
        refs/heads/master
```

See the [wiki](https://github.com/ocd-scm/ocd-meta/wiki/Minishift) for setting up minishift with helm tiller. 

## Helpful Commands

Hard delete all the other charts in a test project when testing: 

`helm list --namespace $TEST_PROJECT | awk 'NR>1{print $1}' | grep -v ocd-environment-webhook |
 xargs helm delete --purge`
