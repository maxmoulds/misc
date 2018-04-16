#!/usr/bin/env bash
# recursive-encode.sh : Bash shell file for batch conversion of 
# media files in directory. Max M.

#usage: bash script.sh -i input-dir -o output-dir -d database-dir



_V=2
#should use find to make a textfile with all movies listed as full pathsi
CODEC_TARGET="x265"
Codec_profile="x265"

declare -a FILETYPES=("mp4|""mkv|""avi|""srt|""txt|""nfo|""jpeg|""jpg|""png|""gif|""mpeg|""xvid|""divx|""rar|""sfv|""zip|""mpg|""svg")
declare -a EXCLUSION_LIST=("md5sum" "*.nfo" "*.srt" "*.idx" "*.txt")
INPUT_DIR="./" # -i 
DATABASE="$OUTPUT_DIR/db.maxfile" # -d
OUTPUT_DIR="./" # -o
TITLE_DB="$OUTPUT_DIR/title-db.maxfile" # -d
GRP_NAME="-x265-RECODE" # -g
MEDIAINFO_CMD="mediainfo -f "
MEDIAINFO_CMD_HTML="mediainfo -f --Output=HTML "
MEDIAINFO_CMD_XML="mediainfo -f --Output=XML "
FFMPEG_CMD="ffmpeg -i "
OUTPUT_DIR_EXT=mkv # -f
DURATION=""  #"" # -t in seconds, 0 for whole length
DEFAULT_REPORT_TYPE=0

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
#    find "$INPUT_DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE
#    logvv "Using these filetypes = $FILETYPES"
#    touch $TITLE_DB
#    logvv "Created $TITLE_DB"
#    logvv "title-db : $TITLE_DB : should be empty : $(cat "$TITLE_DB" | wc -l) : number of titles before"
#skip title list for now, moving to info-func
#OLD_IFS=$IFS
#while IFS='' read -r line || [[ -n "$line" ]]; do
#    logvv "Text read from $DATABASE : $line"
#    vid-info "$line"
#done < "$DATABASE"
#IFS=$OLD_IFS
for FILE in $(ls $INPUT_DIR)
do
    filename=$(basename $FILE)
    extension=${filename##*.}
    filename=${filename%.*}
    #make directories
    VIDRUN_DIR="$OUTPUT_DIR/$filename$GRP_NAME"
    mkdir -p "$VIDRUN_DIR/images/orig"
    mkdir -p "$VIDRUN_DIR/images/recode"
    mkdir -p "$VIDRUN_DIR/log"
    #set stuff in, out, names, locations
#set log location ?? someday ? also wow. you suck max.
    FFMPEG_LOG_LOC="$VIDRUN_DIR/log/$filename$GRP_NAME.log"
    SCRIPT_LOG_LOC="$VIDRUN_DIR/log/$filename$GRP_NAME.log_err"
    TIME_LOG_LOC="$VIDRUN_DIR/log/$filename$GRP_NAME.log_time"
    DEST_OUTPUT="$VIDRUN_DIR/$filename$GRP_NAME.$OUTPUT_DIR_EXT"
    ORIG_IMG_LOG="$VIDRUN_DIR/log/$filename-images.log"
    RECODE_IMG_LOG="$VIDRUN_DIR/log/$filename$GRP_NAME-images.log"
    logvv "ORIG_IMG_LOG : $ORIG_IMG_LOG : RECODE_IMG_LOG : $RECODE_IMG_LOG :  "
    logvv "filename : $filename : extension : $extension : grp-name : $GRP_NAME :"
    logvv "VIDRUN_DIR : $VIDRUN_DIR : FFMPEG_LOG : $FFMPEG_LOG_LOC : SCRIPT_LOG : $SCRIPT_LOG_LOC : DEST_OUTPUT : $DEST_OUTPUT :"
    logvv "FILE : $FILE : DEST_EXT : $OUTPUT_DIR_EXT :"
    #GET TITLE change + add RG-GOUPNAME
    #blah blah blah code
    #make images
    #from original
    logvv "$(date) Making images and mediainfo from original"
    vid-info "$DEST_OUTPUT" "$VIDRUN_DIR/log" 0
    ffmpeg -i "$INPUT_DIR/$FILE" -vf fps=1/30 $DURATION "$VIDRUN_DIR/images/orig/$filename-orig"-img%02d.jpg &> "$ORIG_IMG_LOG" &
    #regular - testing film grain - minus rd specs 
    logvv "$(date) Recoding...."
#start command
    ( time ( export FFREPORT=file="$FFMPEG_LOG_LOC" && ffmpeg -report -i "$INPUT_DIR/$FILE" $DURATION -map_metadata 0 -map_chapters 0 \
-c:v libx265 -preset medium -x265-params crf=22.8:limit-refs=3:rd=5:psy-rd=0:psy-rdoq=50:qg-size=32:psy-rd=0:no-rd-define=1:no-intra-refres=1 \
-pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska "$DEST_OUTPUT" ) &> "$SCRIPT_LOG_LOC" ) &> "$TIME_LOG_LOC"
#end command
    logvv "$(date) Making images from result"
    #make images
    ffmpeg -i "$DEST_OUTPUT" -vf fps=1/30 $DURATION "$VIDRUN_DIR/images/recode/$filename$GRP_NAME"-img%02d.jpg &> "$RECODE_IMG_LOG" &
    #from recode
    
    #call : vid-info(INPUT-VID, OUTPUT-LOG-LOC, [0-3])
    #where 0 is all , 1 is txt, 2 is xml, 3 is html
    vid-info "$DEST_OUTPUT" "$VIDRUN_DIR/log" 0
    #vid-info "$INPUT_DIR/$FILE $VIDRUN_DIR/log 0"
    #get info
    # $1 - vid_loc #includes name
    # $2 - log_loc #includes name
    # $3 - rep_type [0-3] 

    
    #adding -map 0 -c copy : to copy all channels subtitles and streams, we will select one video channel laters(?)
        #my try?
    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map 0 -c copy -map_metadata 0 -map_chapters 0 -c:v libx265 -preset medium -x265-params crf=22.8:limit-refs=3:rd=5:psy-rd=2:psy-rdoq=50:qg-size=32:psy-rd=2.00:no-rd-define=1:no-intra-refres=1 -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska "$OUTPUT_DIR/$filename-RECODE.$OUTPUT_DIR_EXT")) > $OUTPUT_DIR/$filename-RECODE.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE.log_time


    #little somethings try
    #--preset slower --ctu 32 --max-tu-size 16 --crf 19 --tu-intra-depth 2 --tu-inter-depth 2 --rdpenalty 2 --me 3 --subme 5 --merange 44 --no-rect --b-intra --no-amp --ref 5 --weightb --keyint 360 --min-keyint 1 --bframes 8 --aq-mode 1 --aq-strength 1.0 --rd 5 --psy-rd 1.5 --psy-rdoq 5.0 --rdoq-level 1 --no-sao --no-open-gop --rc-lookahead 80 --max-merge 4 --qcomp 0.8 --no-strong-intra-smoothing --deblock -2:-2 --qg-size 16 --pbratio 1.2

    #LITTLEPOX - regular
    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE-littlepox.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map_metadata 0 -map_chapters 0 -c:v libx265 -preset slower -x265-params ctu=32:max-tu-size=16:crf=19:tu-intra-depth=2:tu-inter-depth=2:rdpenalty=2:me=3:subme=5:merange=44:no-rect=1:b-intra=1:no-amp=1:ref=5:weightb=1:keyint=360:min-keyint=1:bframes=8:aq-mode=1:aq-strength=1:rd=5:psy-rd=1.5:psy-rdoq=5.0:rdoq-level=1:no-sao=1:no-open-gop=1:rc-lookahead=80:max-merge=4:qcomp=0.8:no-strong-intra-smoothing=1:deblock="-2:-2":qg-size=16:pbratio=1.2 -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska -t 240 "$OUTPUT_DIR/$filename-RECODE-littlepox.$OUTPUT_DIR_EXT" )) > $OUTPUT_DIR/$filename-RECODE-littlepox.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE-littlepox.log_time

    #regular - testing film grain.
    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE-grain.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map_metadata 0 -map_chapters 0 -c:v libx265 -preset medium -x265-params crf=22.8:limit-refs=3:rd=5:psy-rd=2:psy-rdoq=50:qg-size=32:psy-rd=2.00:no-rd-define=1:no-intra-refres=1:tune=grain -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska -t 240 "$OUTPUT_DIR/$filename-RECODE-grain.$OUTPUT_DIR_EXT")) > $OUTPUT_DIR/$filename-RECODE-grain.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE-grain.log_time

    #testing film grain + littlpox
    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE-littlepox-grain.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map_metadata 0 -map_chapters 0 -c:v libx265 -preset slower -x265-params ctu=32:max-tu-size=16:crf=19:tu-intra-depth=2:tu-inter-depth=2:rdpenalty=2:me=3:subme=5:merange=44:no-rect=1:b-intra=1:no-amp=1:ref=5:weightb=1:keyint=360:min-keyint=1:bframes=8:aq-mode=1:aq-strength=1:rd=5:psy-rd=1.5:psy-rdoq=5.0:rdoq-level=1:no-sao=1:no-open-gop=1:rc-lookahead=80:max-merge=4:qcomp=0.8:no-strong-intra-smoothing=1:deblock="-2:-2":qg-size=16:pbratio=1.2 -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska -t 240 "$OUTPUT_DIR/$filename-RECODE-littlepox-grain.$OUTPUT_DIR_EXT" )) > $OUTPUT_DIR/$filename-RECODE-littlepox-grain.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE-littlepox-grain.log_time

    #someone elses
    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE-exp.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map_metadata 0 -map_chapters 0 -c:v libx265 -preset slower -x265-params wpp=1:ctu=64:min-cu-size=8:max-tu-size=32:tu-intra-depth=1:tu-inter-depth=1:me=1:subme=2:merange=57:no-rect=1:no-amp=1:max-merge=2:temporal-mvp=1:no-early-skip=1:rdpenalty=0:no-tskip=1:no-tskip-fast=1:strong-intra-smoothing=1:no-lossless=1:no-cu-lossless=1:no-constrained-intra=1:no-fast-intra=1:open-gop=1:no-temporal-layers=1:interlace=0:keyint=250:min-keyint=23:scenecut=40:rc-lookahead=20:lookahead-slices=0:bframes=4:bframe-bias=0:b-adapt=2:ref=3:limit-refs=0:weightp=1:no-weightb=1:aq-mode=1:qg-size=32:aq-strength=0.30:cbqpoffs=0:crqpoffs=0:rd=3:psy-rd=0.50:rdoq-level=2:psy-rdoq=10.00:signhide=1:deblock="-2:-2":sao=1:no-sao-non-deblock=1:b-pyramid=1:cutree=1:qpmax=51:qpmin=0:qcomp=0.80:cplxblur=20.0:qpstep=4:qblur=0.5:ipratio=1.10:pbratio=1.10 -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska -t 240 "$OUTPUT_DIR/$filename-RECODE-exp.$OUTPUT_DIR_EXT" )) > $OUTPUT_DIR/$filename-RECODE-exp.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE-exp.log_time

    #(time (export FFREPORT=file="$OUTPUT_DIR/$filename-RECODE-littlepox.log" && ffmpeg -report -i "$INPUT_DIR/$FILE" -map 0 -c copy -map_metadata 0 -map_chapters 0 -c:v libx265 -preset slower -x256-params ctu=32:max-tu-size=16:crf=19:tu-intra-depth=2:tu-inter-depth=2:rdpenalty=2:me=3:subme=5:merange=44:no-rect=1:b-intra=1:no-amp=1:ref=5:weightb=1:keyint=360:min-keyint=1:bframes=8:aq-mode=1:aq-strength=1:rd=5:psy-rd=1.5:psy-rdoq=5.0:rdoq-level=1:no-sao=1:no-open-gop=1:rc-lookahead=80:max-merge=4:qcomp=0.8:no-strong-intra-smoothing=1:deblock="-2:-2":qg-size=16:pbratio=1.2 -pix_fmt yuv422p10le -c:a copy -c:s copy -f matroska "$OUTPUT_DIR/$filename-RECODE-littlepox.$OUTPUT_DIR_EXT")) > $OUTPUT_DIR/$filename-RECODE-littlepox.log_ffmpeg 2> $OUTPUT_DIR/$filename-RECODE-littlepox.log_time

    ##so this command finds all 'lines' that are accepted 'files'
    ## cat "$DATABASE" | egrep "\.("$FILETYPES")$" >> $TITLE_DB
    ##we want just movies+tv+vid
    ##    VID_FILETYPES=("mp4|""mkv|""avi|""xvid|""divx|""mpg|""mpeg|")
    ##Ho do i deal with zips and rars? NOPE
    #    #    echo "... remove duplicates and add..."
    #    #    echo "# NEW ADD $(date)" >> $TITLE_DB 
    #    #    echo "# NEW ADD $(date)" >> temp_db
    #    #    cat "$TITLE_DB" "$DATABASE" | egrep "(\.("$VID_FILETYPES"|^#)$|^#)" | awk '!x[$0]++' > temp_db  # >> $TITLE_DB
    ## ooo - cat in.txt | awk '!x[$0]++'  # removes all but first entry in file
    #    #    echo ".. cleaning time..."
    ##so lets move temp_db to TITLE_DB?
    #    #    mv temp_db "$TITLE_DB"
    ##cat "$TITLE_DB" | awk '!x[$0]++' > temp_db # can i in-line it? awk that is or does this no work
    #    #    echo "...done adding"
    #    #    echo "$(cat "$TITLE_DB" | wc -l) number of titles after"
    #    #    echo "... did it work? good now remove the echo training wheel"
    #    #    echo "...end wizardy?"
    ## do it all with dir names 
    #    #    echo "Looking for all directory names"
    ## find "$DIR" -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]' > $DATABASE 
    ## regex : "(\.("$VID_FILETYPES"|^#)$|^#)"  -- filetype
    ##find "$DIR" -type f -regex "(\.("$VID_FILETYPES"|^#)$|^#)"
    #    #    find "$DIR" -type d -regextype posix-egrep -regex ".*(\w*\s)*[(][[0-9]{4}[)]" | egrep "(\w*\s)*[(][[0-9]{4}[)]" > dir-search-temp-db.maxfile
    #    #    echo "Searched and found $(cat ./dir-search-temp-db.maxfile | wc -l) titles"
    ## NEEDS
    ##  - dir title add search is 'cleaner' method implement first, then nest files in entries etc
    ##  - file heuristics can come later, atleast grepping the title from filename won't be needed
    ##    due to dot's pre-process. 
    ##  - dot's pre-process and etc
    ##find $DIR -type f -regex '.*[mp4|mkv|avi|flv|mpeg|xvid|divx]'
    unset filename
    unset extension
    unset VIDRUN_DIR
    unset FFMPEG_LOG_LOC
    unset SCRIPT_LOG_LOC
    unset TIME_LOG_LOC
    unset DEST_OUTPUT
    unset ORIG_IMG_LOG
    unset RECODE_IMG_LOG

