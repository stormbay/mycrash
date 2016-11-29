#!/bin/bash


BLANK=" "
COMMA=","

CRASH32="crash-arm"
CRASH64="crash-arm64"

SYMBOLFILE="vmlinux"
DUMPFILE="load.cmm"

function usage {
	echo "Usage: " $(basename $0) "[vmlinux] [load.cmm] [--32bit]"
}

if [ $# -gt 3 ]; then
	usage
	exit
elif [ $# -ge 2 ]; then
	SYMBOLFILE=$1
	DUMPFILE=$2
fi

if [ $# -eq 3 ] && [ $3 = "--32bit" ]; then
	CRASH=${CRASH32}
else
	CRASH=${CRASH64}
fi

DUMPLIST=""

while read line
do
	TMP=`echo $line | grep "d.load.binary" | grep "DDRCS" | sed -e 's/\ //g;s/d.load.binary//g;s/\/noclear//g;s/BIN/BIN@/g'`
	if [ -z "${TMP}" ]; then
		continue
	fi
	DUMPLIST=${DUMPLIST}${TMP}
done < ${DUMPFILE}

DUMPLIST=`echo ${DUMPLIST} | sed 's/\(.\)DDRC/\1,DDRC/g'`

RUNCMD=${CRASH}${BLANK}${SYMBOLFILE}${BLANK}${DUMPLIST}

echo ${RUNCMD}
eval ${RUNCMD}

