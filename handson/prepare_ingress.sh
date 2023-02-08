#!/bin/bash
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
echo 'Waiting certmanager'
sleep 15
curl -sLJ 'Accept: application/octet-stream'  https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml | sed 's/your-cluster-name/prod/g' | kubectl apply -f -
