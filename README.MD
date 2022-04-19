# REBRAIN DevOps Task - ANSIBLE 12. Terraform calling Ansible.

## About The Project 
Hi, this is a Terraform `main.tf` file with __local-exec__ provisioner calling ansible `playbook.yml`.

Terraform `main.tf` file creates 2 VPS and export `playbook.yml` ansible inventory file and then **Ansible** playbook with __nginx__ static webserver and __nginx__ load balancer roles comes into play.

All infrastructure you want to use for that can be created by **Terraform** on [DigitalOcean](https://www.digitalocean.com/) provider. You have a few **jinja2** template here ready for use also.

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/149)_


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
   git checkout ansible12
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

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible12](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible12)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)