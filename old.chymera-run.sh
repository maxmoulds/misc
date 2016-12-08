#!/usr/bin/env bash
#DEFAULT LEVEL OF VERBOSITY#
_V=2
####### WELCOME TO THE ULTIMATE-ISH CHYMERA RUN SCRIPT(S)
# WORKS WITH point (chymera-uo)
# WORKS WITH resolved (chymera-whit)
# SEE support section(s) listed below to add support for 
# new model types or change existing behavior.
# UNLESS NOTED, most sections will not need to be changed
# from model to model and 
## NO SECTIONS, I repeat NO CHANGES SHOULD BE MADE
# from run to run of the same model type. 
# Those changes are to be made in the "input" file 
# for this script
#####
#  USAGE  #
# I test with the command 
# $ bash ./[this script.sh] -i [input.txt]
# # so an example would be...
# $ bash ./chymera-run.sh -i pM1m3k256j256.txt 
#
# SECTIONS
# # INCLUDES - these are files required for the models to run
# # VARIABLES - these are commandline switches/info.txt vars
# # # used to tweak the 'run'
# # SCRIPTS - abstracted logic, for simplicity. add function here
# # # then call in the main. 

##### MAIN LOGIC #### where the meat is. 
#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
#src-log.sh is not supported atm. 
#source $_SRC_DIR/src-log.sh

#NOTE ANY CALLS TO FUNCTIONS DEFINED IN THIS SCRIPT outside 
# of the main loop will not function as one would expect. 
# jail me from here on out. 

