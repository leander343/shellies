#!/usr/bin/env python3
import os
import json
import subprocess

f=open('config.json')
data = json.load(f)
for x in range(len(data)):
  os.environ['ITERATION']=str(x)
  os.environ['PROJECT_NAME']=data[x]['project-name']
  os.environ['REPO_NAME']=data[x]['repo-name']
  os.environ['PORT']=str(data[x]['port'])
  os.environ['DOMAIN_NAME']=data[x]['domain-name']
  subprocess.call(['./clone.sh'])
