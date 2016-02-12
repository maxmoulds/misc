#!/usr/bin/env bas

# Max Moulds


function main () {
DIR="./"
DIR=$1
OUT_DIR="$2info"
FULL_DIR=$(readlink -f $DIR)
echo "$FULL_DIR"
echo "$(basename $FULL_DIR)"
echo "Searching  $DIR"
COUNT=$(find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' | wc -l)
echo "Count is set"
echo "Number of files $COUNT"
echo ""
dir_name="$(basename $FULL_DIR)"
lst_name="$(basename $FULL_DIR)-rough.lst"
#echo "$dir_name-title-list.lst"
#find "./" -type f -regextype posix-egrep -regex ".*.["mkv"|(avi)|(iso)|(mp4)|(divx)]" > title-list.lst
find $DIR -type f -regextype posix-egrep -regex ".*.("mkv"|"avi"|"iso"|"mp4"|"divx")" > "$lst_name"
title_name="$dir_name-title.lst"
touch "$title_name"
full_path_name="$(basename $FULL_DIR)-full.lst"
touch "$full_path_name"
rm -- "$full_path_name"
rm -- "$title_name"

while read p; do
  intheloop="$(pwd $p)"
  echo "${p##*/}" >> "$title_name"
  for_mediainfo="$intheloop${p:1}"
  write_mediainfo="$OUT_DIR/${p##*/}-mediainfo.info"
  touch "$write_mediainfo"
  rm "$write_mediainfo"
  echo "$intheloop${p:1}" >> "$full_path_name"
  echo "$for_mediainfo and $write_mediainfo"
  echo "$(date)" >> "$write_mediainfo"
  echo "$(ls --full-time "$p")" >> "$write_mediainfo"
  mediainfo --fullscan "$for_mediainfo" >> "$write_mediainfo"
done <"$lst_name"

#so lets try doing a media info call 
#make full path list
#full_path_name="$(basename $FULL_DIR)-full.lst"
#while read q; do
#intheloop="$(pwd $q)"
#echo "$q"  
#echo "$intheloop${q:1}" >> $full_path_name
#done <$lst_name

#while read r; do
#echo "$intheloop${q:1}" >> $
#done <$full_path_name

}

main "$@"
