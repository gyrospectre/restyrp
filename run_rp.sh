#!/bin/sh

./sub_ip.sh
sudo docker-compose build --no-cache
sudo docker-compose up -d
