#!/bin/bash

usage()
{
	echo "Usage: $0 <file> <key> <value>"
	echo
	echo "Update configuration file <file>, and set key <key> to value <value>"
	echo "All arguments are required"
}

if [ $# -lt 3 ]
then
	usage
	exit 1
fi

sed -i "s/$2.=.*\$/$2 = $3/g" $1 || echo "$2 = $3" >> $1
