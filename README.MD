# REBRAIN DevOps Task - ANSIBLE 08. Role Dependencies

## About The Project 
Hi, this is a custom **Ansible** role for nginx webserver with some virtual hosts in.
All infrastructure you want to use for that can be created by **Terraform** on [DigitalOcean](https://www.digitalocean.com/) provider. You have a few **jinja2** template here ready for use also.

In this task a new role **vhost** was created. This role has a **nginx** role as a dependency:
`roles\vhost\meta\main.yml`
```yml
dependencies:
  - role: nginx
```
Also, **virtualhost** var was added for this role:
`roles\vhost\vars\main.yml`
```yml
# List of virtualhosts
virtualhosts:
  1:
    name: "{{ tf_hostname }}-virtual1"
  2:
    name: "{{ tf_hostname }}-virtual2"
```

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/145)_


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
   git checkout ansible08
   ```
2. Create a `terraform.tfvars` file with your values from `terraform.tfvars.sample` in the same project folder.
3. Create all infrastructure in Terraform:
   ```sh
   terraform init
   terraform plan
   terraform apply
   ```
As a result Terraform create an `inventory.yml` that will need for Ansible later.

3. Edit `playbook.yml` with your sites for virtual hosts:
   ```yml
    virtualhosts:
      1:
        name: "site1.com"
      2:
        name: "site2.com"
   ```
4. Edit `main.yml` in `roles/nginx/vars` folder with your options:
    ```yml
    server_name: "{{ inventory_hostname }}"
    document_root: /var/www
    port_num: 80
    ```
5. Edit `vhost.conf`, `nginx.conf`, `index.html` in `roles/nginx/template` folder using Jinja2 templates.
## Usage
```sh
  ansible-playbook --tags vhost -i inventory.yml playbook.yml
```
## License

Distributed under the MIT License.

## Contact

Oleg Satalkin - [@olegen](https://t.me/olegen) - Oleg.Satalkin@gmail.com

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible08](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible08)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)