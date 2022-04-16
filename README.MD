# REBRAIN DevOps Task - ANSIBLE 09. Using Galaxy roles.

## About The Project 
Hi, this is an **Ansible playbook** for [NextCloud](https://nextcloud.com/) Server distribution. I've selected [dubzland.nextcloud](https://galaxy.ansible.com/dubzland/nextcloud) role fom __Galaxy__ store for this task. 
It based on some previous created roles also:
- __nginx__ 
- __certbot__

Nginx virtual host conf file, 
created using [NextCloud Docs](https://docs.nextcloud.com/server/latest/admin_manual/installation/nginx.html), was placed into `files/vhost_nextcloud.conf`.

All infrastructure you want to use for that can be created by **Terraform** on [DigitalOcean](https://www.digitalocean.com/) provider. You have a few **jinja2** template here ready for use also.

_Full task descrption represent at [REBRAIN site](https://lk.rebrainme.com/devops/task/146)_


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
   git checkout ansible09
   ```
2. Create a `terraform.tfvars` file with your values from `terraform.tfvars.sample` in the same project folder.
3. Create all infrastructure in Terraform:
   ```sh
   terraform init
   terraform plan
   terraform apply
   ```
  As a result Terraform create an `inventory.yml` with _VPS_ and _vars_ that will need for Ansible later.

3. Edit `playbook.yml` for setting non default virtual host name:
   ```yml
    virtualhosts:
      1:
        name: "{{ tf_hostname }}"
   ```
4. Edit `main.yml` in `roles/nginx/vars` folder with your options:
    ```yml
    server_name: "{{ inventory_hostname }}"
    document_root: /var/www
    port_num: 80
    ```
## Usage
1. Pull `dubzland.nextcloud` role from Galaxy using `requirements.yml`:
  ```sh
  ansible-galaxy install -r files/requirements.yml --roles-path roles/
  ```
2. Edit `/roles/dubzland.nextcloud/defaults/main.yml` for setting main NextCloud vars.
  ```yml
  dubzland_nextcloud_root: "/var/www/cloud.oleg.devops.rebrain.srwx.net/html/"
  dubzland_nextcloud_url: https://cloud.oleg.devops.rebrain.srwx.net
  dubzland_nextcloud_trusted_domains:
    - localhost
    - cloud.oleg.devops.rebrain.srwx.net
  ```
3. Play!
  ```sh
  ansible-playbook -i inventory.yml playbook.yml
  ```
## License

Distributed under the MIT License.

## Contact

Oleg Satalkin - [@olegen](https://t.me/olegen) - Oleg.Satalkin@gmail.com

Project Link: [https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible09](https://gitlab.rebrainme.com/devops_users_repos/3732/ansible/-/tree/ansible09)

## Acknowledgments
* [REBRAIN](https://rebrainme.com/)