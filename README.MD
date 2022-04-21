# REBRAIN DevOps Task - ANSIBLE 13. Production ready.

## About The Project 
Hi, this is a Terraform `main.tf` file with __local-exec__ provisioner calling ansible `playbook.yml`. 

Terraform `main.tf` file creates and setup GCP Load Balancer and export `playbook.yml` ansible inventory file and then **Ansible** playbook with 2 __nginx__ static webserver roles comes into play.

All infrastructure you want to use for that can be created by **Terraform** on [Google Cloud](https://www.cloud.google.com/) provider. You have a few **jinja2** template here ready for use also.

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/150)_


### Built With
* [Terraform](https://www.terraform.io/)
* [Ansible](https://www.ansible.com/)
* [Jinja2 templates](https://jinja.palletsprojects.com/en/3.1.x/)

## Getting started

### Prerequisites
Install all software you need:
  ```sh
  sudo apt install terraform
  sudo apt install ansible
  ```
## Instalation
1. Clone the repo
   ```sh
   git clone https://gitlab.rebrainme.com/devops_users_repos/3732/ansible.git
   git checkout ansible13
   ```
## Usage
```sh
terraform init
terraform plan
terraform apply
```
## License

Distributed under the MIT License.

## Contact

Oleg Satalkin - [@olegen](https://t.me/olegen) - Oleg.Satalkin@gmail.com

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible13](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible13)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)