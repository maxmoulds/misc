#!/usr/bin/env bash
#todo - deal with db already there. 
#todo - signal to web master which infos to call. -- for now just doing it one by one. 
#default minimum verbosity
_V=0
function main() {
#script makes db from directory passed into web-config.sh stored in web.config
logv "Reading config...."
source "$(pwd)/web.input"
logv "EXECDIR: $EXECDIR"
logv "MODEL_DIRECTORY: $MODEL_DIRECTORY"

MODEL_DB=${EXECDIR}/temp/model.db
NEW_MODELS=${EXECDIR}/temp/newmodels.db

#touch the dbs is not presents
if [ ! -f $MODEL_DB ]; then
  logvv "Making new DB for all models"
  touch "$MODEL_DB"
  cat >>"${MODEL_DB}" <<EOL
  #example model database
  #gives named directories for model, DOES not 
  #tell or change anything in directory, 
  #simply gets all models in the model directory
  #adds the new models to newmodels.db and verifies
  #that the model.db has the same number or less 
  #of entries as directories in that model folder.
  # example: n1.5q1.5m4M0.01j104
EOL
fi
if [ ! -f $NEW_MODELS ]; then
  logv "Make new models db"
  touch "$NEW_MODELS"
  cat >>"${NEW_MODELS}" <<EOL
  #New Model DB, contains all models that need to be web'd up!
EOL
fi

logv "Model DBs: $MODEL_DB  $NEW_MODELS" >&2

#ls -d -1 $PWD/**
#for TEMP in $(ls -R $MODEL_DIRECTORY | awk '
#  /:$/&&f{s=$0;f=0}
#  /:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
#  NF&&f{ print s"/"$0 }') ; do
for TEMP in $(find $MODEL_DIRECTORY -type d) ; do
  #need to check is temp is in db
  if [ -d "$TEMP" ]; then
    if !(grep -Fxq "$TEMP" $MODEL_DB); then
      #if not add to new or ?
      logv "Adding $TEMP"
      write_new_models $TEMP
    fi
  else
    logv "Not added, not a dir: "$temp
  fi
done



#processs?????? testing using move model
while read p || [[ -n $p ]]; do 
  if [ -a "$p/web.info" ]; then
    logv "web.info found - skipping: $p"
  else
    logvv "no web.info $p"
    if [[ ${p:0:1} != "#" ]]; then #first line is a not a comment line dooo
      logvv "isModel: $(is_model $p) - $p"
      if [ "$(is_model $p)" = true ]; then
        logv "Calling web-info.sh: $p"
        source "$EXECDIR"/web-info.sh -m "$p" -g png --verbosity="$_V"
        move_model "$p"
      else
        logv "It was not a model, maybe a organizing dir of sorts: $p"
      fi
      remove_model "$p" $NEW_MODELS
    else
      logv "I dunno what it was, probably a comment: $p"
    fi
  fi
done <$NEW_MODELS
}
###FUNCTIONS###
function is_model() {
if [ ! -f "$1/fort.50" -a ! -f "$1/fort.2" ]; then
  logvv "Not a model, no fort files: $1"
  echo false
  exit
fi
if [ ! -f "$1/polyout" ]; then
  logvv "Not a model, no polyout: $1"
  echo false
  exit
fi
if [ ! -f "$1/output.txt" ]; then
  logvv "Not a model, no output.txt: $1"
  echo false
  exit
fi
logvv "For all I know, it is a model: $1"
echo true
exit
}

function move_model() {
#just a tester
if [[ ${1:0:1} != "#" ]]; then #first line is a not a comment line dooo
  grep -v "$1" $NEW_MODELS > temp.newModels && mv temp.newModels $NEW_MODELS
  cat >>"${MODEL_DB}" <<EOL
  $1
EOL
  logv "Moved Model $1"
else
  log "move_model was given a comment skipping: "${1: -59}
fi
}
function write_new_models() {
#if appending : cat >> ....
cat >>"${NEW_MODELS}" <<EOL
$1
EOL
}
function remove_model() {
#make this awk or sed 
grep -v "$1" "$2" > temp.newModels && mv temp.newModels $2
logv "Removed Model $1"
}
function log () {
if [[ $_V -ge 0 ]]; then
  echo " [ERROR] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
}
function logv () {
if [[ $_V -ge 1 ]]; then
  echo " [WARNING] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
}
function logvv () {
if [[ $_V -ge 2 ]]; then
  echo " [INFO] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
}

main "$@"
