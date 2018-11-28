#!/bin/bash
IP=$(oc project | sed 's/.*https:\/\/\([0-9][0-9]*\)\.\([0-9][0-9]*\)\.\([0-9][0-9]*\)\.\([0-9][0-9]*\).*/\1.\2.\3.\4/g')
PORT=$(oc get svc/tiller -o jsonpath='{.spec.ports[0].nodePort}' -n kube-system --as=system:admin)
export HELM_HOST="$IP:$PORT" 
