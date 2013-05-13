#!/bin/bash

if [ $# -lt 1 ]; then
	echo "usage: convert.sh TABLE_NM"
	exit 1
fi

if [ $# -gt 4 ]; then
	echo "usage: convert.sh TABLE_NM m p t"
	exit 1
fi

Base_file="./ABC.txt"
O_KW="ABC"

UpperKw=`echo $1 | tr "[:lower:]" "[:upper:]"`
LowerKw=`echo $1 | tr "[:upper:]" "[:lower:]"`

Outfm="alter_"${LowerKw}

#judge whether a string is blank
if [ "$2"x != "x" ]; then
	Outfm=${Outfm}"_"$2
fi

if [ "$3"x != "x" ]; then
	Outfm=${Outfm}"_"$3
fi

if [ "$4"x != "x" ]; then
	Outfm=${Outfm}"_"$4
fi

Outfm=${Outfm}".sql"

cat ${Base_file} | sed "s/${O_KW}/${UpperKw}/g" > ${Outfm}

echo ${Outfm}
