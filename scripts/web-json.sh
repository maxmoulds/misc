#!/usr/bin/env bash

_V=2

#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
source $_SRC_DIR/src-log.sh
logvv "Test"

function main() {
WEB_DIRECTORY=./
MODEL_DIRECTORY=./
input_parse "$@"

to_json $MODEL_INFO/model.info $WEB_DIRECTORY/model.info.js

#log "2nd Test"
#logv "inter test"
#logvv "inter-intra test"
#input_parse "$@"
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

function to_json () {
if [ -a $2 ] ; then
  logvv "model.info.json exists :  $2"
else
  logvv "model.info.json does not exist in $(dirname $2)"
  MODEL_HASH_STRING=$(grep -oP '(?<=MODEL_HASH_STRING=)\w.*' $1)
  FILE_LIST=$(grep -oP '(?=FILE_LIST=)\w*' $1)
  logvv "hashstring - $MODEL_HASH_STRING"
  echo -n "{\"$MODEL_HASH_STRING\":[" > $2
  while read p; do
    if [[ $p == \#* ]] || [[ $p == *\{* ]] ; then
      if [[ $p == \#* ]] ; then
        logvv "comment skipping $p"
      else
        logvv "JSON-ish already, lets use it."
        tempjson=$(echo $p | tr "=" '\n')
        for x in $tempjson
        do
          if [[ $x == \{* ]] ; then
            logvv "its the 2nd pass"
            echo -n "[$x]" >> $2
          else
            # its the first
            echo -n "{\"$x\":" >> $2
          fi
        done
        tempjson=true
      fi
    else
      #the line is some variable=data line
      logvv "parsing $p"
      temp=$(echo $p | tr "=" '\n')
      #temp now has the var name <space> argu sep.
      if [[ ${temp[1]} == \{* ]] ; then 
         logvv "Skipping, JSON"
       else
         echo -n "{\"" >> $2
       fi
      #simple one two for loop ha 1st is var 2nd is val, could is ifs but.. 
      #note ifs possible error here
      for x in $temp #
      do
        echo -n "$x\":\"" >> $2
      done
      truncate -s -2 $2
      echo -n "}," >> $2
      unset temp
    fi
  done <$1
  #remove last comma
if [[ $tempjson == true ]] ; then 
  #truncate -s -2 $2
  logvv "nope to trunc, add a curly q instead"
  echo -n "}" >> $2
else
  truncate -s -1 $2
fi
  unset tempjson
#fi
  echo -n "]}" >> $2
fi
logvv "Done parsing"
}

#who really does any work around here anyway
main "$@"
