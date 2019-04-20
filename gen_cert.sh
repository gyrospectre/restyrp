#!/bin/bash
# https://gist.github.com/bradrydzewski/a6090115b3fecfc25280

set -e
set -x

DAYS=35 # Builds should not live for longer than 30 days!
PASS=$(openssl rand -hex 16)

# remove certificates from previous execution.
rm -f *.pem *.srl *.csr *.cnf

# generate CA private and public keys
echo 01 > ca.srl
openssl genrsa -des3 -out ca-key.pem -passout pass:$PASS 2048
openssl req -subj '/CN=*/' -new -x509 -days $DAYS -passin pass:$PASS -key ca-key.pem -out ca.pem

# create a server key and certificate signing request (CSR)
openssl genrsa -des3 -out nginx.key -passout pass:$PASS 2048
openssl req -new -key nginx.key -out server.csr -passin pass:$PASS -subj "/C=AU/ST=NSW/L=Bathurst/O=OrgName/OU=OhYou/CN=ouyou.com"

# sign the server key with our CA
openssl x509 -req -days $DAYS -passin pass:$PASS -in server.csr -CA ca.pem -CAkey ca-key.pem -out nginx.crt

# create a client key and certificate signing request (CSR)
openssl genrsa -des3 -out key.pem -passout pass:$PASS 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr -passin pass:$PASS

# create an extensions config file and sign
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -req -days $DAYS -passin pass:$PASS -in client.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf

# remove the passphrase from the client and server key
openssl rsa -in nginx.key-out nginx.key -passin pass:$PASS
openssl rsa -in key.pem -out key.pem -passin pass:$PASS

# remove generated files that are no longer required
rm -f ca-key.pem ca.srl client.csr extfile.cnf server.csr

exit 0
