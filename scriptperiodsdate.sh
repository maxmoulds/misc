#!/bin/bash
#usage ONLY if the file is : Movie Name (Year).ext
#will create directory with same name and move. 
#change the file extension... as needed. 

#DIRECTORY="/path/to/dir"
#cd "$DIRECTORY" || exit 1

ext="mp4"
shopt -s nullglob
echo "$PWD"

for full_filename in *.$ext
do

  #need foldername
  #need filename
  extension="${full_filename##*.}"
  testfilename=$full_filename
  #filename minus extension
  filename="${full_filename%.*}"
  #remove extension?
  #foldername=$(echo $filename | cut -f 1 -d '.')
  foldername="${full_filename%.*}"
  #adding year to file name
  year="$(echo $testfilename | grep -o -E '[0-9]+' | head -1 | sed -e 's/^0\+//')"
  newfile="${full_filename%.$ext}"
  # replace the periods
  newfile="${newfile//./ }"
  # rename the file
  echo "moving $full_filename to ${newfile} ($year).${ext}"
  #mv --backup=numbered -- "$full_filename" "${newfile} ($year).${ext}"
  #create directory
  #first get rid of crap
  echo "foldername before is $foldername" 
  foldername=${newfile%%" $year"*} 
  echo "foldername after cleaning is $foldername"
  foldername="${foldername} ($year)"
  echo "creating directory mkdir $foldername"
  echo "moving $full_filename to $foldername/$full_filename"


  #filename="$filename ($year).$ext"
  #foldername="$foldername ($year)"
  echo "year is $year"
  echo "filename was $filename for $full_filename"
  echo "foldername was $foldername for $full_filename"
  mkdir "$foldername"
  mv $full_filename "./$foldername/$full_filename"
done
shopt -u nullglob


