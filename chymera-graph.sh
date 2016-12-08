#!/usr/bin/env bash

#SET ME UP - for the arial error with gnuplot
export GDFONTPATH=/usr/share/fonts/liberation
export GNUPLOT_DEFAULT_GDFONT=LiberationSans-Regular


_V=2
__ERR=1
#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
#source $_SRC_DIR/src-log.sh
#logvv "Test"

__tempout=""
__tempin=""

function main() {
__RUN_DIR="./"
__RUN_NAME="run-test"
__MODEL_NAME="resolved-test"
log "2nd Test"
logv "inter test"
#logvv "inter-intra test"
input_parse "$@"
resolved_plotmfrac ./input ./output
resolved_plotit ./input ./output
#resolved_signu ./sigin ./sigout # need expains
point_hscf_contour ./point/runM1p/hscf ./pointout
resolved_equilib_contour ./resolved/runM1r/equilib ./resolvedout
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
#function legacy_analysis_plotpart() {
#!/bin/tcsh
# $1 start file number
# $2 end file number
# $3 advance file
# $4 title
# $5 input file prefix contain dierctory
# $6 output file prefix contain directory

#  if ( $#argv != 6 ) then
#       printf "\n\n\n A CHYMTOOL SPONSORED EVENT\n\n" ;
#       echo "makeplot v 1.  11.10.2007. Nora Bolig"
#       printf "\n\n";
#       echo "THERE SHOULD BE SEVEN ARGUMENTS"
#       printf "\n";
#       echo "Usage: $0 '{start file number} {end file number} {file number skip}'"
#       echo "' {title} {dir/input_prefix} {dir/output_prefix} '"
#       printf "\n";
#       echo "Calling Cthulu...(run)"
#       exit 127;
#  endif

# printf "\n\n\n A CHYMTOOL SPONSORED EVENT\n\n" ;
# printf " makeplot v 1.  11.10.2007. Nora Bolig\n\n\n";
# printf " You typed: $0 $1 $2 $3 $4 $5 $6 \n";
# printf "\n Check image for correct contours.\n\n";
 

# set dum1 = ` gnuplot --version | awk '{print substr($2,1,1)}' `
# set dum2 = ` gnuplot --version | awk '{print substr($2,3,3)}' `

# if ( $dum1 < 4 )  then
#   echo " Please update your version of gnuplot to 4.2 or higher "
#   echo " You are using' `gnuplot --version` "
#   exit
# else if ( $dum2 < 2 ) then
#   echo " Please update your version of gnuplot to 4.2 or higher "
#   echo " You are using' `gnuplot --version` "
#   exit
# endif

# @ i = $1 # starting file number

# while ( $i < $2 )  # endfile file number

# @ j = $i
# set j = `printf "%06d" $j`
   
#  set l = `grep $j $5 | grep FILE | awk '{print $5}'`

# gnuplot << LEAVE 

#unset key
#set size ratio 1
#set title "10cm Dust Particles"
#set tics out
#set xlabel 'AU'
#set ylabel 'AU'
#set terminal postscript eps color enhanced  size 8in,8in font "Helvetica" 36
#set output "$6$j.eps" 
#plot [-150:150][-150:150] '$5$j'  u 2:3 ps .1

#LEAVE
 
# echo file $i
# @ i = $i + $3

# end

#exit 0;
#}


##### GRAPHING FUNCTIONS #####

function example() {
__TIME=$(date +%F-%Hh%Mm-%Ss)
logv "TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
for FILE in *; do
    gnuplot <<EOF
set xlabel "Label"
set ylabel "Label2"
set term png
set output "${FILE}.png"
plot "${FILE}" using 1:2:3:4 with errorbars title "Graph title"
EOF
done
unset __tempin
unset __tempout
}

function point_hscf_contour() {
__TIME=$(date +%F-%Hh%Mm-%Ss)
logv "TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
    gnuplot <<EOF
reset 
rhomax = 3.6326E-03
set terminal jpeg
set output "${__tempout}/contour-${__MODEL_NAME}-${__RUN_NAME}-${__TIME}.jpeg"
set contour
set cntrparam levels incremental 1.0e-9,0.1*rhomax,rhomax
set size square
set grid
set mxtics
set mytics
set nosurface
set view 0,0
set data style lines
set nokey
splot '${__tempin}/fort.47'
EOF
unset __tempin
unset __tempout
}

function resolved_equilib_contour() {
__TIME=$(date +%F-%Hh%Mm-%Ss)
logv "TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
    gnuplot <<EOF
reset
diskRhomax=6.59078E-04
starRhomax=2.31173E-02
set xrange [0:515]
set yrange [0:515]
set term post eps enhanced color solid
set output "${__tempout}/equilib-${__MODEL_NAME}-${__RUN_NAME}-${__TIME}.ps"
set size 1.0,0.7
set multiplot
set contour
set cntrparam levels incremental 1.0e-20,.1*diskRhomax,diskRhomax
set size .9, 1.2
set grid
set mxtics
set mytics
set nosurface
set view 0,0
set data style lines
set nokey
splot '${__tempin}/fort.47' lw 3
set cntrparam levels incremental 1.0e-20,.1*starRhomax,starRhomax
splot '${__tempin}/fort.47' lw 3
unset multiplot
EOF
unset __tempin
unset __tempout
}

function resolved_signu() {
__TIME=$(date +%F-%Hh%Mm-%Ss)
logv"TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
# Here is the loop over directories of the structure datdir/sigplot.??????
 for file in "$__tempin"/sigout.??????
 do
        ext="${file##*.}"
        base="$(basename "$file")"
        ofile="rho2d.${ext}-${__MODEL_NAME}-${__RUN_NAME}-${__TIME}.png"
        log $ofile
        cd $__tempin
gnuplot <<EOF
set term png
set output "${__tempout}/${ofile}"
plot "$base" w image title "Mass density, iteration ${ext}."
EOF
 done


log "Sigplot files in $__tempin have been plotted."
unset __tempin
unset __tempout
}


function resolved_plotmfrac() {
__TIME=$(date +%F-%Hh%Mm-%Ss)
local dirtemp
logv "TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
gnuplot <<EOF
reset
set terminal png
set output '${__tempout}/mfrac-${__MODEL_NAME}-${__RUN_NAME}-${__TIME}.png'
set multiplot
set size 1.0,0.5
set xlabel 'r(pu)'
set ylabel 'm_c'
set logscale y
set origin 0.0,0.0
plot '${__tempin}/mfrac.dat' u 2:4 w p,'${__tempin}/mfrac.000' u 2:4 w p
set origin 0.0,0.5
set ylabel 'dJ'
plot '${__tempin}/mfrac.dat' u 2:7 w p,'${__tempin}/mfrac.000' u 2:7 w p
unset multiplot
EOF
unset __ANS
unset __tempin
unset __tempout
}


function resolved_plotit() {
# $1 is input $2 is output?
__TIME=$(date +%F-%Hh%Mm-%Ss)
logv "TIME: $__TIME"
__check_input $1 $2
if [ "$?" -eq "$__ERR" ]
then
exit $__ERR
fi
gnuplot <<EOF
reset
set terminal png
set output "${__tempout}/amp-${__MODEL_NAME}-${__RUN_NAME}-${__TIME}.png"
scale = 213.198
set logscale y
set key t l
set multiplot
set size 1.0,0.5
set xlabel 'time (MIRP)'
set ylabel 'disk'
set origin 0.0,0.5
plot "${__tempin}/tcoefb" u (\$1*scale):2 w l t 'm=1',\
'${__tempin}/tcoefb' u (\$1*scale):3 w l t 'm=2',\
'${__tempin}/tcoefb' u (\$1*scale):4 w l t 'm=3',\
'${__tempin}/tcoefb' u (\$1*scale):5 w l t 'm=4',\
'${__tempin}/tcoefb' u (\$1*scale):6 w l t 'm=5',\
'${__tempin}/tcoefb' u (\$1*scale):7 w l t 'm=6',\
'${__tempin}/tcoefb' u (\$1*scale):8 w l t 'm=7',\
'${__tempin}/tcoefb' u (\$1*scale):9 w l t 'm=8'
set ylabel "star"
set origin 0.0,0.0
plot "${__tempin}/tcoefa" u (\$1*scale):2 w l t 'm=1',\
'${__tempin}/tcoefa' u (\$1*scale):3 w l t 'm=2',\
'${__tempin}/tcoefa' u (\$1*scale):4 w l t 'm=3',\
'${__tempin}/tcoefa' u (\$1*scale):5 w l t 'm=4',\
'${__tempin}/tcoefa' u (\$1*scale):6 w l t 'm=5',\
'${__tempin}/tcoefa' u (\$1*scale):7 w l t 'm=6',\
'${__tempin}/tcoefa' u (\$1*scale):8 w l t 'm=7',\
'${__tempin}/tcoefa' u (\$1*scale):9 w l t 'm=8'
unset logscale y
unset multiplot
reset
set output "${__tempout}/amfrac-${__MODEL_NAME}-${__RUN_NAME}-$__TIME}.png"
set multiplot
set size 1.0,0.5
set xlabel 'r(pu)'
set ylabel 'm_c'
set logscale y
set origin 0.0,0.0
plot "${__tempin}/mfrac.dat" u 2:4 w p,"${__tempin}/mfrac.000" u 2:4 w p
set origin 0.0,0.5
set ylabel '{\Symbol D}J'
plot "${__tempin}/mfrac.dat" u 2:7 w p,"${__tempin}/mfrac.000" u 2:7 w p
unset logscale y
unset multiplot
EOF
#log "what the hell"
unset __tempout
unset __tempin
}

## UTILITY
__tempout=""
__tempin=""
function __check_input() {
#$1 is in $2 is out
unset __tempout
unset __tempin
local __ANS
if [ -d $1 ]
then
    logv "input dir: $1 exists"
    __tempin=$1
else
    logv "$1 does not exist! #See source to force : Using run_dir $__RUN_DIR"
    #$1=$__RUN_DIR
    exit "$__ERR"
fi
if [ -d $2 ]
then
    logv "output dir: $2 exists"
    __tempout=$2
else
    alert "$2 does not exist! create it? [Y/n] - You have 10 seconds before this message self-destructs"
    __ANS="y"
    read -t 10 __ANS
    if [ "$?" -ge 127 ]
    then
       __ANS="y"
    fi
    logv "You entered: $__ANS"
    if [[ "$__ANS" == "y" || "$__ANS" == "Y" ]]
    then
       logv "Creating $2"
       mkdir $2
       __tempout=$2
    else
       if [[ "$__ANS" == "n" ||"$__ANS" == "N" ]]
       then
          logv "NOT CREATING $2 - Using defaults $__RUN_DIR"
          __tempout="$__RUN_DIR"
       else
          alert "I don't know what you want me to do, guess I'll run and hide."
          exit "$__ERR"
       fi
    fi
    logv "Yay, using: $__tempin as the input and $__tempout as the output directories"
fi
unset __ANS
}

#who really does any work around here anyway
main "$@"