done
}

#call : vid-info(INPUT-VID, OUTPUT-LOG-LOC, [0-3])
#where 0 is all , 1 is txt, 2 is xml, 3 is html
function vid-info() {
    #get info
    # $1 - vid_loc #includes name
    # $2 - log_loc #includes name
    # $3 - rep_type [0-3] 
    logvv "input : $1 : output : $2 : report-type : $3 :"
    vid_loc=$1
    log_loc=$2
    rep_type="${3-$DEFAULT_REPORT_TYPE}"
    logvv "input : $vid_loc : output : $log_loc : rep_type : $rep_type :"
    vidinffilename="$(basename "$1")"
    log "filename : $vidinffilename :"
    #done setup

    #some odd error checking just cuz
    for i in "${EXCLUSION_LIST[@]}"
    do
        logvv "Checking $i : ext is : "${vidinffilename##*.}" :"
        if [ "${vidinffilename##*.}" == "$i" ]; then
        logvv "Not logging file is : $i"
        return
    fi
    done    

    if [ "$rep_type" ] ; then
        if [[ "$rep_type" == 1 ]] || [[ "$rep_type" == 0 ]]; then
            logvv "starting log "MEDIAINFO_CMD" -- $log_loc/$vidinffilename-mediainfo.log"
            $MEDIAINFO_CMD "$vid_loc" &> "$log_loc/$vidinffilename-mediainfo.log"
        fi
        if [[ "$rep_type" == 2 ]] || [[ "$rep_type" == 0 ]]; then
            logvv "starting html "MEDIAINFO_CMD_HTML" -- $log_log/$vidinffilename-mediainfo.html"
            $MEDIAINFO_CMD_HTML "$vid_loc" &> "$log_loc/$vidinffilename-mediainfo.html"
        fi
        if [[ "$rep_type" == 3 ]] || [[ "$rep_type" == 0 ]]; then
            logvv "starting xml "MEDIAINFO_CMD_XML" -- $log_loc/$vidinffilename-mediainfo.xml"
            $MEDIAINFO_CMD_XML "$vid_loc" &> "$log_loc/$vidinffilename-mediainfo.xml"
        fi
        if [[ "$rep_type" == 1 ]] || [[ "$rep_type" == 0 ]]; then
            logvv "starting ffmpeg "FFMPEG_CMD" -- $log_loc/$vidinffilename-ffmpeg.log"
            $FFMPEG_CMD "$vid_loc" &> "$log_loc/$vidinffilename-ffmpeg.log"
        fi
    fi
unset i
unset log_loc
unset vid_loc
unset rep_type
unset vidinffilename
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
        -t|--duration)
            DURATION="-t $2"
            shift #past argument
            ;;
        -g|--group-name)
            GRP_NAME="$2"
            shift #past argument
            ;;
        -f|--file-type)
            OUTPUT_DIR_EXT="$2"
            shift #past argument
            ;;
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
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
    function logv () {
    if [[ $_V -ge 1 ]]; then
      echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
    fi
  }
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
  function logvv () {
  if [[ $_V -ge 2 ]]; then
    echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
  fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: Currently Unsupported $@" >&2
}
#end

main "$@"
