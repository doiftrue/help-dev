#!/bin/bash
# ver 1.0

#
# Run this file with specifying domain in first parameter:
#     ./create-cert.sh my-domain.com
# Or simply (the domain will be asked to be entered into console):
#     ./create-cert.sh

# not empty
if [ -n "$1" ];
	then
		DOM="$1"
	else
		echo "Enter domain:"
		read -r DOM
fi

# empty string
if [ -z "$DOM" ]; then
	echo "ERROR: Domain not set"
	exit 0
fi

ORGANIZATION_NAME="LocalDev"
SUBJ="/C=US/ST=USA/L=USA/O=$ORGANIZATION_NAME/OU=$ORGANIZATION_NAME"
THIS_FILE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

### Create ROOT CA (root certificate authority)

ROOT_CA_DIR="$THIS_FILE_DIR/ROOT_CA"
ROOT_CA_NAME="LocalDevRootCA"

# skip if root ca already exists
if [ ! -d "$ROOT_CA_DIR" ]; then
	mkdir "$ROOT_CA_DIR"
	# Note: skip `-des3` parameter to not add passphrase
	openssl genrsa -out "$ROOT_CA_DIR/$ROOT_CA_NAME.key" 2048
	# generate a root certificate
	openssl req -x509 -new -nodes -key "$ROOT_CA_DIR/$ROOT_CA_NAME.key" -sha256 -days 36500 -out "$ROOT_CA_DIR/$ROOT_CA_NAME.pem" -subj "$SUBJ/CN=$ROOT_CA_NAME"
	# convert pem to crt (this file may come in handy)
	openssl x509 -inform PEM -outform DER -in "$ROOT_CA_DIR/$ROOT_CA_NAME.pem" -out "$ROOT_CA_DIR/$ROOT_CA_NAME.crt"

	# set correct rights
	chmod 644 "$ROOT_CA_DIR/$ROOT_CA_NAME.crt"
	chmod 644 "$ROOT_CA_DIR/$ROOT_CA_NAME.pem"

	# create copy of .pem with .crt format (it is the way to add it to ubuntu trust store with `sudo update-ca-certificates`)
	cp "$ROOT_CA_DIR/$ROOT_CA_NAME.pem" "$ROOT_CA_DIR/$ROOT_CA_NAME.pem.crt"
fi


### Create the site certificate and sign it with CA certificate

DOM_DIR="$THIS_FILE_DIR/$DOM"

if [ -d "$DOM_DIR" ]
	then rm "$DOM_DIR"/*
	else mkdir "$DOM_DIR"
fi

# create certificate

openssl genrsa -out "$DOM_DIR/$DOM.key" 2048
openssl req -new -key "$DOM_DIR/$DOM.key" -out "$DOM_DIR/careq.csr" -subj "$SUBJ/CN=$DOM"

# sign certificate

{
	#echo 'nsComment="Kama Custom Generated Certificate"'
	echo 'authorityKeyIdentifier=keyid,issuer'
	echo 'basicConstraints=CA:FALSE'
	echo 'keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'
	echo 'subjectAltName=@alt_names'
	echo '[alt_names]'
	echo "DNS.1=$DOM"
	echo "DNS.2=*.$DOM"
} >> "$DOM_DIR/$DOM.cnf"

openssl x509 -req -in "$DOM_DIR/careq.csr" -out "$DOM_DIR/$DOM.crt" -days 36500 -sha256 -extfile "$DOM_DIR/$DOM.cnf" \
-CA "$ROOT_CA_DIR/$ROOT_CA_NAME.pem" -CAkey "$ROOT_CA_DIR/$ROOT_CA_NAME.key" -CAcreateserial

# remove artifacts

rm "$DOM_DIR/$DOM.cnf"
rm "$DOM_DIR/careq.csr"
