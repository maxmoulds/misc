#todo - readin web.config. 
#todo - output web.info.
#todo - replace polyout/fort.50 with a variable, $2, 
#todo - get rid of printf calls. wow. 
#todo - add web.info UPDATE, atm overwrites all.
#todo - add "history" variables.....

#Default values to this web.info are found in default.web.config.
#WARNING, order of the web.info file is not maintained, duplication of arguments
#also is not strictly enforced so be mindful that first occurences or last 
# are inplay. 
#WARNING, web.info is also updated by web-config.sh, which is a script that
#is initiated globally for ALL models by the web-ify process therefore
#web-config values can be used as the definitive location for arguments
#needed across multiple scripts. (tehehe)
#WARNING - all functions in this file are overriden by functions with the same name
#deeper in the directory structure, example. 
# webdir/web.sh is called with argument on modeldir
#in modeldir there are two "types" of models,
#modeltype1 and modeltype2 each with a web dir with local web.sh addins. 
#so /modeltype1/web/[web script in question].sh will override all "values"
#created by this file, this is not to say that the generic function did not run 
#but it does not ensure that value was calculated either. Have fun. 

#minmum verbosity
_V=0

function main() {
WEB_INFO=$(pwd)"/web.info"
WEB_INFO_SEC=$WEB_INFO".secured"
WEB_INFO_EXISTS=false
EXECDIR=$(pwd)
MODEL_DIRECTORY=$(pwd)
ERROR="ERROR"
load_web_info
input_parse "$@"
CUR_DIR=$MODEL_DIRECTORY
logvv "Descending into $CUR_DIR"
if [ $WEB_INFO_EXISTS ]; then
  #web info exists
  logvv "good job web.info is here and ready to go"
else
  logv "web.info was not specified/found...creating one"
  touch $(pwd)/web.info
  WEB_INFO_EXISTS=true
fi

####FUNC CALLS####
read -r -d '' func_var << EOL
####GENERAL####
WEB_INFO=$WEB_INFO
WEB_INFO_EXISTS=$WEB_INFO_EXISTS
#WEB_INFO_SECURED=$WEB_INFO_SECURED
MODEL_DIRECTORY=$MODEL_DIRECTORY
CUR_DIR=$CUR_DIR
EXECDIR=$EXECDIR
VERBOSITY=$_V
ERROR=$ERROR
#####MODEL INFO#####
NOTDONE=$(notDone $CUR_DIR)
STEPSCOMPLETED=$(stepsCompleted $CUR_DIR)
ISRUNNING=$(isRunning $CUR_DIR)
JVEC=$(jVec $CUR_DIR)
MVEC=$(MVec $CUR_DIR)
mVEC=$(mVec $CUR_DIR)
QVEC=$(qVec $CUR_DIR)
NVEC=$(nVec $CUR_DIR)
JMAX=$(jmax $CUR_DIR)
JTOTP=$(jtotp $CUR_DIR)
OMEGAMAX=$(omegaMax $CUR_DIR)
ETOT=$(etot $CUR_DIR)
TJEANS=$(tjeans $CUR_DIR)
TSOUND=$(tsound $CUR_DIR)
STARMASS=$(starMass $CUR_DIR)
TW=$(TW_eval $CUR_DIR)
RINOUT=$(rInOut $CUR_DIR)
RPLUSR0=$(rPlusR0 $CUR_DIR)
RMINUSR0=$(rMinusR0 $CUR_DIR)
RHOMAX=$(rhomax $CUR_DIR)
QMINUSR0=$(qMinusR0 $CUR_DIR)
QPLUSR0=$(qPlusR0 $CUR_DIR)
RLAMBDAR0=$(rLambdaR0 $CUR_DIR)
MIRP=$(MIRP_eval $CUR_DIR)
ETA=$(eta $CUR_DIR)
P=$(p_eval $CUR_DIR)
TAUZERO=$(tauzero $CUR_DIR)
SQRTTAU=$(sqrtTau $CUR_DIR)
OMEGAZERO=$(omegazero $CUR_DIR)
JEANSFREQ=$(jeansfreq $CUR_DIR)
CFREQZERO=$(cfreqzero $CUR_DIR)
KEPLERFREQ=$(keplerfreq $CUR_DIR)
VIRIALERROR=$(virialError $CUR_DIR)
MASS=$(mass $CUR_DIR)
ONEMINUSRINR0=$(oneMinusRInR0 $CUR_DIR)
R0=$(r0 $CUR_DIR)
RADSTARMINUS=$(radstarMinus $CUR_DIR)
RADSTAR=$(radstar $CUR_DIR)
RADSTARPLUS=$(radstarPlus $CUR_DIR)
EOL
if [[ $_V -le 2 ]]; then
  cat >"${WEB_INFO}" <<EOL
  $func_var
EOL
else
  ( set -o posix ; set ) > "$WEB_INFO"
fi
###END MODEL FUNC CALLS ####

### todo section, should be all comments. 

#grep "^function" $0
#
#set_function_configs () {
#echo "functions available:"
#  #temp=$(typeset -f | awk '/ \(\) $/ && !/^main / {print $1}' | sed 's/$/=/')
#  temp=$(typeset -f | awk '/ \(\) $/ && !/^main / {print $1}')
#  #echo $temp
#  run=( $temp )
#  for word in "${run[@]}"; 
#  do  
#    echo "$word"
#    #echo "1";
#  done
#  #for word in "${a[@]}"; do echo "- [$word]"; done
#  #${word}="$word";done
#}
#set_function_configs

####END todo section
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

###########Start model function definition#######
function notDone
{	# Returns 1 if a run needs to be started or restarted, otherwise returns empty.
  # Conditions are: if no growth rate convergence and less than "max" steps
  # (set below,) or if fort.50 not present. Set neverRestart to false to enable.
  logvv $1
  neverRestart=false

  [ ! $max ] && max=200000

  if [ "$neverRestart" != "true" ]; then
    if [ -f fort.50 ]; then
      if [ "$(Y2)" = "0" ] && [ $(stepsCompleted) -lt $max ]; then
        notDone=1
      fi
    else
      notDone=1
    fi
  fi
  echo $notDone
}

function stepsCompleted
{
  logvv $1
  if [ -f fort.23a ]; then
    steps=$(cat fort.23a | wc -l)
  elif [ -f fort.23 ]; then
    steps=$(cat fort.23 | wc -l)
  else
    logv "fort.23a and fort.23 not found"
    steps=$ERROR
  fi
  echo $steps
}

function isRunning
{
  # command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  command -v qstat >/dev/null 2>&1 || { logv "qstat is required but it's not installed"; echo $ERROR; exit; }
  [ $(qstat -f | grep Job_Name | cut -c 16- | grep `basename $(pwd)`) ] && echo true;
}

#what is the jvec? I am assuming, the 
function jVec
{
  logvv $1
  #wow this needs major work. 
  #for folder in `ls`; do
  #for folder in $2; do
  #if [ -f $folder/fort.50 ]; then
  if [ -f $1/fort.50 ]; then
    #echo "jvec found a file?"
    # I WILL GRAB THE BASENAME OF THE PWD THE MOST COMPLICATED WAY POSSIBLE, cuz im cool. 
    #j=${folder##*j}; jVec="$jVec $j"
    j=${1##*j}; jVec="$jVec $j"
    #  fi
    #done
    #now im not really sure why he sorts... 
    echo $jVec | sed 's/ /\n/g' | sort -gu
  else
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function MVec
{
  logvv $1
  #for folder in `ls`; do
  #if [ -f $folder/fort.50 ]; then
  if [ -f $1/fort.50 ]; then
    #M=${folder%%j*}; M=${M##*M}; MVec="$MVec $M"
    M=${1%%j*}; M=${M##*M}; MVec="$MVec $M"
    #fi
    #done
    echo $MVec | sed 's/ /\n/g' | sort -gu
  else
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function mVec
{
  logvv $1
  #lets try something different here. 
  #for folder in `ls`; do
  folder=$1
  if [ -f $folder/torus.out ]; then
    #m=${folder%%M*}; m=${m##*m}; mVec="$mVec $m"
    echo $(grep -oP '(?<=mode = )\w+' $folder/torus.out)
    #fi
    #done
    #echo $mVec | sed 's/ /\n/g' | sort -gu
  else
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function qVec
{
  logvv $1
  #for folder in `ls`; do
  folder=$1
  if [ -f $folder/fort.50 ]; then
    q=${folder%%m*}; q=${q##*q}; qVec="$qVec $q"
    #fi
    #done
    echo $qVec | sed 's/ /\n/g' | sort -gu
  else
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function nVec
{
  logvv $1
  folder=$1
  #for folder in `ls`; do
  if [ -f $folder/fort.50 ]; then
    n=${folder%%q*}; n=${n##*n}; nVec="$nVec $n"
    #fi
    #done
    echo $nVec | sed 's/ /\n/g' | sort -gu
  else 
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function jmax
{
  logvv $1
  if [ -a $1/fact ]; then
    jmax=`grep -w jmax $1/fact | cut -c 22-25`
    echo $jmax
  else
    logv "fact not found"
    echo $ERROR
  fi
}

function jtotp
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w jtotp $1/fact | cut -c 29-31`
    base=`grep -w jtotp $1/fact | cut -c 18-27`
    jtotp=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $jtotp
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function omegaMax
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w omega\ max $1/fact | cut -c 29-32`
    base=`grep -w omega\ max $1/fact | cut -c 18-27`
    omegaMax=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $omegaMax
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function etot
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w etot $1/fact | cut -c 29-32`
    base=`grep -w etot $1/fact | cut -c 18-27`
    etot=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $etot
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function tjeans
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w tjeans: $1/fact | cut -c 24-27`
    base=`grep -w tjeans: $1/fact | cut -c 16-22`
    tjeans=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $tjeans
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function tsound
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w tsound: $1/fact | cut -c 24-27`
    base=`grep -w tsound: $1/fact | cut -c 16-22`
    tsound=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $tsound
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function starMass
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w star/disk: $1/polyout | cut -c 24-26`
    base=`grep -w star/disk: $1/polyout | cut -c 16-22`
    starMass=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $starMass
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function TW_eval
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w t/\|w\| $1/polyout | cut -c 36-38`
    base=`grep -w t/\|w\| $1/polyout | cut -c 28-34`
    TW=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $TW
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function rInOut
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w r-/r+: $1/polyout | cut -c 24-26`
    base=`grep -w r-/r+: $1/polyout | cut -c 16-22`
    rInOut=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $rInOut
  else
    logv "polyout not found"
    echo $ERROR
  fi
}


function rPlusR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w r+/r0: $1/polyout | cut -c 24-26`
    base=`grep -w r+/r0: $1/polyout | cut -c 16-22`
    rPlusR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $rPlusR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function rMinusR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w r-/ro: $1/polyout | cut -c 24-26`
    base=`grep -w r-/ro: $1/polyout | cut -c 16-22`
    rMinusR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $rMinusR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function rhomax
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w rhomax: $1/polyout | cut -c 24-26`
    base=`grep -w rhomax: $1/polyout | cut -c 16-22`
    rhomax=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $rhomax
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function qMinusR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w Q-/r0: $1/polyout | cut -c 25-27`
    base=`grep -w Q-/r0: $1/polyout | cut -c 17-23`
    qMinusR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $qMinusR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function qPlusR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w Q+/r0: $1/polyout | cut -c 28-30`
    base=`grep -w Q+/r0: $1/polyout | cut -c 20-26`
    qPlusR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $qPlusR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function rLambdaR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w rvortmax/r0: $1/polyout | cut -c 28-30`
    base=`grep -w rvortmax/r0: $1/polyout | cut -c 20-26`
    rLambdaR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $rLambdaR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function MIRP_eval
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w MIRP: $1/polyout | cut -c 24-26`
    base=`grep -w MIRP: $1/polyout | cut -c 16-22`
    MIRP=`echo "scale=8; ($base/1)*10^(0$exp)" | bc`
    echo $MIRP
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function eta
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w eta: $1/polyout | cut -c 24-26`
    base=`grep -w eta: $1/polyout | cut -c 16-22`
    eta=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $eta
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function p_eval
{
  logvv $1
  if [ -a $1/polyout ]; then
    printf '%.4f' `grep -w \ \ \ \ \ p: $1/polyout | cut -c 16-26`
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function tauzero
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w tauzero: $1/polyout | cut -c 24-26`
    base=`grep -w tauzero: $1/polyout | cut -c 16-22`
    tauzero=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $tauzero
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function sqrtTau
{
  logvv $1
  if [ -a $1/polyout ]; then
    printf '%.4f' `grep -w sqrtTau: $1/polyout | cut -c 16-26`
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function omegazero
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w omegazero: $1/polyout | cut -c 28-30`
    base=`grep -w omegazero: $1/polyout | cut -c 20-26`
    omegazero=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $omegazero
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function jeansfreq
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w jeans\ freq: $1/polyout | cut -c 28-30`
    base=`grep -w jeans\ freq: $1/polyout | cut -c 20-26`
    jeansfreq=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $jeansfreq
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function cfreqzero
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w c\ freq\ zero: $1/polyout | cut -c 28-30`
    base=`grep -w c\ freq\ zero: $1/polyout | cut -c 20-26`
    cfreqzero=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $cfreqzero
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function keplerfreq
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w kepler\ freq: $1/polyout | cut -c 28-30`
    base=`grep -w kepler\ freq: $1/polyout | cut -c 20-26`
    keplerfreq=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $keplerfreq
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function virialError
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w virial\ error $1/polyout | cut -c 36-39`
    base=`grep -w virial\ error $1/polyout | cut -c 28-34`
    virialError=`echo "scale=8; ($base/1)*10^(0$exp)" | bc`
    echo $virialError
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function mass
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w mass: $1/polyout | cut -c 18-21`
    base=`grep -w mass: $1/polyout | cut -c 10-16`
    mass=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    #logvv "polyout found"
    echo $mass
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function oneMinusRInR0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w 1\ -\ r-/r0: $1/polyout | cut -c 26-29`
    base=`grep -w 1\ -\ r-/r0: $1/polyout | cut -c 18-24`
    oneMinusRInR0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $oneMinusRInR0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function r0
{
  logvv $1
  if [ -a $1/polyout ]; then
    exp=`grep -w \ \ \ \ \ r0: $1/polyout | cut -c 21-24`
    base=`grep -w \ \ \ \ \ r0: $1/polyout | cut -c 13-19`
    r0=`echo "scale=4; ($base/1)*10^(0$exp)" | bc`
    echo $r0
  else
    logv "polyout not found"
    echo $ERROR
  fi
}

function radstarMinus
{
  logvv $1
  if [ -a $1/fort.50 ]; then
    grep $FUNCNAME: $1/fort.50 | awk '{ printf "%g", $1; }'
  else
    logv "fort.50 does not exist"
    echo $ERROR
  fi
}

function radstar
{
  logvv $1
  #Below is THE BEST way to get a value that I've found.
  #Printed number must be in 2nd column; columns may be
  #delimited by any number of spaces. 
  if [ -a $1/fort.50 ]; then
    grep $FUNCNAME: $1/fort.50 | awk '{ printf "%g", $1; }'
    #A space in the name (i.e. "M torque/M1") will break it.
    #This can be fixed by adding a sed command as follows:
    #grep -m 1 M\ torque/M1: fort.50 | sed s@M\ torque/M1:@@ | awk '{ printf "%g", $1 }'
  else
    logv "fort.50 not found"
    echo $ERROR
  fi
}

function radstarPlus
{
  logvv $1
  if [ -a "$1/fort.50" ]; then
    logvv "fort.50 exists"
    grep $FUNCNAME: $1/fort.50 | awk '{ printf "%g", $1; }'
  else
    logv "fort.50 does not exist"
    echo $ERROR
  fi
}
##### END MODEL INFO FUNCTIONS #####

##### WEB-INFO FUNCTIONS #####
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
function input_parse() {
###INPUT STUFF###
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -g|--extension)
      EXTENSION="$2"
      shift # past argument
      ;;
    -i|--input-config)
      INPUT_CONFIG="$2"
      shift # past argument
      ;;
    -m|--model-directory)
      MODEL_DIRECTORY="$2"
      WEB_INFO="$2""/web.info"
      shift # past argument
      ;;
    -w|--web-directory)
      WEB_DIRECTORY="$2"
      shift # past argument
      ;;
    --default)
      DEFAULT=YES
      ;;
    --web-info)
      WEB_INFO="$2"
      if [ -a $WEB_INFO ]; then
        WEB_INFO_EXISTS=true
      fi
      shift # past argument
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

#### END WEB-INFO functions #####
#and a single call to main yay!
main "$@"
