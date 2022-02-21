#!/bin/bash
echo "|$ITERATION||$PROJECT_NAME||$REPO_NAME||$PORT|"

git clone https://$PAT_PASSWORD@dev.azure.com/<orgname>/$PROJECT_NAME/_git/$REPO_NAME

mv $REPO_NAME $PROJECT_NAME

cd $PROJECT_NAME

cat <<EOT >> .env
 PORT=$PORT
EOT

cd ..

if [ $ITERATION = 0 ]; then
cat <<EOT >> docker-compose.yml
version: "3"
services:
EOT
fi

cat <<EOT >> docker-compose.yml
  $PROJECT_NAME:
    image: strapi/strapi
    volumes:
      - ./$PROJECT_NAME/app:/srv/app
    ports:
      - "$PORT:1337"
EOT

cd /etc/
cat <<EOT >> hosts
127.0.0.1 $DOMAIN_NAME
EOT

cd nginx/sites-available
cat <<EOT > $DOMAIN_NAME                             
server {
  server_name $DOMAIN_NAME;
  access_log /var/log/nginx/reverse-access.log;
  error_log /var/log/nginx/reverse-error.log;
  location / {
    proxy_pass http://127.0.0.1:$PORT;
  }
}
EOT

ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

systemctl restart nginx

