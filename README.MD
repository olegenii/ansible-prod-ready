# REBRAIN DevOps Task - ANSIBLE 11. Ansible-lint.

## About The Project 
Hi, this is a custom **Ansible** playbook with __nginx__ webserver and __letsencrypt__ certificate issuing roles after applying fixes from `ansible-lint` command. You can check some errors in `lint_before_output` file and no messages after got it fixed in `lint_after_output`.

All infrastructure you want to use for that can be created by **Terraform** on [DigitalOcean](https://www.digitalocean.com/) provider. You have a few **jinja2** template here ready for use also.

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/148)_


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
   git checkout ansible11
   ```
## Usage
```sh
ansible-lint playbook.yml
```
## License

Distributed under the MIT License.

## Contact

Oleg Satalkin - [@olegen](https://t.me/olegen) - Oleg.Satalkin@gmail.com

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible11](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible11)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)