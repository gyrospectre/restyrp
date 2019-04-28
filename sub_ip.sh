#!/bin/sh

LOCAL_IP=`ifconfig | grep 192.168.1 | awk '{print $2}'`
sed 's/{{ LOCAL_IP }}/'"$LOCAL_IP"'/g' nginx.conf > nginx/conf/nginx.conf
