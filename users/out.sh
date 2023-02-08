terraform output -json | jq -r '.user.value[]'

echo "---"

terraform output -json | jq -r '.password.value[]'

