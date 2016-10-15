#!/bin/bash

source bin/config.sh

source bin/tests/common.sh

check_config()
{
	line=$(grep -F "$2 =" $1 || return 1)
	key=$(cut -d'=' -f1 <<< $line)
	value=$(cut -d'=' -f2 <<< $line)

	if [ "$key" != "$2 " ]
	then
		# If this happens, something is seriously not right
		echo "ERROR: $key is not in a good state"
		update_count "CONFIG" 0 0 1
		return 2
	fi

	if [ "$value" != " $3" ]
	then
		echo -e "ERROR: $key set to $value, \tshould be $3"
		update_count "CONFIG" 0 0 1
		return 3
	fi

	update_count "CONFIG" 1 0 0
	return 0
}

check_config /etc/cherokee/cherokee.conf 'server!bind!1!port' $HTTP_PORT
check_config /etc/cherokee/cherokee.conf 'server!bind!2!port' $HTTPS_PORT
check_config /etc/cherokee/cherokee.conf 'server!bind!2!tls' 1
check_config /etc/cherokee/cherokee.conf 'vserver!10!document_root' $WEBROOT
check_config /etc/cherokee/cherokee.conf 'vserver!10!hsts' $HSTS
check_config /etc/cherokee/cherokee.conf 'vserver!10!hsts!subdomains' $HSTS
check_config /etc/cherokee/cherokee.conf 'vserver!20!document_root' $WEBROOT
check_config /etc/cherokee/cherokee.conf 'vserver!20!hsts' $HSTS
check_config /etc/cherokee/cherokee.conf 'vserver!20!hsts!subdomains' $HSTS
check_config /etc/cherokee/cherokee.conf 'vserver!20!ssl_certificate_file' $SERVER_CERT
check_config /etc/cherokee/cherokee.conf 'vserver!20!ssl_certificate_key_file' $SERVER_KEY

display_total
