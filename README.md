# Wordpress Theme Dev

Setup a quick and easy wordpress theme development environment using Vagrant

## Install VirtualBox & Vagrant

Download and install VirtualBox from [virtualbox.org](https://www.virtualbox.org/).
Download and install Vagrant from [vagrantup.com](vagrantup.com).

## Installation

Download and extract [wordpress-theme-dev](https://github.com/olorton/wordpress-theme-dev/archive/master.zip) and then from within that directory execute the following from the command line.

```
vagrant up
```

This will boot up and configure an ubuntu server virtual machine on the ip ```192.168.10.33```

You will need to run the wordpress setup by navigating to that ip in your browser. Use the following details to set up to the database.

* Database: wordpress
* User Name: root
* Password: (leave blank)
* Database Host: localhost
* Table Prefix: (whatever you like, or leave default)

The wordpress themes directory is located here: wordpress/wp-content/themes