#!/bin/bash
GIT_URL=https://github.com/lahirushanaka/DevOps_Task.git
sudo yum install git -y
git clone $GIT_URL
cd DevOps_Task

sudo yum update && sudo yum install python3-pip
pip3 install -r requirements.txt



