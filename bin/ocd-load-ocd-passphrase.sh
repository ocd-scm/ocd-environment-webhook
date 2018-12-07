#!/bin/bash
(passphrase=$(<passphrase); oc create -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: openshift-passphrase
stringData:
  passphrase: ${passphrase}
EOF
)