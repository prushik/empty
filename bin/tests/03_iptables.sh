#!/bin/bash

source bin/config.sh

source bin/tests/common.sh

while IFS='' read -r line || [[ -n "$line" ]]
do
	rule_type=$(cut -c2 <<< $line)
	rule_chain=$(awk -F" " '{print $2}' <<< $line)
	rule_target=$(awk -F" " '{print $NF}' <<< $line)

	if [ "$rule_type" = "P" ]
	then
		if [ "$rule_chain" = "INPUT" ]
		then
			if [ "$rule_target" = "DROP" ]
			then
				update_count "FIREWALL DEFAULT" 1 0 0
			fi
			if [ "$rule_target" = "BLOCK" ]
			then
				update_count "FIREWALL DEFAULT" 1 0 0
			fi
			if [ "$rule_target" = "ACCEPT" ]
			then
				echo "WARNING: Default firewall rule is set to accept!"
				update_count "FIREWALL DEFAULT" 0 1 0
			fi
		fi
	fi

	if [ "$rule_type" = "A" ]
	then
		if [ "$rule_target" = "ACCEPT" ]
		then
			port=$(grep -oEe '--dport [^ ]*' <<< $line | cut -d' ' -f2)
			if [[ $OPEN_PORTS =~ $port ]]
			then
				update_count "FIREWALL RULE" 1 0 0
			else
				echo "ERROR: $port is not blocked by firewall"
				update_count "FIREWALL RULE" 0 0 1
			fi
		fi
	fi
done <<< "$(iptables --list-rules)"

display_total
