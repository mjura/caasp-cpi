#!/bin/bash

export KUBECONFIG=/home/mjura/kubeconfig

kubectl create -f cinder-sc.yaml
kubectl create -f cinder-pvc.yaml

kubectl create -f redis-master-controller-pvc.yaml
kubectl create -f redis-master-service.yaml

kubectl create -f redis-slave-controller.yaml
kubectl create -f redis-slave-service.yaml

kubectl create -f frontend-controller.yaml
kubectl create -f frontend-service-lb.yaml
