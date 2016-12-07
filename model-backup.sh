#!/usr/bin/env bash

# ERROR - todo - prefix support

#this script, when give a directory, makes
#a tarball for all directories (models) in 
#that dir. 
#usage model-baskup.sh <MODEL_DIRECTORY> <OUTPUT_DIRECTORY>
#if no output dir is specified, 2 default actions can be chosen
# a dir of all the tarballs in the MODEL_DIR (assuming write)
# at the same level of the model in MODEL_DIRECTORY or 
# (most common) if no write perms, the ~/backup/ of the 
# user calling the script
#USAGE
# model-backup.sh -m <dir_with_models_to_backup> -o <output_location>
#NO REMOTE ATM

_V=2
function main() {
#chew a little
source web-isModel.sh
input_parse "$@"
#done with that
DIR_COUNT=0
for d in "$MODEL_DIRECTORY"/* ; do
  if isModel "$d" ; then
    ((DIR_COUNT++))
    logv "model found sending to pack"
    logvv "$MODEL_DIRECTORY/$MODEL_PREFIX-$(basename $d).tar.gz : $DIR_COUNT : to $TAR_DIRECTORY"
    #pack $d "$MODEL_DIRECTORY/$(basename $d.tar.gz)"
    pack $d "$TAR_DIRECTORY"/"$MODEL_PREFIX-$(basename $d)".tar.gz
  else
    logv "not a model dir, still descend later $d"
    #something like...
    #exec model-backup.sh $d 
  fi
  log "Done, tarball $DIR_COUNT models"
done
unset DIR_COUNT
}
function log () {
if [[ $_V -ge 0 ]]; then
  echo " [ERROR] ${BASH_SOURCE}:${FUNCNAME[1]}: $@" >&2
fi
}

function logv () {
if [[ $_V -ge 1 ]]; then
  echo " [WARNING] ${BASH_SOURCE}:${FUNCNAME[1]}: $@" >&2
fi
}
function logvv () {
if [[ $_V -ge 2 ]]; then
  echo " [INFO] ${BASH_SOURCE}:${FUNCNAME[1]}: $@" >&2
fi
}

function input_parse() {
#default arguments
EXECDIR=$(pwd)
MODEL_DIRECTORY=$(pwd)
TAR_DIRECTORY=$(pwd)
ERROR=-1
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -o|--output)
      TAR_DIRECTORY="$2"
      shift # past argument
      ;;
    -m|--model-directory)
      MODEL_DIRECTORY="$2"
      shift # past argument
      ;;
-p|--prefix)
MODEL_PREFIX="$2"
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
#CHECKING DIRS
MODEL_DIRECTORY="$(cd "$(dirname "$MODEL_DIRECTORY")"; pwd)/$(basename "$MODEL_DIRECTORY")"
TAR_DIRECTORY="$(cd "$(dirname "$TAR_DIRECTORY")"; pwd)/$(basename "$TAR_DIRECTORY")"
if [ ! -r $MODEL_DIRECTORY ]; then
  log "input directory is not readable: $MODEL_DIRECTORY"
  exit
fi
if [ ! -w $TAR_DIRECTORY ]; then
  log "output directory is not writeable: $TAR_DIRECTORY"
  TAR_DIRECTORY=$(pwd)
fi
command -v tar >/dev/null 2>&1 || { logv "tar is required but it's not installed"; echo $ERROR; exit; }
command -v rsync >/dev/null 2>&1 || { logv "rsync is required but it's not installed"; echo $ERROR; exit; }
}
function pack() {
logv "I have a model"
logv "$(isModel $1) 0=y, 1=n: from $1 to $2"
#begin pack logic
GZIP=-9
logvv "tar -cvzf $2 -C ." #/$(basename $MODEL_PREFIX)-$(basename $1)"
tar -czf $2 -C $1 .  #/"$(basename $MODEL_PREFIX)-$(basename $1)"
unset GZIP
}
main "$@"
#end
