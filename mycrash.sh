#!/bin/bash

FILE="load.cmm"

result=""

while read line
do
	tmp=`echo $line | grep "d.load.binary" | grep "DDRCS" | sed -e 's/\ //g;s/d.load.binary//g;s/\/noclear//g;s/BIN/BIN@/g'`
	if [ -z "$tmp" ]; then
		continue
	fi
	result=$result$tmp
done < $FILE

result=`echo $result | sed 's/[0-9]DDRC/;DDRC/g'`

echo $result

