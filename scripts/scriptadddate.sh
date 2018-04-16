#!/bin/bash
#usage ONLY if the file is : Movie Name (Year).ext
#will create directory with same name and move. 
#change the file extension... as needed. 


shopt -s nullglob
echo "$PWD"
for full_filename in *.mp4
do
  extension="${full_filename##*.}"
  filename="${full_filename%.*}"
  name=$(echo $filename | cut -f 1 -d '.')
  #mkdir -p "$filename/picture"
  #mv "$full_filename" "$filename/picture"
#echo "filename was $name for $full_filename"
#name is right
echo "Enter date of $name"
read year
#echo "year was $year"
new_name="$name ($year)"
echo "new name is $new_name"
echo "makeing $new_name"
mkdir "$new_name"
echo "moving mv $full_filename to $new_name/"
mv "$full_filename" "$new_name/"
done
shopt -u nullglob
