# Deploy an AWS instance


## Deploy the AWS instance

```bash
cd aws-terraform
terraform init
terraform plan 
terraform apply
```

## SSH into the instance and deploy docker

```bash
cd /tmp/Deploy-AWS/ansible-playbook
ansible-playbook dockerinstall.yaml
```

## Exit the instance, relogin and launch minikube

```bash

```

## Notes

### Loadbalancer service types


