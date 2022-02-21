#!/bin/bash
#Install PHP with extensions
sudo yum install amazon-linux-extras -y (In case extra is not installed)
sudo yum clean metadata 
sudo amazon-linux-extras enable php7.4 
sudo yum install php php-common php-pear 
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip,pdo,soap,sodium,bcmath}

#NGINX
sudo amazon-linux-extras enable nginx1
sudo yum clean metadata 
sudo yum install nginx
sudo systemctl start nginx
cd /etc/nginx
mkdir sites-available/ sites-enabled/
ln -s /etc/nginx/sites-available/*  /etc/nginx/sites-enabled

#Start PHP-FPM
sudo systemctl start php-fpm

#Install GIT
sudo yum install git -y

#Install Composer
# Download install script
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

#  Verify integrity.
# Download hash key
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"

# Verify downloaded hash against authorized composer keys
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

# Install composer in usr/local/bin
php composer-setup.php --install-dir=/usr/local/bin --filename=composer


#Clone the project
cd var/www/html/
git clone https://$PAT_PASSWORD@github.com/<orgname>/$PROJECT_NAME/_git/$REPO_NAME

#Setup Magento AUTH
cat <EOT>> home/ec2-user/.config/composer/auth.json
{
    "http-basic": {
        "repo.magento.com": {
            "username": "${MAGENTO_PUB_KEY}",
            "password": "${MAGENTO_PRIV_KEY}"
        }
    }
}

EOT

#Install composer packages
cd $REPO_NAME
composer install --quiet

echo Hello, what\'s the project name?
read PROJECT_NAME


#Run Magento installation
bin/magento setup:install \
--db-host="YOUR DOMAIN NAME" \
--db-name="YOUR_DB_NAME" \
--db-user="YOUR_DB_USER_NAME" \
--db-password="YOUR_DB_USER_PWD" \
--base-url="http://YOUR-SITE-NAME.local/" \
--admin-user="admin" \
--admin-password="admin" \
--admin-email="YOUR-EMAIL" \
--admin-firstname="FIRST-NAME" \
--admin-lastname="LAST-NAME" \
--language=en_US \
--currency=AUD \
--timezone=Australia/Melbourne \
--use-rewrites=1

#SETUP NGINX Config
cat <<EOT > /etc/nginx/sites-available/$PROJECT_NAME.conf
upstream fastcgi_backend {
  server  unix:/run/php-fpm/www.sock;
}

server {
  server_name $DOMAIN_NAME;
  set $MAGE_ROOT /var/www/html/$PROJECT_NAME;
  include /var/www/html/$PROJECT_NAME/nginx.conf;

}
EOT
sudo nginx -t
sudo systemctl nginx restart
