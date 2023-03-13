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

SUBJ="/C=US/ST=USA/L=USA/O=Local Sites-DEV/OU=Local Sites-DEV"
THEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


### Create ROOT CA certificate

RCDIR="$THEDIR/ROOT_CA_CERT"
RCNAME="myRootCA"

# skip if root ca already exists
if [ ! -d "$RCDIR" ]; then
	mkdir "$RCDIR"
	openssl genrsa -out "$RCDIR/$RCNAME.key" 2048 #skip encrypt e.g. -des3 to not add pass phrase
	# generate a root certificate
	openssl req -x509 -new -nodes -key "$RCDIR/$RCNAME.key" -sha256 -days 7600 -out "$RCDIR/$RCNAME.pem" -subj "$SUBJ/CN=LocalCustomRootCA"
	# convert pem to crt (this file may come in handy)
	openssl x509 -inform PEM -outform DER -in "$RCDIR/$RCNAME.pem" -out "$RCDIR/$RCNAME.crt"
fi


### Creating CA-Signed Certificates for Site

DOMDIR="$THEDIR/$DOM"

if [ -d "$DOMDIR" ]
	then rm "$DOMDIR"/*
	else mkdir "$DOMDIR"
fi

# create certificate
openssl genrsa -out "$DOMDIR/$DOM.key" 2048
openssl req -new -key "$DOMDIR/$DOM.key" -out "$DOMDIR/careq.csr" -subj "$SUBJ/CN=$DOM"

# sign created certificate
{
	#echo 'nsComment="Kama Custom Generated Certificate"'
	echo 'authorityKeyIdentifier=keyid,issuer'
	echo 'basicConstraints=CA:FALSE'
	echo 'keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'
	echo 'subjectAltName=@alt_names'
	echo '[alt_names]'
	echo "DNS.1=$DOM"
	echo "DNS.2=*.$DOM"
} >> "$DOMDIR/$DOM.cnf"

openssl x509 -req -in "$DOMDIR/careq.csr" -out "$DOMDIR/$DOM.crt" -days 3000 -sha256 -extfile "$DOMDIR/$DOM.cnf" \
-CA "$RCDIR/$RCNAME.pem" -CAkey "$RCDIR/$RCNAME.key" -CAcreateserial

rm "$DOMDIR/$DOM.cnf"
rm "$DOMDIR/careq.csr"