# Description:      

Installed SonarQube as a service on an AWS instance provisioned with Terraform using Ansible roles.        

------------------------------------------
# Prequisites:

- Terraform installed.
- Ansible installed.
- Connection established between your machine and AWS with the necessary permissions.

------------------------------------------
# Getting Started:

- Clone the repository
```
git clone git@github.com:eslamkhaled560/sonarqube-ansible-aws.git
cd sonarqube-ansible-aws
```

- Create an AWS EC2 with Terraform
```
terraform init
terraform apply                                # type yes when prompt or add '--auto-approve'
```
  nginx-pub-ip.txt file will be created locally with the instance IP.

- Use the allocated instance's public IP address within the Ansible inventory file to establish SSH connectivity.
```
sudo chmod u+x automate-ansible.sh
./automate-ansible.sh                          # allocate ansible_host & run playbook.yml
```

- SSH to the instance and check the SonarQube service
```
sudo systemctl status sonarqube                # it should be active and running
```

- Access SonarQube on the web
```
ec2-public-ip-address:9000
```

- Don't forget to destroy AWS services after you finish
```
terraform destroy
```
------------------------------------------
