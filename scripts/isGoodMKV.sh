# requires mediainfo, grep
for f in "$@" 
do 
	if (mediainfo "$f" | grep -i -q "DURATION * :"); then
		echo "$f was good 1"
		continue
	else
		if (mediainfo "$f" | grep -q "FromStats_StreamSize"); then
			echo "$f was good 2"
			continue
		fi
	echo "$f was NOT GOOD"	
	fi
done
