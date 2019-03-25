FROM simonmassey/ocd-tools:v1.0.8

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

#RUN touch /opt/app-root/src/.gitconfig && chgrp root /opt/app-root/src/.gitconfig && chmod g+w /opt/app-root/src/.gitconfig

RUN git config --global user.email "ocd-environemt-webhook@ocd-scm.github.com" && git config --global user.name "OCD Env Webhook"

USER 1001

EXPOSE 9000

CMD  ["/usr/local/bin/ocd-webhook.sh"]
