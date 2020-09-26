#!/usr/bin/env bash

KIBANA_APPLICATION_NAME=$1
KIBANA_APPLICATION_LABEL=$2

ELASTIC_APPLICATION_NAME=$3
ELASTIC_APPLICATION_LABEL=$4
ELASTIC_APPLICATION_CLUSTER=$5

FLUENTD_APPLICATION_NAME=$6
FLUENTD_APPLICATION_LABEL=$7

## Kibana
sed -i "s/RESOURCE_NAME/${KIBANA_APPLICATION_NAME}/g" configuration/kubernetes/kibana/deployment.yaml
sed -i "s/LABEL/${KIBANA_APPLICATION_LABEL}/g" configuration/kubernetes/kibana/deployment.yaml

sed -i "s/RESOURCE_NAME/${KIBANA_APPLICATION_NAME}/g" configuration/kubernetes/kibana/service.yaml
sed -i "s/LABEL/${KIBANA_APPLICATION_LABEL}/g" configuration/kubernetes/kibana/service.yaml

## Elastic Search
sed -i "s/RESOURCE_NAME/${ELASTIC_APPLICATION_NAME}/g" configuration/kubernetes/elasticsearch/statefulset.yaml
sed -i "s/LABEL/${ELASTIC_APPLICATION_LABEL}/g" configuration/kubernetes/elasticsearch/statefulset.yaml
sed -i "s/CLUSTER/${ELASTIC_APPLICATION_CLUSTER}/g" configuration/kubernetes/elasticsearch/statefulset.yaml

sed -i "s/RESOURCE_NAME/${ELASTIC_APPLICATION_NAME}/g" configuration/kubernetes/elasticsearch/headless-service.yaml
sed -i "s/LABEL/${ELASTIC_APPLICATION_LABEL}/g" configuration/kubernetes/elasticsearch/headless-service.yaml

## Fluentd
sed -i "s/RESOURCE_NAME/${FLUENTD_APPLICATION_NAME}/g" configuration/kubernetes/fluentd/cluster-role.yaml
sed -i "s/LABEL/${FLUENTD_APPLICATION_LABEL}/g" configuration/kubernetes/fluentd/cluster-role.yaml

sed -i "s/RESOURCE_NAME/${FLUENTD_APPLICATION_NAME}/g" configuration/kubernetes/fluentd/daemonset.yaml
sed -i "s/LABEL/${FLUENTD_APPLICATION_LABEL}/g" configuration/kubernetes/fluentd/daemonset.yaml

sed -i "s/RESOURCE_NAME/${FLUENTD_APPLICATION_NAME}/g" configuration/kubernetes/fluentd/service-account.yaml
sed -i "s/LABEL/${FLUENTD_APPLICATION_LABEL}/g" configuration/kubernetes/fluentd/service-account.yaml