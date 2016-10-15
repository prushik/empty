#!/bin/bash

source bin/config.sh

source bin/tests/common.sh

while IFS='' read -r line || [[ -n "$line" ]]
do
	# get fourth column (listening address and port), then select the port number (after last colon)
	listening_port=$(cut -d ' ' -f 4 <<< $line | awk -F":" '{print $NF}')

	# get last column (pid/program)
	listening_server=$(cut -d ' ' -f 9 <<< $line)

	if [[ $OPEN_PORTS =~ $listening_port ]]
	then
		update_count "OPEN_PORTS" 1 0 0
	else
		update_count "OPEN_PORTS" 0 1 0
		echo -e "WARNING!!!\t$listening_port is OPEN by $listening_server and should not be!"
	fi
done <<< "$(netstat -velvetnwp | tail -n +3)"

display_total
