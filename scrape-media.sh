#!/usr/bin/env bash
# scrape-media.sh : Bash shell script to srape info from media files
# currently local support only using mediainfo and ffmpeg. Max M.

#usage: bash script.sh -i input-dir -o output-dir -d database-dir
##dives through input-dir for all video files, calls info-func to
##generate report in output-dir, mirroring filename+structure
## database-dir is ? supposed to be write heavy. 

#TODO
# 1. Enable subs + nfo + etraneous file transfers. (may need title)
# 2. Enable title list etc
# 3. 


# ? copy extraneous files?
_V=2
#should use find to make a textfile with all movies listed as full pathsi
FILETYPES=("mp4|""mkv|""avi|""srt|""txt|""nfo|""jpeg|""jpg|""png|""gif|""mpeg|""xvid|""divx|""rar|""sfv|""zip|""mpg|""svg")
declare -a EXCLUSION_LIST=("md5sum" "*.nfo" "*.srt" "*.idx" "*.txt")
INPUT_DIR="./"
DATABASE="$OUTPUT_DIR/db.maxfile"
OUTPUT_DIR="./"
TITLE_DB="$OUTPUT_DIR/title-db.maxfile"

MEDIAINFO_CMD="mediainfo -f "
MEDIAINFO_CMD_HTML="mediainfo -f --Output=HTML "
MEDIAINFO_CMD_XML="mediainfo -f --Output=XML "
FFMPEG_CMD="ffmpeg -i "

