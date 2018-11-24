#!/bin/bash
docker build . -t simonmassey/ocd-environment-webhook
docker push simonmassey/ocd-environment-webhook:latest
