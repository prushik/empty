#!/bin/bash

source bin/config.sh


#verify HTTPS_REDIRECT
headers=$(wget $SERVER_NAME -O /dev/null -Sq --max-redirect 0 --no-hsts 2>&1)
http_response=$(head -n1 <<< "$headers")
http_code=$(cut -d$' ' -f 4 <<< "$http_response")
http_redirect=$(grep -i "location" <<< "$headers" | cut -d':' -f 2-)

if [ $http_code -eq 200 ]
then
	if [ $HTTPS_REDIRECT -eq 1 ]
	then
		echo "ERROR: did not sucessfully redirect to HTTPS"
	fi
else
	if [ $http_code -gt 299 ] && [ $http_code -lt 400 ]
	then
		if [ $HTTPS_REDIRECT -eq 0 ]
		then
			echo "ERROR: incorrectly redirected to $http_redirect"
		else
			if [ $http_redirect != "https://$SERVER_NAME/" ]
			then
				echo "ERROR: incorrectly redirected to $http_redirect"
			fi
		fi
	fi
fi

#wget $SERVER_NAME -O - --save-headers --max-redirect 0 --no-hsts --content-on-error --no-check-certificate
#wget localhost -O /dev/null -Sq --max-redirect 0 --no-hsts --content-on-error --no-check-certificate 2>&1

#verify HSTS - test 1
wget $SERVER_NAME -O /dev/null -q --max-redirect 1 --no-check-certificate
wget $SERVER_NAME -O /dev/null -q --max-redirect 0 --no-check-certificate
if [ $? -ne 0 ]
then
	if [ $HSTS -eq 1 ]
	then
		echo "ERROR: HSTS does not seem to be working. Client-side redirection failed."
	fi
fi

#verify HSTS - test 2
headers=$(wget $SERVER_NAME -O /dev/null -Sq --no-check-certificate 2>&1)
if grep -i "Strict-Transport-Security" <<< "$headers" > /dev/null
then
	echo "Found HSTS headers!"
else
	echo "ouch $headers"
fi
#  Strict-Transport-Security: max-age=86400; includeSubdomains

#verify SERVER_CERT
#this will return the headers for the immediately requested page, ignoring HSTS
#wget $SERVER_NAME -O - --save-headers --max-redirect 0 --no-hsts --ca-certificate=$SERVER_CERT


#--no-check-certificate