function main () {
    input-parse "$@"
    logvv "input dir is - $INPUT_DIR : output-dir is - $OUTPUT_DIR "
    logvv "Searching  $INPUT_DIR"
# EXCESS CALL
    COUNT=$(find "$INPUT_DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' | wc -l)
# 
    logvv "Count is set"
    logvv "Number of files $COUNT"
# end
    find "$INPUT_DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE
    logvv "Using these filetypes = $FILETYPES"
    touch $TITLE_DB
    logvv "Created $TITLE_DB"
    logvv "title-db : $TITLE_DB : should be empty : $(cat "$TITLE_DB" | wc -l) : number of titles before"
#skip title list for now, moving to info-func
OLD_IFS=$IFS
while IFS='' read -r line || [[ -n "$line" ]]; do
    logvv "Text read from $DATABASE : $line"
    vid-info "$line"
done < "$DATABASE"
IFS=$OLD_IFS

#now what about extraneous files? wehre and how. 

# need to search each 'line' for match in title_db before adding it. 
#so this command finds all 'lines' that are accepted 'files'
# cat "$DATABASE" | egrep "\.("$FILETYPES")$" >> $TITLE_DB
#we want just movies+tv+vid
    #    VID_FILETYPES=("mp4|""mkv|""avi|""xvid|""divx|""mpg|""mpeg|")
#Ho do i deal with zips and rars? NOPE
    #    echo "... remove duplicates and add..."
    #    echo "# NEW ADD $(date)" >> $TITLE_DB 
    #    echo "# NEW ADD $(date)" >> temp_db
    #    cat "$TITLE_DB" "$DATABASE" | egrep "(\.("$VID_FILETYPES"|^#)$|^#)" | awk '!x[$0]++' > temp_db  # >> $TITLE_DB
# ooo - cat in.txt | awk '!x[$0]++'  # removes all but first entry in file
    #    echo ".. cleaning time..."
#so lets move temp_db to TITLE_DB?
    #    mv temp_db "$TITLE_DB"
#cat "$TITLE_DB" | awk '!x[$0]++' > temp_db # can i in-line it? awk that is or does this no work
    #    echo "...done adding"
    #    echo "$(cat "$TITLE_DB" | wc -l) number of titles after"
    #    echo "... did it work? good now remove the echo training wheel"
    #    echo "...end wizardy?"

    #    echo ""

# do it all with dir names 
    #    echo "Looking for all directory names"
# find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE 
# regex : "(\.("$VID_FILETYPES"|^#)$|^#)"  -- filetype
#find "$DIR" -type f -regex "(\.("$VID_FILETYPES"|^#)$|^#)"
    #    find "$DIR" -type d -regextype posix-egrep -regex ".*(\w*\s)*[(][[0-9]{4}[)]" | egrep "(\w*\s)*[(][[0-9]{4}[)]" > dir-search-temp-db.maxfile
    #    echo "Searched and found $(cat ./dir-search-temp-db.maxfile | wc -l) titles"
    #    echo ""

# NEEDS
#  - dir title add search is 'cleaner' method implement first, then nest files in entries etc
#  - file heuristics can come later, atleast grepping the title from filename won't be needed
#    due to dot's pre-process. 
#  - dot's pre-process and etc



#find $DIR -type f -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]'
}

function vid-info() {
#get info
tempin="$OUTPUT_DIR${1#.}"
filename="$(basename "$1")"
    log "$filename"
    #exclusion list
    for i in "${EXCLUSION_LIST[@]}"
    do
        logvv "Checking $i"
        if [ "$filename" == "$i" ]; then
        log "Not logging is : $i"
        return
    fi
    done
    logvv " -- $tempin/$filename.mediainfo.log"
    logvv " -- $tempin/$filename.mediainfo.html"
    logvv " -- $tempin/$filename.mediainfo.xml"
    logvv " -- $tempin/$filename.ffmpeg.log"
    #argument is file... 
    mkdir -p "$tempin"
    touch "$tempin/$filename.mediainfo.log"
    touch "$tempin/$filename.mediainfo.html"
    touch "$tempin/$filename.mediainfo.xml"
    touch "$tempin/$filename.ffmpeg.log"
    logv "starting log $MEDIAINFO_CMD -- $tempin/$filename.mediainfo.log"
    $MEDIAINFO_CMD "$1" > "$tempin/$filename.mediainfo.log"
    logv "starting html $MEDIAINFO_CMD_HTML -- $tempin/$filename.mediainfo.html"
    $MEDIAINFO_CMD_HTML "$1" > "$tempin/$filename.mediainfo.html"
    logv "starting xml $MEDIAINFO_CMD_XML -- $tempin/$filename.mediainfo.xml"
    $MEDIAINFO_CMD_XML "$1" > "$tempin/$filename.mediainfo.xml"
    logvv "starting ffmpeg $FFMPEG_CMD -- $tempin/$filename.ffmpeg.log"
    #export FFREPORT="$tempin/$filename.ffmpeg.log"
    $FFMPEG_CMD "$1" 2> "$tempin/$filename.ffmpeg.log"
unset tempin
unset filename
}


function input-parse() {
while [[ $# > 1 ]]
do 
    key="$1"

    case $key in
        -i|--input-directory)
            INPUT_DIR="$2"
            shift # past argument
            ;;
        -o|--output-directory)
            OUTPUT_DIR="$2"
            shift #past argument
            ;;
        -d|--database-directory)
            DATABASE="$2/db.maxfile"
            TITLE_DB="$2/title-db.maxfile"
            shift #past argument
            ;;
#    --web-info)
#      WEB_INFO="$2"
#      if [ -a $WEB_INFO ]; then
#        WEB_INFO_EXISTS=true
#      fi
#      shift # past argument
        -v|--verbose)
            _V=1
            shift # past argument
            ;;
        -vv|--verbose=2)
            _V=2
            shift # past argument
            ;;
        -vvv|--verbose=3)
            _V=3
            shift # past argument
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
    done
unset key
}

#COLOR
__RED='\033[0;31m'
__NC='\033[0m'
__YEL='\033[1;33m'
__GRN='\033[0;32m'
__WHT='\033[1;37m'
__BACK_RED='\033[41m'
#END COLOR

#this is the error function. Indicates a problem which no logic
#has been written to handle
function log () {
if [[ $_V -ge 0 ]]; then
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
    function logv () {
    if [[ $_V -ge 1 ]]; then
      echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
    fi
  }
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
  function logvv () {
  if [[ $_V -ge 2 ]]; then
    echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
  fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: Currently Unsupported $@" >&2
}
#end

main "$@"
