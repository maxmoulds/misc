#!/usr/bin/env bash

#todo - default values
#add if logic for ...
#also wrap and re-logic call to web-info.sh
#to see if web-info should be called yet, or if
#it has already been, no need to be greedy here, 
#webify will do the dirty analysis of if we need 
#to repoll data from the actual data... haha

#set minimum verbosity
_V=0
#start main loop
function main() {
input_parse "$@"
logvv "Input parse complete"
logvv "EXEC_DIR: "$EXECDIR
logvv "WEB_DIRECTORY: "$WEB_DIRECTORY
logvv "MODEL_DIRECTORY: "$MODEL_DIRECTORY
#creating variables to write
read -r -d '' config_field <<EOL
EXECDIR=$EXECDIR
INPUT_FILE=$INPUT_FILE
MODEL_DIRECTORY=$MODEL_DIRECTORY
WEB_DIRECTORY=$WEB_DIRECTORY
EXTENSION=$EXTENSION
MODEL_EXCLUSIONS=$MODEL_EXCLUSIONS
EOL
if [[ $_V -le 2 ]]; then
  cat >"${INPUT_FILE}" <<EOL
$config_field
EOL
else
    ( set -o posix ; set ) > "$INPUT_FILE"
fi
#now what. how about call web-db...
source "$WEB_DIRECTORY/web-db.sh"
exit $?
}
#end main

function write_config {
#if appending : cat >> ....
cat >"${INPUT_FILE}" <<EOL
$config_field
EOL
}
function log () {
if [[ $_V -ge 0 ]]; then
  echo " [ERROR] ${BASH_FUNCTION##*/}:${FUNCNAME[1]}: $@" >&2
fi
}

function logv () {
if [[ $_V -ge 1 ]]; then
  echo " [WARNING] ${BASH_FUNCTION##*/}:${FUNCNAME[1]}: $@" >&2
fi
}
function logvv () {
if [[ $_V -ge 2 ]]; then
  echo " [INFO] ${BASH_FUNCTION##*/}:${FUNCNAME[1]}: $@" >&2
fi
}

function input_parse() {
#default arguments
EXECDIR=$(pwd)
EXTENSION=png
INPUT_FILE=$(pwd)"/web.input"
MODEL_DIRECTORY="$(dirname "$(pwd)")/models"
WEB_DIRECTORY=$(pwd)
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -g|--extension)
      EXTENSION="$2"
      shift # past argument
      ;;
    -i|--input-file)
      INPUT_FILE="$2"
      shift # past argument
      ;;
    -m|--model-directory)
      MODEL_DIRECTORY="$2"
      shift # past argument
      ;;
    -w|--web-directory)
      WEB_DIRECTORY="$2"
      shift # past argument
      ;;
   -x|--exclude)
     MODEL_EXCLUSIONS="$2"
     shift # past argument
     ;;
    -v|--verbose)
      _V=1
      shift # past argument
      ;;  
    -vv)
      _V=2
      shift # past argument
      ;; 
    -vvv)
      _V=3
      shift # past argument
      ;; 
    --default)
      DEFAULT=YES
      ;;
    *)
      # unknown option
      ;;
  esac
  shift # past argument or value
done
unset key
}

main "$@"
