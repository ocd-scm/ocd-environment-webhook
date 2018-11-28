#!/bin/bash
VERSION=1.0.0
oc() { 
    ./oc_wrapper.sh "$@" 
}
find $(dirname $0) -name ocd-environment.yaml | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  echo $folder
  # ocdEnvVersion: version of ocd-environment-webhook this configuration is compatible with
  ocdEnvVersion=$(yq .ocdEnvVersion $YAML | sed 's/"//g')
  echo ocdEnvVersion=${ocdEnvVersion}
  ./semver_ge.bash $VERSION $ocdEnvVersion
  if [ "$?" -ne "0" ]; then
    >&2 echo "$VERSION < $ocdEnvVersion so we are too old for this configuration"
    exit $?
  fi
  # name: the name that helm should use
  name=$(yq .name $YAML | sed 's/"//g')
  echo name=${name}
  # chart: the chart to install with
  chart=$(yq .chart $YAML | sed 's/"//g')
  echo chart=${chart}
  # chartVersion: the version of the chart to use
  chartVersion=$(yq .chartVersion $YAML | sed 's/"//g')
  echo chartVersion=${chartVersion}
  # helmValuesFile: the file to load chart values from
  helmValuesFile=$(yq .helmValuesFile $YAML | sed 's/"//g')
  echo helmValuesFile=${helmValuesFile}
  # 
  set -x
  oc project realworld
  helm init --client-only
  helm repo list | grep ocd-meta > /dev/null
  if [ "$?" != "0" ]; then
    echo adding repo ocd-meta 
    helm repo add ocd-meta https://ocd-scm.github.io/ocd-meta/charts
  fi
  helm upgrade --install \
     -f ${folder}/${helmValuesFile} \
     --version ${chartVersion} \
     --namespace realworld \
     ${name} \
     ocd-meta/${chart}
done
