#!/bin/sh

# Start Keyclock
echo "*** Starting Keycloak ***"
sudo docker-compose up -d keycloak

echo -n "Waiting for server to become available "
until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 5
done
echo " \e[32mdone\e[39m"

# Create initial user
echo -n "Creating initial app user ..."
sudo docker exec -it restyrp_keycloak_1 /opt/jboss/keycloak/bin/kcadm.sh create users -r rp -s username=testuser -s enabled=true --server http://192.168.1.4:8080/auth --realm master --user admin --password admin > /dev/null
sudo docker exec -it restyrp_keycloak_1 /opt/jboss/keycloak/bin/kcadm.sh set-password -r rp --username testuser --new-password NEWPASSWORD --temporary --server http://192.168.1.4:8080/auth --realm master --user admin --password admin > /dev/null
echo " \e[32mdone\e[39m"

# Generate a new secret and update Keycloak client
echo -n "Generating new client secret ..."
SECRET=$(uuid)
sudo docker exec -it restyrp_keycloak_1 /opt/jboss/keycloak/bin/kcadm.sh update clients/ff88533c-bb46-4f0d-a3ef-de47e1c4ad4d -r rp -s secret=$SECRET --server http://192.168.1.4:8080/auth --realm master --user admin --password admin > /dev/null
echo " \e[32mdone\e[39m"

# Update NGINX config and build
echo "*** Starting NGINX Reverse Proxy ***"
echo -n "Compiling NGINX config ..."
sed 's/{{ SECRET }}/'"$SECRET"'/g' nginx.conf > nginx/conf/nginx.conf
LOCAL_IP=`ifconfig | grep 192.168.1 | awk '{print $2}'`
sed -i 's/{{ LOCAL_IP }}/'"$LOCAL_IP"'/g' nginx/conf/nginx.conf
echo " \e[32mdone\e[39m"

echo -n "Build and start container"
sudo docker-compose build --no-cache
sudo docker-compose up -d proxy

echo
echo "*** Finished ***"
