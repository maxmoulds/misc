#!/usr/bin/env bash

_V=2

#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
source $_SRC_DIR/src-log.sh
logvv "Test if $EUID is not 1000 then we have a problem UID : $UID : GROUPS : $GROUPS"
logvv "$(namei -l ./Models/n1.5q1.65m1M5.0j104/web.info)"
function main() {
#process map. dir -> isModel(y) -> model-info.sh calls model-hash.sh == DONE
MODEL_INFO=$(pwd)"/model.info"
MODEL_INFO_SEC=$MODEL_INFO".secured"
MODEL_INFO_EXISTS=false
input_parse "$@"

#is it a model?
source $_SRC_DIR/model-isModel.sh
if isModel "$MODEL_DIRECTORY" ; then 
  #its a model - shouldn't need model-info just yet. hash are the first two
  #entries anyway. for now use web-info.sh
  load_model_info
  #test the model_info
  #if not model_info
  #source $_SRC_DIR/web-info.sh

  #testing some things
  logvv "$STARMASS = M"

  #source $_SRC_DIR/model-hash.sh
  #model-hash should update the model-info file. 
  #bash $_SRC_DIR/model-hash.sh -d $MODEL_DIRECTORY
  source $_SRC_DIR/model-hash.sh -d $MODEL_DIRECTORY
fi


####### FILE_LIST  should be a function ###########
#now adding file list. 
#CHECK if FILE_LIST IS THERE.
logvv "Checking $MODEL_INFO for FILE_LIST"
if ! grep -q FILE_LIST $MODEL_INFO ; then
  logvv "no FILE_LIST yet"
  #format:
  # FILE_LIST={"$MODEL_HASH_STRING":{"$NUM_FILES":[{"NAME":{"SIZE"}:{"MD5SUM"}},{"NAME":{"SIZE"}:{"MD5SUM"}},...]}}
  #check MODEL_HASH_STRING was working
  logvv " MODEL_HASH_STRING = $MODEL_HASH_STRING"
  NUM_FILES=$(ls $MODEL_DIRECTORY | wc -l)
  logvv "number of files in model dir = $NUM_FILES"
  #for f in $MODEL_DIRECTORY/* ; do 
  FILE_LIST="FILE_LIST={\"${MODEL_HASH_STRING}\":{\"$NUM_FILES\":[{\""
  ATLEASTONEFILE_FLAG=0
  for i in $( ls $MODEL_DIRECTORY ); do
    if [[ -r "$MODEL_DIRECTORY/$i" ]] ; then
      logvv "file is readable : $i" #${i##*/}"
      logvv "wc -c $i"
      F_SIZE=$(wc -c $MODEL_DIRECTORY/$i | cut -f 1 -d " ")
      logvv "md5sum -c $MODEL_DIRECTORY/$i"
      F_SUM=$(md5sum $MODEL_DIRECTORY/$i | cut -f 1 -d " ")
      logvv "file_num : $F_SIZE  -  md5 : $F_SUM"
      FILE_LIST="$FILE_LIST${i##*/}\":[\"$F_SIZE\",\"$F_SUM\"]},{\""
      unset F_SIZE
      unset F_SUM
      ATLEASTONEFILE_FLAG=1
    else
      logvv "file NOT readable skipping - $i"
      logvv "Test if $EUID is not 1000 then we have a problem UID : $UID : GROUPS : $GROUPS"
      logvv "$(namei -l $i)"
    fi
  done
  #trim last 3 chars
  if [[ -r "$MODEL_DIRECTORY/$i" ]] ; then
    if [[ $ATLEASTONEFILE_FLAG == 1 ]] ; then
     logvv "atleast one file was readable" 
      #truncate -s -3 $FILE_LIST
      FILE_LIST=${FILE_LIST::-3}
    else 
      logvv "There were no readable files in the model dir"
      FILE_LIST="$FILE_LIST$ERROR\":[{\"$ERROR\"}:{\"$ERROR\"}]}"
      #truncate -s -2 $FILE_LIST
    fi
    FILE_LIST="$FILE_LIST]}}"
    logvv "Final file_list for $MODEL_INFO: $FILE_LIST"
    echo "$FILE_LIST" >> $MODEL_INFO
    unset i
    unset ATLEASTONEFILE_FLAG
  else
    logvv "end of loop, file wasnt readable.... exit please"
  fi
else
  logvv "File_list exist. run some other logic"
fi
############END FILE_LIST - make into a function ########


#log "2nd Test"
#logv "inter test"
#logvv "inter-intra test"
#alert "You suck"
#ext_log "This would be output to a log sys specified"
#trace "- someday"
}

#### END MAIN loop ###

function input_parse() {
###INPUT STUFF###
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -m|--model-info)
      MODEL_INFO="$2"
      shift # past argument
      ;;
    -i|--input-config)
      INPUT_CONFIG="$2"
      shift # past argument
      ;;
    -d|--model-directory)
      MODEL_DIRECTORY="$2"
      #logic error here, unsets stuff if called in wrong order. grrrr.
      MODEL_INFO="$2""/model.info"
      shift # past argument
      ;;
    -w|--web-directory)
      WEB_DIRECTORY="$2"
      shift # past argument
      ;;
    --default)
      DEFAULT=YES
      ;;
    #    --web-info)
      #      WEB_INFO="$2"
      #      if [ -a $WEB_INFO ]; then
      #        WEB_INFO_EXISTS=true
      #      fi
      #      shift # past argument
      #      ;;
    -v|--verbose)
      _V=1
      #shift # past argument
      ;;
    -vv|--verbose=2)
      _V=2
      #shift # past argument
      ;;
    -vvv|--verbose=3)
      _V=3
      #shift # past argument
      ;;
    -b|--background)
      _V=-1
      #shift # past argument
      ;;
    *)
      # unknown option
      ;;
  esac
  shift # past argument or value
done
unset key
}
function load_model_info () {
if [ -a $MODEL_INFO ]; then
  #we have been here before, load it up. 
  #check if the file contains something we don't want
  if egrep -q -v '^#|^[^ ]*=[^;]*' "$MODEL_INFO"; then
    logv "model.info file is unclean, cleaning it..." >&2 
    # filter the original to a new file
    ########### A WRITE ewwww can we do this onlineerrr please #@#######
    egrep '^#|^[^ ]*=[^;&]*'  "$MODEL_INFO" > "$MODEL_INFO_SEC"
    #configfile="$configfile_secured"
    source "$MODEL_INFO_SEC"
    WEB_INFO_EXISTS=true
  else
    logvv "Config file good to go..."
    source "$MODEL_INFO"
    WEB_INFO_EXISTS=true
  fi  
else
  logvv "init model.info"
  WEB_INFO_EXISTS=false
  #we havent been here 
fi
logvv "Loaded model.info"
}

#who really does any work around here anyway
main "$@"
