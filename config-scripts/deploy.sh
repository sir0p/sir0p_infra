#!/bin/bash
username=reddit
home_dir=/home/$username

adduser --system --disabled-password $username

cd $home_dir
git clone -b monolith https://github.com/express42/reddit.git
cd $home_dir/reddit && bundle install
puma -d
