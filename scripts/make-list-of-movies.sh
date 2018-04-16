#!/usr/bin/env bash


#should use find to make a textfile with all movies listed as full pathsi

function main () {
DIR="./"
DIR=$1
echo "Searching  $DIR"
COUNT=$(find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' | wc -l)
echo "Count is set"
echo "Number of files $COUNT"
echo ""

echo "Lets make a file"
DATABASE=""$DIR"db.maxfile"
#echo "$DATABASE"
#echo "...here are its contents...."
#echo "$(cat "$DATABASE")"
#echo ".... end contents"
echo ""

echo "NOW LETS GET SOME! -- files thats is."
find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE
echo "Should be done"
echo ""

echo "Lets grep the titles!"
#do not remove | from end of filetype, i am too lazy to figure out 
#how to loop during variable dereference. see # skldjs #  -- NOTE
#--- NOTE the last element must NOT have one.
FILETYPES=("mp4|""mkv|""avi|""srt|""txt|""nfo|""jpeg|""jpg|""png|""gif|""mpeg|""xvid|""divx|""rar|""sfv|""zip|""mpg|""svg")
echo "Using these filetypes = $FILETYPES"
#echo "Searching db.maxfile"
#echo "$(cat "$DATABASE" | grep ".mkv$")"
echo ""
echo "Wizardry..."
# skldjs #
#trying to do this - cat db.maxfile | egrep "\.(mkv|mp4)$"
#echo "$(cat "$DATABASE" | egrep "\.("$FILETYPES")$")"
#echo "..end wizardry."
echo "Now add to a new db"


TITLE_DB=""$DIR"title-db.maxfile"
echo "Created $TITLE_DB"
#echo "Should be empty ..."
echo "$(cat "$TITLE_DB" | wc -l) number of titles before"

# need to search each 'line' for match in title_db before adding it. 
#so this command finds all 'lines' that are accepted 'files'
# cat "$DATABASE" | egrep "\.("$FILETYPES")$" >> $TITLE_DB
#we want just movies+tv+vid
VID_FILETYPES=("mp4|""mkv|""avi|""xvid|""divx|""mpg|""mpeg|")
#Ho do i deal with zips and rars? NOPE
echo "... remove duplicates and add..."
echo "# NEW ADD $(date)" >> $TITLE_DB 
echo "# NEW ADD $(date)" >> temp_db
cat "$TITLE_DB" "$DATABASE" | egrep "(\.("$VID_FILETYPES"|^#)$|^#)" | awk '!x[$0]++' > temp_db  # >> $TITLE_DB
# ooo - cat in.txt | awk '!x[$0]++'  # removes all but first entry in file
echo ".. cleaning time..."
#so lets move temp_db to TITLE_DB?
mv temp_db "$TITLE_DB"
#cat "$TITLE_DB" | awk '!x[$0]++' > temp_db # can i in-line it? awk that is or does this no work
echo "...done adding"
echo "$(cat "$TITLE_DB" | wc -l) number of titles after"
echo "... did it work? good now remove the echo training wheel"
echo "...end wizardy?"

echo ""

# do it all with dir names 
echo "Looking for all directory names"
# find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE 
# regex : "(\.("$VID_FILETYPES"|^#)$|^#)"  -- filetype
#find "$DIR" -type f -regex "(\.("$VID_FILETYPES"|^#)$|^#)"
find "$DIR" -type d -regextype posix-egrep -regex ".*(\w*\s)*[(][[0-9]{4}[)]" | egrep "(\w*\s)*[(][[0-9]{4}[)]" > dir-search-temp-db.maxfile
echo "Searched and found $(cat ./dir-search-temp-db.maxfile | wc -l) titles"
echo ""

# NEEDS
#  - dir title add search is 'cleaner' method implement first, then nest files in entries etc
#  - file heuristics can come later, atleast grepping the title from filename won't be needed
#    due to dot's pre-process. 
#  - dot's pre-process and etc



#find $DIR -type f -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]'
}


main "$@"
