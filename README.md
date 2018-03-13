# Ubuntu 16.04 (Xenial Xerus) Vagrant Setup

This is a template for creating web projects that will use Vagrant (Virtual Box) powered by Ubuntu 16.04.

## Installs:

- Apache 2 Web Server
- MySQL 5.7

## Prerequisites

Make sure to install the following before setting up Vagrant:

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Setting Up

After installing the prerequisites, run `vagrant up` in the terminal (CWD on project root). The `Vagrantfile` will automatically setup and provision the virtual box.

### Default URL

To open the development website, go to `localhost:8080` via a browser in the host machine.

The `public` folder in the project directory is mapped to and hosted by the Vagrant OS.

### Other Notes

Feel free to modify the `Vagrantfile` and `provisioning/*` files to suit your needs.