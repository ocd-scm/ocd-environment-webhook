#!/bin/bash
if [ ! -d checkout ]; then
  git clone --depth 1 --single-branch $ENV_GIT_URL checkout
else
  cd checkout; git pull origin master
fi