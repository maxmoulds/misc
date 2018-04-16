#!/bin/bash
#usage ONLY if the file is : Movie Name (Year).ext
#will create directory with same name and move. 
#change the file extension... as needed. 

shopt -s nullglob
echo "$PWD"
for full_filename in *.avi
do
  extension="${full_filename##*.}"
  filename="${full_filename%.*}"
  name=$(echo $filename | cut -f 1 -d '.')
  #mkdir -p "$filename/picture"
  #mv "$full_filename" "$filename/picture"
#echo "filename was $name for $full_filename"
#name is right
echo "makeing $name"
mkdir "$name"
echo "moving mv $full_filename to $name/"
mv "$full_filename" "$name/"
done
shopt -u nullglob
