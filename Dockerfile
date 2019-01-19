# This image provides tools for OCD. 
# The following packages are installed as latest available on centos7:
#  - git https://jwiegley.github.io/git-from-the-bottom-up/
#  - cowsay https://en.wikipedia.org/wiki/Cowsay
#  - jq  https://stedolan.github.io/jq/
#  - yq https://github.com/kislyuk/yq
# The following packages are downloaded and installed using an explict version number:
#  - hub 2.4.0 https://hub.github.com 
#  - oc 3.9.0 https://docs.openshift.org/latest/cli_reference/index.html
#  - git-secret 0.2.4 http://git-secret.io
#  - gpg 2.2.9 https://www.gnupg.org)
#  - helm 2.9.0 
#  - webhook 2.6.9

FROM simonmassey/ocd-tools:v1.0.7

MAINTAINER Simon Massey <simbo1905@60hertz.com>

ENV OCD_SCRIPTS_PATH=/usr/local/bin
ENV OCD_CHECKOUT_PATH=/opt/app-root/work/checkout
ENV GNUPGHOME=/opt/app-root/work/.gnupg

RUN mkdir /opt/app-root/src/.kube && chmod -R a+w /opt/app-root/src/.kube
RUN mkdir -p /opt/app-root/work && chmod -R a+w /opt/app-root/work
RUN mkdir -p /opt/app-root/src/.ssh && chmod -R a+w /opt/app-root/src/.ssh

COPY hooks-push.json /opt/app-root/src
COPY hooks-release.json /opt/app-root/src
COPY ./bin/* /usr/local/bin/

USER 1001

EXPOSE 9000

CMD  ["/usr/local/bin/ocd-webhook.sh"]
