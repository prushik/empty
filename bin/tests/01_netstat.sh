#!/bin/bash

source bin/config.sh

netstat -velvetnwp | tail -n +3 | while IFS='' read -r line || [[ -n "$line" ]]
do
	# get fourth column (listening address and port), then select the port number (after last colon)
	listening_port=$(cut -d ' ' -f 4 <<< $line | awk -F":" '{print $NF}')

	# get last column (pid/program)
	listening_server=$(cut -d ' ' -f 9 <<< $line)

	if [[ $OPEN_PORTS =~ $listening_port ]]
	then
		echo $listening_port OK
	else
		echo -e "WARNING!!!\t$listening_port is OPEN by $listening_server and should not be!\tWARNING!!!" 1>&2
	fi
done


