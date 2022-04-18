# REBRAIN DevOps Task - ANSIBLE 10. Ansible Vault.

## About The Project 
Hi, this is a custom **Ansible** playbook with nginx webserver role and some tasks for ssl certificate copying/private key generating. The folder `files` contains encrypted SSL-certificate for `olegen.devops.rebrain.srwx.net` website.
All vars in `playbook.yml` are also encrypted.

All infrastructure you want to use for that can be created by **Terraform** on [DigitalOcean](https://www.digitalocean.com/) provider. You have a few **jinja2** template here ready for use also.

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/147)_


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
   git checkout ansible10
   ```
2. Create a `terraform.tfvars` file with your values from `terraform.tfvars.sample` in the same project folder.
3. Create all infrastructure in Terraform:
   ```sh
   terraform init
   terraform plan
   terraform apply
   ```
4. Create a file `password` in project folder. 
## Usage
```sh
ansible-playbook -i inventory.yml --skip-tags letsencrypt playbook.yml --vault-id @password
```
## License

Distributed under the MIT License.

## Contact

Oleg Satalkin - [@olegen](https://t.me/olegen) - Oleg.Satalkin@gmail.com

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible10](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible10)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)