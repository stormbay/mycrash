#!/bin/bash


BLANK=" "
COMMA=","

CRASH32="crash-arm"
CRASH32_EXTENSIONS="/home/xinsu/tools/crashtool/crash-7.1.5-arm/extensions"
CRASH64="crash-arm64"
CRASH64_EXTENSIONS="/home/xinsu/tools/crashtool/crash-7.1.5-arm64/extensions"

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
	CRASH_EXTENSIONS=${CRASH32_EXTENSIONS}
else
	CRASH=${CRASH64}
	CRASH_EXTENSIONS=${CRASH64_EXTENSIONS}
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

export CRASH_EXTENSIONS

echo ${CRASH_EXTENSIONS}
echo ${RUNCMD}
eval ${RUNCMD}

