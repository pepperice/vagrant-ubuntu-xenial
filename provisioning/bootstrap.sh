#!/bin/sh

# Edit the following to change the name of the database user that will be created:
APP_DB_USER=vagrant
APP_DB_PASSWORD=vagrant

# Edit the following to change the name of the database that is created
APP_DB_NAME=vagrant_db

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
    echo "Your MySQL database has been setup"
    echo "  Database: $APP_DB_NAME"
    echo "  Username: $APP_DB_USER"
    echo "  Password: $APP_DB_PASSWORD"
}

# Set language
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Installation
echo "mysql-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

sudo apt-get update
sudo apt-get -y install apache2 mysql-server php-mysql php php-mcrypt php-intl php-cli php-curl
sudo phpenmod mcrypt

# Install Composer (PHP)
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Setup MySQL
if [ ! -f /var/log/databasesetup ];
then
    echo "CREATE USER '$APP_DB_USER'@'localhost' IDENTIFIED BY '$APP_DB_PASSWORD'" | mysql -uroot -pvagrant
    echo "CREATE DATABASE $APP_DB_NAME DEFAULT CHARACTER SET utf8" | mysql -uroot -pvagrant
    echo "GRANT ALL ON $APP_DB_NAME.* TO '$APP_DB_USER'@'localhost'" | mysql -uroot -pvagrant
    echo "flush privileges" | mysql -uroot -pvagrant

    # Fix deprecated unique option prefix key_buffer and and myisam-recover
    sed -i 's/key_buffer/key_buffer_size/' /etc/mysql/my.cnf
    sed -i 's/myisam-recover/myisam-recover-options/' /etc/mysql/my.cnf

    # Set default charset to utf8s
    cp /vagrant/provisioning/database/my.cnf /home/vagrant/.my.cnf

    service mysql restart

    touch /var/log/databasesetup
fi

# Setup Apache
sudo cp -f /vagrant/provisioning/apache/site.conf /etc/apache2/sites-available/000-default.conf
sudo ln -s -f /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Enable rewrite module
a2enmod rewrite

# User configurations
sudo cp /vagrant/provisioning/apache/httpd.conf /etc/apache2/httpd.conf

# Restart Apache2 to apply changes
service apache2 restart

# Show configuration messages
print_db_usage