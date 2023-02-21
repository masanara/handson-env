terraform output -json | jq -r '.bastion_ips.value[]'
echo "---"
terraform output -json | jq -r '.bastion_ids.value[]'
echo "---"
terraform output -json | jq -r '.bastion_names.value[]'
