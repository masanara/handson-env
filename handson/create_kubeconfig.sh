unset KUBECONFIG
unset AWS_REGION
cp /dev/null kubeconfig.txt
export AWS_REGION=$(terraform output -json | jq .aws_region.value | sed 's/\"//g')
aws eks --region $AWS_REGION update-kubeconfig --name prod
export CLUSTER=$(terraform output -json | jq .cluster_endpoint.value | sed 's/\"//g')
export CERTIFICATE=$(terraform output -json | jq .cluster_certificate.value)
export TOKEN=$(kubectl get secret -n kube-system nos-handson-secret -o=jsonpath='{.data.token}' | base64 -d)
export KUBECONFIG=./kubeconfig.txt 
kubectl config set-credentials nos-handson --token=$TOKEN
kubectl config set-cluster ekscl --server=$CLUSTER --insecure-skip-tls-verify=true
kubectl config set-context --cluster=ekscl --user=nos-handson eks
kubectl config use-context eks
