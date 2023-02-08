#!/bin/bash

json=$(terraform output -json | jq .bastion_ips.value)
len=$(echo $json | jq length)
for i in $( seq 0 $(($len - 1)) ); do
  row=$(echo $json | jq .[$i] | sed 's/\"//g')
  echo 'coping kubeconfig to' $row
  scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ../key-pair/k8s-handson kubeconfig.txt ubuntu@$row:.kube/config
done
