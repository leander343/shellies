#!/bin/bash
cd front-end
firebase use ${PROJECT} --token "$(firebase_token)"
firebase functions:config:set example.var="$1"  --token "$(firebase_token)"
firebase functions:config:get --token "$(firebase_token)"
firebase deploy --only functions --token "$(firebase_token)"