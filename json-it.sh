#!/bin/bash

DATA_DIR='data'

cd $DATA_DIR

INPUT=`find . -iname '*.newest'`

function join_by { local IFS="$1"; shift; echo "$*"; }
for file in $INPUT; do

	while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
		IFS= read -a array <<< "$LINE"
		my1=${array[0]}
		data[${#data[@]}]+="$my1"
		echo -ne "$my1\n"

	done  < "$file" | jq --slurp --raw-input 'split("\n")[:-1] | map([ split("\t")[] ]) | map({
		AvailabilityZone: .[5],
   		InstanceType: .[3],
   		ProductDescription: .[4],
   		SpotPrice: .[1],
		Timestamp: .[2]
    	})' >> $file.json
done