function main() {
# 1. Set up log / parse commandline _CHYMERA_input-parse
# 2. Check location/find bin - {all files} _CHYMERA_md5-sum
# 3. Determine point/resolved - start/restart
# 4. Read/Write Info
#USE LOG as a general messaging system to the user. 
#useful in interactive mode, and as a way of seeing
#in process info (see attachment, terminal catch/redirect)
log "Welcome to the CHYMERA run script written by Max Moulds"
#USE LOGV to send non-important user info. 
#USE LOGVV to send even less important user info
#USE LOGVVV to send non-sensical jibberish meant to entertain
#basic environment sanity check. 
logv "Today is a wonderful day because it is $(date). And the sun is shining somewhere"
logv "You are using this program on a $(uname -a) machine"
logvv "$(fortune)"
# End basic sanity - starting serious work
#parse commandline first
input_parse "$@"
#use alert to send important program related messages that may need to 
# handled by the/a script. 
alert "You are awesome, and passed me $# arguments, and   info files"
logvv "here are some files to hash from $RUN_DIR"
####TEMPORARY SUPPORT
__md5_files=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/analysis/* | egrep -v '^d' | head -c-1 | wc -l)
logvv "after analysis __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/bin/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis __md5_sum is $__md5_files"
md5_sum_check $RUN_DIR
md5_sum_gen $RUN_DIR
md5_sum_check $RUN_DIR
#use ext_log only if you have set up support for this. 
#and example of this is to log the progress of the run externally by another script. 
#see run-log.sh as a call .
#ext_log "This would be output to a log sys specified"
#TRACE is not to be used yet. I was just getting way ahead of myself. 
# trace "- someday"

#do some input based logic
#are we in a model directory? every chymera model should have a bin directory. 
#see INCLUDES SECTION for a list of what I expect. 

}

#### END MAIN loop ###

#### VARIABLES SECTION ####
## !! must come 2nd after main logic, but before scripts
#COLOR
__RED='\033[0;31m'
__NC='\033[0m'
__YEL='\033[1;33m'
__GRN='\033[0;32m'
__WHT='\033[1;37m'
__BACK_RED='\033[41m'
#__md5_files=
#END COLOR

__POINT_LIBS="bin analysis" 
__RESOLVED_LIBS="bin"
#### ! END VARIABLES SECTION ####

#### INCLUDES SECTION ####
# this section can float anywhere and even be external. 
# it has to exist though. 
#BIN - POINT
POINT_BIN_MAKEFILE_MD5=51085ee3a3e11c6a3b0136cd89f7a9e5
POINT_BIN_MAKEFILE_DEFS_MD5=da704f27e861b3f25cba0822259c3681
POINT_BIN_MAKEFILE_GCC_MD5=16f7b4e6705e808cc0d657017b2f1b54
POINT_BIN_MAKEFILE_INTEL_MD5=03ad220064829ddedc02cde04a897649
#ANALYSIS - POINT
point_analysis_chympart2_f90=0daad1ed78865401b16c205ec3c4d83a
point_analysis_chympart_f90=4af60343102da1aaa689463860076263
point_analysis_dustprof_f90=0f9356cf2b1ad6a9c877289ee7bff773
point_analysis_dustsig_f90=bdd6d0cddc927d185b33edc322b8294c
point_analysis_find_clump_py=8c834ca62a1557e83152c0d80b10df29
point_analysis_gastodust_f90=2625feabd86b25c984ac63a466e4a9a4
point_analysis_inject_az_f90=a119e232d0c825de5d2358df6ef697e0
point_analysis_inject_rz_f90=29c2d5ee71a2da090be2f5bbe2a874fe
point_analysis_make_disk_model_py=99d8396c7cba6a0dc4a0258658f53162
point_analysis_makeimage_py=6316d965c751ad877d339a21ce9c316a
point_analysis_makemerid_sh=fe85c26fdfc50542ee54bade94fb2972
point_analysis_makesig_sh=6821ec6c39bdd56e301662f85858df2f
point_analysis_maxClump_f90=51f569f423a7ec5571b4f2fc03534f8f
point_analysis_mdot_image_py=795ca59cc90de5fd76a07985eb60edc1
point_analysis_mdot_py=9f87511eea872216cf173e7b06dc768f
point_analysis_meridional_f90=518d5683a0cbed98de2087f67525ec45
point_analysis_midplot=9ea3ae6e6d80d3699a386439e1dd3040
point_analysis_midplot_f90=fbc050264721b0e3a88261511aec722e
point_analysis_overden_f90=05ee58e91f6598bddcb3fdf06e49a478
point_analysis_phase_f90=35f6025fb914e6bbc5f47149b3271b7d
point_analysis_phiplot_f90=5332d160e606b07fb063ac7cb39676ce
point_analysis_plotpart_f90=265b4a98dda0560e1e54191aa6212239
point_analysis_plotpart_sh=3b9d08defe4a2add4f67f891f474f073
point_analysis_q_init=aee00d2dbfbf74080013517e2f79cb06
point_analysis_qlocal_py=08949c103089edfd48c92af622cadc97
point_analysis_qprof_var=4c7a42a31f8c813db8dc450863da90fa
point_analysis_qprof_var_f90=a4bb8a17db730001ee46b4031ed622d1
point_analysis_script_test=fc8acee1098e62573814d570c6e808cf
point_analysis_sigplot_f90=cc8f6eb7277f0757008c3da11ea6f0ba
point_analysis_test_rho_png=bebb26906927f4f42ce435a16e54d00b
point_analysis_test_tk_png=43ec8f70bbc32bbaacf137e317d59a77
point_analysis_truelove2_f90=3bbad61c955735fd43797189b6796adb
point_analysis_truelove_f90=0ed31cc83128b7b160e73c4482e5ea0b
point_analysis_vplot_cyl_f90=8ad7eeae20ffdd33450feda51f1e1044
point_analysis_vplot_f90=e4b2c603cba42344c61b18e9c95da1c3
#END POINT

#BIN - RES

#END BIN - RES

#### SCRIPTS SECTION ######

## RERUN save logic (formerly 'movit')

## ! END RERUN ##

## LOGGING LOG FUNCTIONS ##

#this is the error function. Indicates a problem which no logic
#has been written to handle
function log () {
if [[ $_V -ge 0 ]]; then
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
    function logv () {
    if [[ $_V -ge 1 ]]; then
      echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
    fi
  }
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
  function logvv () {
  if [[ $_V -ge 2 ]]; then
    echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
  fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: Currently Unsupported $@" >&2
}
#end

## ! END LOGGING LOG FUNCTIONS ##

function input_parse() {
###INPUT STUFF###
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -r|--run-directory)
      RUN_DIR="$2"
      shift # past argument
      ;;
    -i|--input)
      INPUT="$2"
      shift # past argument
      ;;
    -d|--source-directory)
      SRC_DIR="$2"
      shift # past argument
      ;;
    -w|--web-directory)
      WEB_DIRECTORY="$2"
      shift # past argument
      ;;
    -s|--shared)
      SRC_DIR="$2"
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
## ! END INPUT SECTION ###

## MD5-SUM CHECK and GEN ##
## mario me baby..
# find point/analysis/* | tr '/' '_' | tr '.' '_' | sed -e 's/^/if \[ "$/' | sed -e 's/$/\ == $(md5sum \$1\/Makefile.intel | cut --delimiter=\" \" -f1 ) ]; then\n((__md5_files_temp++))\nlogvv "checksums OKAY -- "/' | temp=$(find point/analysis/* | tr '/' '_' | tr '.' '_') | 
# ooo bash sing me the sweet songs of your people...
# for file in point/analysis/* ; do ((echo -en $file |tr '/' '_' | tr '.' '_' | tr '-' '_' | sed -e 's/^/if \[ "$/' | sed -e 's/$/\" == $(md5sum \$1\//' && ( echo -en "${file#*/}" ) | sed -e 's/$/\ | cut --delimiter=\" \" -f1 ) ]; then\n((__md5_files_temp++))\nlogvv "checksums OKAY -- /') && ( echo -e "\$$file\"" |tr '/' '_' | tr '.' '_' | tr '-' '_' && echo -e "else" && echo -e "alert \"$(echo -e $file | tr '/' '_' | tr '.' '_' | tr '-' '_') did not match\"" && echo -e "fi" ) ) ; done 
#
# EYAH BABY

