#!/bin/bash

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
	return 0
fi

SUBJ="/C=US/L=USA/O=Custom Certificate"
THEDIR=$( dirname "$0" )

### Create ROOT CA certificate

RCDIR="$THEDIR/ROOT_CA_CERT"

if [ ! -d "$RCDIR" ]; then
	mkdir "$RCDIR"
	openssl genrsa -out "$RCDIR/myRootCA.key" 2048
	openssl req -x509 -new -nodes -key "$RCDIR/myRootCA.key" -sha256 -days 7600 -out "$RCDIR/myRootCA.pem" -subj "$SUBJ/CN=ROOT_CA_CERT"
fi


### Create Self-Signed certificate

DOMDIR="$THEDIR/$DOM"

if [ -d "$DOMDIR" ];
	then rm -r "${DOMDIR:?}/*"
	else mkdir "$DOMDIR"
fi

# create certificate
openssl genrsa -out "$DOMDIR/$DOM.key" 2048
openssl req -new -key "$DOMDIR/$DOM.key" -out "$DOMDIR/careq.crt" -subj "$SUBJ/CN=$DOM"

# sign created certificate
{
	echo 'nsComment = "Kama Custom Generated Certificate"'
	echo 'authorityKeyIdentifier = keyid,issuer'
	echo 'basicConstraints = CA:FALSE'
	echo 'keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'
	echo 'subjectAltName = @alt_names'
	echo '[alt_names]'
	echo "DNS.1 = $DOM"
	echo "DNS.2 = *.$DOM"
} >> "$DOMDIR/$DOM.cnf"

openssl x509 -req -in "$DOMDIR/careq.crt" -out "$DOMDIR/$DOM.crt" -days 3000 -sha256 -extfile "$DOMDIR/$DOM.cnf" \
-CA "$RCDIR/myRootCA.pem" -CAkey "$RCDIR/myRootCA.key" -CAcreateserial \


rm "$DOMDIR/$DOM.cnf"
rm "$DOMDIR/careq.crt"