#!/usr/bin/env bash

_V=2
_SRC_DIR=./

#builds webpages in a directory. (hmm should i do this?..)

#basic template for a single model . 
#initial support is for a stardisk model only. 

source $_SRC_DIR/src-log.sh
#should i make a src-load-info.sh NOPE
#source $_SRC_DIR/src-load-info.sh

function main () {
#what should my defaults be?
CUR_DIR=./
MODEL_DIRECTORY=./
WEB_DIRECTORY=./web
input_parse "$@"
#load_model_info $MODEL_DIRECTORY
#do some stuff
if [ ! -d $WEB_DIRECTORY ] ; then
  logvv "its not a dir i can access"
  mkdir ./web
else
  logvv "exists.. continuing"
fi
#i touch some stuff... oooo blah blah blah
#make a single html page. break. 
#again, single html - input from a json or something. 

#if the arguments state to run a single page. go for it. 
template_single_model $MODEL_DIRECTORY
#here is my issue. lets say a change is made on the "client" side
# requiring a restructuring of webpages. data must be transmitted
# not just html, then the html must have both webpages. or 
# the ability to cache the data and get the web-page. 
# so if we source the data as a collection we are okay (ie send model.info)
# but if we want to do the image tables or multiple models how will the 
# backend cope. idk atm. 
# idea ONE: exhaustive FAST, HUGE SPACE, #OF_FILES
# idea TWO: send the db ENTIRELY, possibly large single file. 
# USING idea ONE for model pages. (supports both as a page and a table)
# USING idea TWO for table pages. (supports both as a page and a table)
#IDEA one is template_single_model


#IDEA two is to make the "db" to send. in this case a 
# copy of the main db with the maximum subset trimmed to 
# what we want.
#makes a db to send. hmm. we can remove version history, data links, etc.  
template_multiple_model

}

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


function template_single_model () {
#so we need to load_model_info
load_model_info
#set page names etc. 

#check if web-info exists
load_web_info
#WARNING overwrites the load_model_info... can't say we don't reuse

}

function template_multiple_model () {
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

function load_web_info () {
if [ -a $WEB_INFO ]; then
  #we have been here before, load it up. 
  #check if the file contains something we don't want
  if egrep -q -v '^#|^[^ ]*=[^;]*' "$WEB_INFO"; then
    logv "web.info file is unclean, cleaning it..." >&2 
    # filter the original to a new file
    ########### A WRITE ewwww can we do this onlineerrr please #@#######
    egrep '^#|^[^ ]*=[^;&]*'  "$WEB_INFO" > "$WEB_INFO_SEC"
    #configfile="$configfile_secured"
    source "$WEB_INFO_SEC"
    WEB_INFO_EXISTS=true
  else
    logvv "Config file good to go..."
    source "$WEB_INFO"
    WEB_INFO_EXISTS=true
  fi  
else
  logvv "init web.info"
  WEB_INFO_EXISTS=false
  #we havent been here 
fi
logvv "Loaded web.info"
}

main "$@"
#end
