#!/bin/bash

set -e
set -x

(
set -a
OPENSHIFT_SERVER=192.168.99.100:8443
OPENSHIFT_USER=admin
OPENSHIFT_PASSWORD=admin
TILLER_NAMESPACE=ocd
helmfile --log-level debug apply
set +a
)
