# Deploy Minikube on an AWS instance


## Deploy the AWS instance

```bash
cd aws-terraform
terraform init
terraform plan 
terraform apply
```

## SSH into the instance and deploy docker

```bash
cd /tmp/Minikube-Aws-Env/ansible-playbook
ansible-playbook minikubeinstall.yaml
```

## Exit the instance, relogin and launch minikube

```bash
minikube start
minikube kubectl -- get po -A
alias kubectl="minikube kubectl --"
```

## Notes

### Loadbalancer service types

```bash
minikube tunnel
```
