#!/usr/bin/env bash

#model hash script
#contains
# hash_string(ver), hash_key(ver)
#todo: handle sourcing. this file could get large if not.
#todo: DO not use ianaly, or tstepPow as a hash input. 
#todo: 

#
_V=2

#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
source $_SRC_DIR/src-log.sh

#steps
# 1. check input
# 2. check src/[hash_ver] for addin functions.
# 3. open model-info (aka web-info)
# 4. run the two func - save var in local. 
# 5. diff the var. 
# 6. if var_key mismatch. ERR FATAL atm
# 7. if var_str mismastch. ERR FATAl atm
# 8. update if not in error. 
# 9. ? call changeset ?
# 10. .....

function main() {
#input handling. 
logvv "begin input parse"
input_parse "$@"
#done chewing.

#duck left?
if [ ! $MODEL_INFO ]; then
#its a new model? idk somethings odd. 
alert "No model.info in $MODEL_DIR var was $MODEL_INFO, it is not my job to make one either. try again"
exit ERROR
else
#duck right?
logvv "model.info was found $MODEL_INFO"
#source the web.info file. move to model-info file. 
#process map. dir -> isModel(y) -> model-info.sh calls model-hash.sh == DONE

#shouldn't source 
#source $MODEL_INFO
logvv "$MODEL_DIRECTORY"
hash_string 0.0
hash_key 0.0
#hash_string 0.01.1
#hash_string 0.001
#hash_string 0.2
#hash_string 1.001
#hash_string -1
fi
#running hash_string.. .


#log "2nd Test"
#logv "inter test"
#logvv "inter-intra test"
#input_parse "$@"
#alert "You suck"
#ext_log "This would be output to a log sys specified"
#trace "- someday"
}

#### END MAIN loop ###
function hash_string () {
logvv "hashing a string identifier for us humans"
case $1 in
0\.[0-1])
  logvv "Ver is $1 in 1"
  #by now source has all variables. It would be nice
  # to have this abstracted from the actual variable names. 
  # this would mean moving this to the old stardisks and getvalues
  # info script which is enormous already. lates
  #
  #Ver 0.0 - append basic info for stardisk model using :
  #
  # [N]:[Q]:[MODE]:[STARMASS]:[RESOLUTION]:[JIN]
grr=$1
  logvv " = $NVEC:$QVEC:$mVEC:$STARMASS:$JMAX:$JVEC:$1"
MODEL_HASH_STRING=$NVEC:$QVEC:$mVEC:$STARMASS:$JMAX:$JVEC
logvv "model-hash-string var $MODEL_HASH_STRING:$1 #[N]:[Q]:[MODE]:[STARMASS]:[RESOLUTION]:[JIN]:$1"
if ! grep -q MODEL_HASH_STRING $MODEL_INFO ; then
logvv "no hash string in model info. writing one"
#temp="$MODEL_HASH_STRING:$($1)"
#temp="$temp$1"
echo -e "MODEL_HASH_STRING=$MODEL_HASH_STRING:$grr" >> $MODEL_INFO
#unset temp
else
   logvv "hash string present"
fi
  ;;
0\.[1-2])
  logvv "Ver is $1 in 2"
  ;;
0\.[3-4])
  logvv "Ver is $1 in 3"
  ;;
0\.[4-5])
  logvv "Ver is $1 in 4"
  ;;
*\.*)
  logvv "Ver is $1 in error"
  #do some basic things or error out. error atm
  ;;
esac



}
function hash_key () {
logvv "hashing a UNIQUE-ish identifier for this model in computer speak"
MODEL_HASH_KEY=`echo $MODEL_HASH_STRING | md5sum | cut -f1 -d" "`
logvv "hash key = $MODEL_HASH_KEY"
if ! grep -q MODEL_HASH_KEY $MODEL_INFO ; then
logvv "no hash key"
echo "MODEL_HASH_KEY=$MODEL_HASH_KEY:$1" >> $MODEL_INFO
else
   logvv "hash key present"
fi
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
#who really does any work around here anyway
main "$@"
