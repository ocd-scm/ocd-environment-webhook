#!/bin/bash

HOOKS_FILE=/opt/app-root/src/hooks-push.json

if [[ "${HOOKS_RELEASE}" == "true" ]]; then
    HOOKS_FILE=/opt/app-root/src/hooks-release.json
fi

echo "Using $HOOKS_FILE"

exec /usr/local/bin/webhook -verbose -hotreload -template -hooks $HOOKS_FILE