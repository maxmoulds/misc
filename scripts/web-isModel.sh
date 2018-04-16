#!/usr/bin/env bash
function isModel() {
#DO NOT CALL THIS FUNCTION AND EXPECT ANYTHING
#all it does is provide a function used by all web
#scripts
#usage web-isModel.sh <MODEL_DIRECTORY>

#todo - add array calls web-isModel.sh <MODEL_DIRECTORY[#]> <BOOL[#]>
#   where bool is optional. i am going to do this once i have
#   model identities hammered out, so that offset errors done propagate

#todo - add conditonal returns, say - yes this is a model just not done 
#   yet, or no its a model but degraded etc

#lets start the whole dir things
WORKSPACE=$(pwd)
#if [ $(basename "$WORKSPACE") = "src" ]; then
  #your in the src folder
  #echo "your in the src folder"
#else
  #echo some error
  #echo "your not in the src folder"
#fi
#if [ ! -r $WORKSPACE../src/info-log.sh ]; then
#  echo "some error"
#else
#  source $WORKSPACE../src/info-log.sh
#fi
#if [ ! -r $WORKSPACE../src/warning-log.sh ]; then
#  echo "some error"
#else
#  source $WORKSPACE../src/warning-log.sh
#fi
#if [ ! -r $WORKSPACE../src/error-log.sh ]; then
#  echo "some error"
#else
#  source $WORKSPACE../src/error-log.sh
#fi
#end debug

#so $0 is the name, $1 is the <MODEL_DIRECTORY>
MODEL_DIRECTORY=$1
if ! ls -1 $MODEL_DIRECTORY/fort.* >/dev/null 2>&1 ; then
  #echo "some error that its not a model: $MODEL_DIRECTORY"
  return 1
elif [[ ! -a $MODEL_DIRECTORY/polyout ]]; then
  #echo "another error that its not a model: $MODEL_DIRECTORY"
#echo "no polyout"
  return 1
else
  #echo "its a model: $MODEL_DIRECTORY"
  return 0
fi
#end web-isModel
}