function md5_sum_check() {
local __md5_files_temp
__md5_files_temp=0 # $__md5_files
#__md5_files_temp=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./* | egrep -v '^d' | head -c-1 | wc -l)
# first arg is the folder/file
if [[ -a $1 ]]; then
  logvv "$1 exists"
  #this can be done externally, see the web scripts
#logvv "$1/Makefile"
#logvv "$(md5sum $1/Makefile | cut --delimiter=" " -f1)"
if [ "$POINT_BIN_MAKEFILE_MD5" == "$(md5sum $1/bin/Makefile | cut --delimiter=" " -f1 )" ]; then
 ((__md5_files_temp++))
logvv "checksums OKAY -- POINT_BIN_MAKEFILE_MD5=$POINT_BIN_MAKEFILE_MD5"
else
alert "POINT_BIN_MAKEFILE_MD5 did not match $POINT_BIN_MAKEFILE_MD5 != $(md5sum $1/bin/Makefile | cut --delimiter=" " -f1 )"
fi
if [ "$POINT_BIN_MAKEFILE_DEFS_MD5" == "$(md5sum $1/bin/Makefile.DEFS | cut --delimiter=" " -f1 )" ]; then
 ((__md5_files_temp++))
logvv "checksums OKAY -- POINT_BIN_MAKEFILE_DEFS_MD5=$POINT_BIN_MAKEFILE_DEFS_MD5"
else
alert "POINT_BIN_MAKEFILE_DEFS_MD5 did not match $POINT_BIN_MAKEFILE_DEFS_MD5 != $(md5sum $1/bin/Makefile.DEFS | cut --delimiter=" " -f1 )"
fi
if [ "$POINT_BIN_MAKEFILE_GCC_MD5" == "$(md5sum $1/bin/Makefile.gcc | cut --delimiter=" " -f1 )" ]; then
 ((__md5_files_temp++))
logvv "checksums OKAY -- POINT_BIN_MAKEFILE_GCC_MD5=$POINT_BIN_MAKEFILE_GCC_MD5"
else
alert "POINT_BIN_MAKEFILE_GCC_MD5 did not match $POINT_BIN_MAKEFILE_GCC_MD5 != $(md5sum $1/bin/Makefile.gcc | cut --delimiter=" " -f1 )"
fi
if [ "$POINT_BIN_MAKEFILE_INTEL_MD5" == "$(md5sum $1/bin/Makefile.intel | cut --delimiter=" " -f1 )" ]; then
 ((__md5_files_temp++))
 logvv "checksums OKAY -- POINT_BIN_MAKEFILE_INTEL_MD5=$POINT_BIN_MAKEFILE_INTEL_MD5"
else
 alert "POINT_BIN_MAKEFILE_INTEL_MD5 did not match $POINT_BIN_MAKEFILE_INTEL_MD5 != $(md5sum $1/bin/Makefile.intel | cut --delimiter=" " -f1 )"
fi

logvv "starting analysis sums"
#point analysis files.
if [ "$point_analysis_chympart2_f90" == $(md5sum $1/analysis/chympart2.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_chympart2_f90"
else
alert "point_analysis_chympart2_f90 did not match"
fi
if [ "$point_analysis_chympart_f90" == $(md5sum $1/analysis/chympart.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_chympart_f90"
else
alert "point_analysis_chympart_f90 did not match"
fi
if [ "$point_analysis_dustprof_f90" == $(md5sum $1/analysis/dustprof.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_dustprof_f90"
else
alert "point_analysis_dustprof_f90 did not match"
fi
if [ "$point_analysis_dustsig_f90" == $(md5sum $1/analysis/dustsig.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_dustsig_f90"
else
alert "point_analysis_dustsig_f90 did not match"
fi
if [ "$point_analysis_find_clump_py" == $(md5sum $1/analysis/find_clump.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_find_clump_py"
else
alert "point_analysis_find_clump_py did not match"
fi
if [ "$point_analysis_gastodust_f90" == $(md5sum $1/analysis/gastodust.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_gastodust_f90"
else
alert "point_analysis_gastodust_f90 did not match"
fi
if [ "$point_analysis_inject_az_f90" == $(md5sum $1/analysis/inject_az.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_inject_az_f90"
else
alert "point_analysis_inject_az_f90 did not match"
fi
if [ "$point_analysis_inject_rz_f90" == $(md5sum $1/analysis/inject_rz.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_inject_rz_f90"
else
alert "point_analysis_inject_rz_f90 did not match"
fi
if [ "$point_analysis_make_disk_model_py" == $(md5sum $1/analysis/make_disk_model.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_make_disk_model_py"
else
alert "point_analysis_make_disk_model_py did not match"
fi
if [ "$point_analysis_makeimage_py" == $(md5sum $1/analysis/makeimage.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makeimage_py"
else
alert "point_analysis_makeimage_py did not match"
fi
if [ "$point_analysis_makemerid_sh" == $(md5sum $1/analysis/makemerid.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makemerid_sh"
else
alert "point_analysis_makemerid_sh did not match"
fi
if [ "$point_analysis_makesig_sh" == $(md5sum $1/analysis/makesig.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makesig_sh"
else
alert "point_analysis_makesig_sh did not match"
fi
if [ "$point_analysis_maxClump_f90" == $(md5sum $1/analysis/maxClump.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_maxClump_f90"
else
alert "point_analysis_maxClump_f90 did not match"
fi
if [ "$point_analysis_mdot_image_py" == $(md5sum $1/analysis/mdot_image.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_mdot_image_py"
else
alert "point_analysis_mdot_image_py did not match"
fi
if [ "$point_analysis_mdot_py" == $(md5sum $1/analysis/mdot.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_mdot_py"
else
alert "point_analysis_mdot_py did not match"
fi
if [ "$point_analysis_meridional_f90" == $(md5sum $1/analysis/meridional.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_meridional_f90"
else
alert "point_analysis_meridional_f90 did not match"
fi
if [ "$point_analysis_midplot" == $(md5sum $1/analysis/midplot | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_midplot"
else
alert "point_analysis_midplot did not match"
fi
if [ "$point_analysis_midplot_f90" == $(md5sum $1/analysis/midplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_midplot_f90"
else
alert "point_analysis_midplot_f90 did not match"
fi
if [ "$point_analysis_overden_f90" == $(md5sum $1/analysis/overden.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_overden_f90"
else
alert "point_analysis_overden_f90 did not match"
fi
if [ "$point_analysis_phase_f90" == $(md5sum $1/analysis/phase.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_phase_f90"
else
alert "point_analysis_phase_f90 did not match"
fi
if [ "$point_analysis_phiplot_f90" == $(md5sum $1/analysis/phiplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_phiplot_f90"
else
alert "point_analysis_phiplot_f90 did not match"
fi
if [ "$point_analysis_plotpart_f90" == $(md5sum $1/analysis/plotpart.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_plotpart_f90"
else
alert "point_analysis_plotpart_f90 did not match"
fi
if [ "$point_analysis_plotpart_sh" == $(md5sum $1/analysis/plotpart.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_plotpart_sh"
else
alert "point_analysis_plotpart_sh did not match"
fi
if [ "$point_analysis_q_init" == $(md5sum $1/analysis/q.init | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_q_init"
else
alert "point_analysis_q_init did not match"
fi
if [ "$point_analysis_qlocal_py" == $(md5sum $1/analysis/qlocal.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qlocal_py"
else
alert "point_analysis_qlocal_py did not match"
fi
if [ "$point_analysis_qprof_var" == $(md5sum $1/analysis/qprof_var | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qprof_var"
else
alert "point_analysis_qprof_var did not match"
fi
if [ "$point_analysis_qprof_var_f90" == $(md5sum $1/analysis/qprof_var.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qprof_var_f90"
else
alert "point_analysis_qprof_var_f90 did not match"
fi
if [ "$point_analysis_script_test" == $(md5sum $1/analysis/script_test | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_script_test"
else
alert "point_analysis_script_test did not match"
fi
if [ "$point_analysis_sigplot_f90" == $(md5sum $1/analysis/sigplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_sigplot_f90"
else
alert "point_analysis_sigplot_f90 did not match"
fi
if [ "$point_analysis_test_rho_png" == $(md5sum $1/analysis/test-rho.png | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_test_rho_png"
else
alert "point_analysis_test_rho_png did not match"
fi
if [ "$point_analysis_test_tk_png" == $(md5sum $1/analysis/test-tk.png | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_test_tk_png"
else
alert "point_analysis_test_tk_png did not match"
fi
if [ "$point_analysis_truelove2_f90" == $(md5sum $1/analysis/truelove2.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_truelove2_f90"
else
alert "point_analysis_truelove2_f90 did not match"
fi
if [ "$point_analysis_truelove_f90" == $(md5sum $1/analysis/truelove.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_truelove_f90"
else
alert "point_analysis_truelove_f90 did not match"
fi
if [ "$point_analysis_vplot_cyl_f90" == $(md5sum $1/analysis/vplot_cyl.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_vplot_cyl_f90"
else
alert "point_analysis_vplot_cyl_f90 did not match"
fi
if [ "$point_analysis_vplot_f90" == $(md5sum $1/analysis/vplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_vplot_f90"
else
alert "point_analysis_vplot_f90 did not match"
fi
#end point analysis fils
fi
log "MD5SUM $__md5_files_temp of $__md5_files"
unset __md5_files_temp
}
function md5_sum_gen() {
# first arg is the folder/file
local __md5_files_temp
__md5_files_temp=0 #$__md5_files
if [[ -a $1 ]]; then
  logvv "$1 exists"
  #can you say mario to this next line. 
#  __md5_files=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./* | egrep -v '^d' | head -c-1 | wc -l)
  logv "Running $__md5_files_temp hashes, unless you expected this warning, this model maybe altered"
  #this can be done externally, see the web scripts
POINT_BIN_MAKEFILE_MD5=$(md5sum $1/bin/Makefile | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
 ((__md5_files_temp++))
logvv "POINT_BIN_MAKEFILE_MD5=$POINT_BIN_MAKEFILE_MD5"
else
alert "POINT_BIN_MAKEFILE_MD5 error'd out"
fi
POINT_BIN_MAKEFILE_DEFS_MD5=$(md5sum $1/bin/Makefile.DEFS | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
 ((__md5_files_temp++))
logvv "POINT_BIN_MAKEFILE_DEFS_MD5=$POINT_BIN_MAKEFILE_DEFS_MD5"
else
alert "POINT_BIN_MAKEFILE_DEFS_MD5 error'd out"
fi
POINT_BIN_MAKEFILE_GCC_MD5=$(md5sum $1/bin/Makefile.gcc | cut --delimiter=" " -f1 )
if [ "$?" == 0 ]; then
 ((__md5_files_temp++))
logvv "POINT_BIN_MAKEFILE_GCC_MD5=$POINT_BIN_MAKEFILE_GCC_MD5"
else
alert "POINT_BIN_MAKEFILE_GCC_MD5 error'd out"
fi
POINT_BIN_MAKEFILE_INTEL_MD5=$(md5sum $1/bin/Makefile.intel | cut --delimiter=" " -f1 )
if [ "$?" == 0 ]; then
 ((__md5_files_temp++))
 logvv "POINT_BIN_MAKEFILE_INTEL_MD5=$POINT_BIN_MAKEFILE_INTEL_MD5"
else
 alert "POINT_BIN_MAKEFILE_INTEL_MD5 error'd"
fi

#begin analysis section
# Some mario magic for ya...
# for file in point/analysis/* ; do ((echo -en $file | tr '/' '_' | tr '.' '_' | tr '-' '_' | sed -e 's/$/\=$(md5sum \$1\//' && ( echo -en "${file#*/}" ) | sed -e 's/$/\ | cut --delimiter=\" \" -f1 )\nif [ "$?" ==  0 ]; then\n((__md5_files_temp++))\nlogvv "/') && ( echo -en "$file" |tr '/' '_' | tr '.' '_' | tr '-' '_' && echo -e "=\$$(echo -e $file | tr '/' '_' | tr '.' '_' | tr '-' '_' )\"" ) && echo -e "else\nalert \"$file error'd out\"\nfi") ; done
#

point_analysis_chympart2_f90=$(md5sum $1/analysis/chympart2.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_chympart2_f90=$point_analysis_chympart2_f90"
else
alert "point/analysis/chympart2.f90 error'd out"
fi
point_analysis_chympart_f90=$(md5sum $1/analysis/chympart.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_chympart_f90=$point_analysis_chympart_f90"
else
alert "point/analysis/chympart.f90 error'd out"
fi
point_analysis_dustprof_f90=$(md5sum $1/analysis/dustprof.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_dustprof_f90=$point_analysis_dustprof_f90"
else
alert "point/analysis/dustprof.f90 error'd out"
fi
point_analysis_dustsig_f90=$(md5sum $1/analysis/dustsig.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_dustsig_f90=$point_analysis_dustsig_f90"
else
alert "point/analysis/dustsig.f90 error'd out"
fi
point_analysis_find_clump_py=$(md5sum $1/analysis/find_clump.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_find_clump_py=$point_analysis_find_clump_py"
else
alert "point/analysis/find_clump.py error'd out"
fi
point_analysis_gastodust_f90=$(md5sum $1/analysis/gastodust.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_gastodust_f90=$point_analysis_gastodust_f90"
else
alert "point/analysis/gastodust.f90 error'd out"
fi
point_analysis_inject_az_f90=$(md5sum $1/analysis/inject_az.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_inject_az_f90=$point_analysis_inject_az_f90"
else
alert "point/analysis/inject_az.f90 error'd out"
fi
point_analysis_inject_rz_f90=$(md5sum $1/analysis/inject_rz.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_inject_rz_f90=$point_analysis_inject_rz_f90"
else
alert "point/analysis/inject_rz.f90 error'd out"
fi
point_analysis_make_disk_model_py=$(md5sum $1/analysis/make_disk_model.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_make_disk_model_py=$point_analysis_make_disk_model_py"
else
alert "point/analysis/make_disk_model.py error'd out"
fi
point_analysis_makeimage_py=$(md5sum $1/analysis/makeimage.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makeimage_py=$point_analysis_makeimage_py"
else
alert "point/analysis/makeimage.py error'd out"
fi
point_analysis_makemerid_sh=$(md5sum $1/analysis/makemerid.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makemerid_sh=$point_analysis_makemerid_sh"
else
alert "point/analysis/makemerid.sh error'd out"
fi
point_analysis_makesig_sh=$(md5sum $1/analysis/makesig.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makesig_sh=$point_analysis_makesig_sh"
else
alert "point/analysis/makesig.sh error'd out"
fi
point_analysis_maxClump_f90=$(md5sum $1/analysis/maxClump.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_maxClump_f90=$point_analysis_maxClump_f90"
else
alert "point/analysis/maxClump.f90 error'd out"
fi
point_analysis_mdot_image_py=$(md5sum $1/analysis/mdot_image.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_mdot_image_py=$point_analysis_mdot_image_py"
else
alert "point/analysis/mdot_image.py error'd out"
fi
point_analysis_mdot_py=$(md5sum $1/analysis/mdot.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_mdot_py=$point_analysis_mdot_py"
else
alert "point/analysis/mdot.py error'd out"
fi
point_analysis_meridional_f90=$(md5sum $1/analysis/meridional.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_meridional_f90=$point_analysis_meridional_f90"
else
alert "point/analysis/meridional.f90 error'd out"
fi
point_analysis_midplot=$(md5sum $1/analysis/midplot | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_midplot=$point_analysis_midplot"
else
alert "point/analysis/midplot error'd out"
fi
point_analysis_midplot_f90=$(md5sum $1/analysis/midplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_midplot_f90=$point_analysis_midplot_f90"
else
alert "point/analysis/midplot.f90 error'd out"
fi
point_analysis_overden_f90=$(md5sum $1/analysis/overden.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_overden_f90=$point_analysis_overden_f90"
else
alert "point/analysis/overden.f90 error'd out"
fi
point_analysis_phase_f90=$(md5sum $1/analysis/phase.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_phase_f90=$point_analysis_phase_f90"
else
alert "point/analysis/phase.f90 error'd out"
fi
point_analysis_phiplot_f90=$(md5sum $1/analysis/phiplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_phiplot_f90=$point_analysis_phiplot_f90"
else
alert "point/analysis/phiplot.f90 error'd out"
fi
point_analysis_plotpart_f90=$(md5sum $1/analysis/plotpart.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_plotpart_f90=$point_analysis_plotpart_f90"
else
alert "point/analysis/plotpart.f90 error'd out"
fi
point_analysis_plotpart_sh=$(md5sum $1/analysis/plotpart.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_plotpart_sh=$point_analysis_plotpart_sh"
else
alert "point/analysis/plotpart.sh error'd out"
fi
point_analysis_q_init=$(md5sum $1/analysis/q.init | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_q_init=$point_analysis_q_init"
else
alert "point/analysis/q.init error'd out"
fi
point_analysis_qlocal_py=$(md5sum $1/analysis/qlocal.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qlocal_py=$point_analysis_qlocal_py"
else
alert "point/analysis/qlocal.py error'd out"
fi
point_analysis_qprof_var=$(md5sum $1/analysis/qprof_var | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qprof_var=$point_analysis_qprof_var"
else
alert "point/analysis/qprof_var error'd out"
fi
point_analysis_qprof_var_f90=$(md5sum $1/analysis/qprof_var.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qprof_var_f90=$point_analysis_qprof_var_f90"
else
alert "point/analysis/qprof_var.f90 error'd out"
fi
point_analysis_script_test=$(md5sum $1/analysis/script_test | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_script_test=$point_analysis_script_test"
else
alert "point/analysis/script_test error'd out"
fi
point_analysis_sigplot_f90=$(md5sum $1/analysis/sigplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_sigplot_f90=$point_analysis_sigplot_f90"
else
alert "point/analysis/sigplot.f90 error'd out"
fi
point_analysis_test_rho_png=$(md5sum $1/analysis/test-rho.png | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_test_rho_png=$point_analysis_test_rho_png"
else
alert "point/analysis/test-rho.png error'd out"
fi
point_analysis_test_tk_png=$(md5sum $1/analysis/test-tk.png | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_test_tk_png=$point_analysis_test_tk_png"
else
alert "point/analysis/test-tk.png error'd out"
fi
point_analysis_truelove2_f90=$(md5sum $1/analysis/truelove2.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_truelove2_f90=$point_analysis_truelove2_f90"
else
alert "point/analysis/truelove2.f90 error'd out"
fi
point_analysis_truelove_f90=$(md5sum $1/analysis/truelove.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_truelove_f90=$point_analysis_truelove_f90"
else
alert "point/analysis/truelove.f90 error'd out"
fi
point_analysis_vplot_cyl_f90=$(md5sum $1/analysis/vplot_cyl.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_vplot_cyl_f90=$point_analysis_vplot_cyl_f90"
else
alert "point/analysis/vplot_cyl.f90 error'd out"
fi
point_analysis_vplot_f90=$(md5sum $1/analysis/vplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_vplot_f90=$point_analysis_vplot_f90"
else
alert "point/analysis/vplot.f90 error'd out"
fi
#end analysis
fi
unset __md5_files_temp
}
## ! MD5-SUM ##

#### ! END SCRIPTS SECTION #####



#### Gah-NOPE ####
#who really does any work around here anyway
main "$@"
