#!/bin/bash
cd  /var/www/html/Dusk-Dawn-Magento
git fetch --quiet;
git reset --hard origin/$branch --quiet;
./deploy.sh $(Build.SourceBranch)
php bin/magento maintenance:enable
composer update --quiet
php -d memory_limit=-1 bin/magento setup:upgrade --quiet
php -d memory_limit=-1 bin/magento setup:di:compile --quiet
php bin/magento cache:clean
php bin/magento maintenance:disable