#!/bin/bash
cd front-end
touch .env
cat <<EOT > .env    
EXAMPLE_VAR="$1"
EOT
cat .env
firebase use $(project) --token "$(firebase_token)"
yarn install
yarn build
firebase deploy --only hosting --token "$(firebase_token)"