#!/usr/bin/env bash

_V=2

#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
#source $_SRC_DIR/src-log.sh
#logvv "Test"

function main() {
log "2nd Test"
#parse1 ./rslts.018000 ./parse1.txt
coef_phase ./coefs_phase ./coph.txt
logv "inter test"
#logvv "inter-intra test"
input_parse "$@"
alert "You suck"
ext_log "This would be output to a log sys specified"
trace "- someday"
}

#### END MAIN loop ###

function log () {
if [[ $_V -ge 0 ]]; then
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
function logv () {
if [[ $_V -ge 1 ]]; then
  echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: $@" >&2
fi
}
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
function logvv () {
if [[ $_V -ge 2 ]]; then
  echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: $@" >&2
fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO}: Currently Unsupported $@" >&2
}
#end


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

### LEGACY STUFFS ####


##### PARSING FUNCTIONS #####


function coef_phase() {
# while read p; do echo -ne "$p\n$(echo -n $p | egrep -o '\b[0-9]{3}\s\b')"; done < coefs_phase
# time (cat ./rslts.018000 | egrep '(*COEFS*|*PHASE*)' | while read p; do echo -ne "$p\n$(echo -n $p | egrep -o '\b^[0-9]{0,3}\s\b')"; done > ./test.txt) > ./outfile

while read p; do echo -ne "$p\n$(echo -n $p | egrep -o '\b^[0-9]{0,3}\s\b')"; done < $1 > $2

}



# RSLTS.XXXXX - grabs J,K,L,S,T,A,U,W,JN,OMEGA,EPS,P,RHO,PHI columns from file 
# cat ./rslts.018000 | ((echo -e "# J, K, L") && (egrep '^[^#;]([[:space:]]*)?\b([0-9][0-9]?[0-9]?\s\s?){3}\b'))
## final 
# cat ./rslts.018000 | ((echo -e "# J, K, L") && (egrep '^[^#;]([[:space:]]*)?\b([0-9][0-9]?[0-9]?\s\s?){3}\b')) | tr -s '[:space:]' | cut -d' ' -f2,4,5,7,15
#
function parse1() {
# $1 is filename to read, $2 is filename to output to. $3 is column string? (set)
# whooops this is better
# '^[^#;]?([[:space:]]*)?\b([0-9][0-9]?[0-9]?\s?\s?){3}\b'
# and a newer 
# egrep '^[^#;]?([[:space:]]*)?\b([0-9]|\s)([0-9]|\s)[0-9]?([0-9]|\s)([0-9]|\s)[0-9]([0-9]|\s)([0-9]|\s)[0-9]\b'

#well this is futile? who puts data of different formats in one massive effing file, wtf
#leaves crap behind 4000  1.0417E+00  2.6022E-04 -5.5169E-02 -1.1034E-01  1.8751E-02  3.6423E-02  0.0000E+00  0.0000E+00  1.0000E+00  5.5710E-10  19
egrep '^[^#;]?([[:space:]]*)?\b([0-9]|\s)?([0-9]|\s)?([0-9]|\s)([0-9]|\s)([0-9]|\s)[0-9]([0-9]|\s)([0-9]|\s)[0-9]\b' $1 | sed -e "s/^.\{3\}/&\ /g" | tr -s '[:space:]' | sed "s/^[ \t]*//" | cut -d' ' -f1,2,4 > $2

} 
#who really does any work around here anyway
main "$@"
