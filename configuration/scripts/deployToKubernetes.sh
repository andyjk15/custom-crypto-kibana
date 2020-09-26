#!/usr/bin/env bash

APPLICATION_NAME=$1
ELASTIC_CLUSTER=$2

kubectl apply -f configuration/kubernetes/elasticsearch/headless-service.yaml
kubectl apply -f configuration/kubernetes/elasticsearch/statefulset.yaml

kubectl rollout status sts/${ELASTIC_CLUSTER} --namespace=kube-logging


kubectl apply -f configuration/kubernetes/kibana/deployment.yaml
kubectl apply -f configuration/kubernetes/kibana/service.yaml

kubectl rollout status deployment/${APPLICATION_NAME} --namespace=kube-logging


kubectl apply -f configuration/kubernetes/fluentd/service-account.yaml
kubectl apply -f configuration/kubernetes/fluentd/cluster-role.yaml
kubectl apply -f configuration/kubernetes/fluentd/daemonset.yaml

kubectl get ds --namespace=kube-logging