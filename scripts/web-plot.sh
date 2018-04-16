#!/usr/bin/env bash

#usage: web-info.sh -d <MODEL_DIRECTORY> ... -i <PLOT.SH> ... -s <WEB_ISMODEL> -t <GRAPH_TYPE> ... 

#todo, add cl args
#todo, add graph types
#todo, source 

_V=2
function main() {
source web-isModel.sh
#source web-info.sh
input_parse "$@"
#do some stuff
#call graph
#do some more stuff
#say goodbye
}
### INTERESTING
# stardisks starDisk
#set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
# resDisks starDisk
#modelTitle=\"m${m}/js${js}/ks${ks}/np${np}/q${q}/r-+${r}-j${jin}/M${M}/${jmax}\"
### END

####
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

####
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
command -v gnuplot >/dev/null 2>&1 || { logv "gnuplot is required but it's not installed/adequate version"; echo $ERROR; exit; }
#command -v rsync >/dev/null 2>&1 || { logv "rsync is required but it's not installed"; echo $ERROR; exit; }
}

function graph_eqContour() {
   #plot eqContour
   echo "Generating contour plot..."
   r=`echo "scale=2; $($val rInOut)/1" | bc`
   plotCommand="
   reset\n
   set terminal png\n
   set output \"eqContour.png\"\n
   set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
   set contour\n
   set cntrparam levels incremental 1.0e-30,$(echo "scale=7; $($val rhomax)/10"
   | bc),$($val rhomax)\n
   set size square\n
   set grid\n
   set mxtics\n
   set mytics\n
   set nosurface\n
   set view 0,0\n
   set data style lines\n
   set nokey\n
   splot 'fort.47' ti \"fort.47\"\n
   "
   echo -e $plotCommand | gnuplot
}
function graph_plotit() {
   #plotit
   plotCommand="
   reset\n
   set terminal png\n
   set output \"plotit.png\"\n
   set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
   set logscale y\n
   set autoscale\n
   plot 'fort.23' using 1:2 with lines ti \"fort.23\",\
         'fort.23' using 1:4 with lines notitle,\
             'fort.23' using 1:6 with lines notitle\n
   "
   echo -e $plotCommand | gnuplot
}
function graph_plotitSum() {
        #plotitSum
        plotCommand="
        reset\n
        set terminal png\n
        set output \"plotitSum.png\"\n
        set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
        set logscale y\n
        set autoscale\n
        plot 'fort.34' using 1:2 with lines ti \"fort.34\"\n
        "
        echo -e $plotCommand | gnuplot
}
function graph_plotit2() {
   #plotit2
   plotCommand="
   reset\n
   set terminal png\n
   set output \"plotit2.png\"\n
   set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
   set auto\n
   plot 'fort.23' using 1:3 with lines ti \"fort.23\",\
         'fort.23' using 1:5 with lines notitle,\
             'fort.23' using 1:7 with lines notitle\n
   "
   echo -e $plotCommand | gnuplot
 }
 function graph_ee1() {
    #ee1
    plotCommand="
    reset\n
    set terminal png\n
    set output \"ee1.png\"\n
    set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
    set logscale y\n
    set auto\n
    plot 'fort.52' using 1:2 with lines lt 3 ti \"drho\",\
          'fort.52' using 1:3 with lines lt 1 ti \"dW\"\n
    "
    echo -e $plotCommand | gnuplot
  }
function graph_ee2m() {
   #ee2m1/ee2m2
if [ "${m}" = "1" ]; then
   points="'fort.63' with points lt 1 ti \"W phase\",
    'fort.53' with points lt 3 ti \"drho phase\","
elif [ "${m}" = "2" ]; then
   points="'fort.63' with points lt 1 ti \"W phase\",
    'fort.53' with points lt 3 ti \"drho phase\",
    'fort.63' using 3:2 with points lt 1 notitle,
    'fort.53' using 3:2 with points lt 3 notitle,"
elif [ "${m}" = "3" ]; then
   points="'fort.64' with points lt 1 ti \"W phase\",
    'fort.54' with points lt 3 ti \"drho phase\",
    'fort.64' using 3:2 with points lt 1 notitle,
    'fort.54' using 3:2 with points lt 3 notitle,
    'fort.64' using 4:2 with points lt 1 notitle,
    'fort.54' using 4:2 with points lt 3 notitle,"
elif [ "${m}" = "4" ]; then
   points="'fort.63' with points lt 1 ti \"W phase\",
    'fort.53' with points lt 3 ti \"drho phase\",
    'fort.63' using 3:2 with points lt 1 notitle,
    'fort.53' using 3:2 with points lt 3 notitle,
    'fort.63' using 4:2 with points lt 1 notitle,
    'fort.53' using 4:2 with points lt 3 notitle,
    'fort.63' using 5:2 with points lt 1 notitle,
    'fort.53' using 5:2 with points lt 3 notitle,"
elif [ "${m}" = "5" ]; then
        points="'fort.67' with points lt 1 ti \"W phase\",
         'fort.57' with points lt 3 ti \"drho phase\",
         'fort.67' using 3:2 with points lt 1 notitle,
         'fort.57' using 3:2 with points lt 3 notitle,
         'fort.67' using 4:2 with points lt 1 notitle,
         'fort.57' using 4:2 with points lt 3 notitle,
         'fort.67' using 5:2 with points lt 1 notitle,
         'fort.57' using 5:2 with points lt 3 notitle,
         'fort.67' using 6:2 with points lt 1 notitle,"
fi
rPlus=`echo "scale=2; $($val rPlusR0)/1" | bc`
rMinus=`echo "scale=2; $($val rMinusR0)/1" | bc`
if [ "$($val RcoR0)" = "NaN" ]; then
   plotRcR0=0
   dispRcR0=NaN
elif [ `echo "$($val RcoR0) > $rPlus" | bc` = 1 ]; then
   plotRcR0=0
   dispRcR0=$(echo "scale=2; $($val RcoR0)/1" | bc)
else
   plotRcR0=$(echo "scale=2; $($val RcoR0)/1" | bc)
   dispRcR0=$plotRcR0
fi
plotCommand="
reset\n
set terminal png\n
set output \"ee2m${m}.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set polar\n
set angles degrees\n
set size square\n
set samples 160,160\n
set trange [0:360]\n
plot ${points}
    ${rPlus} lt 3 ti \"r+/ro = ${rPlus}\",
    1.00 lt 4 ti \"ro/ro = 1.00\",
    ${rMinus} lt 3 ti \"r-/ro =  ${rMinus}\",
    ${plotRcR0} lt 5 ti \"rc/ro = ${dispRcR0}\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee3() {
torqueDir="torques"
if [ "${m}" = "1" ]; then
        points="'fort.24' u 2:9 w l lt 3 ti \"gravTotal\",
        'fort.24' u 2:3 w l lt 2 ti \"gravDisk\",
        'fort.24' u 2:5 w l lt 4 ti \"gravStar\",
        'fort.24' u 2:4 w l lt 5 ti \"Reynolds\",
        'fort.24' u 2:10 w l lt 1 ti \"totalTorque\""
elif [ "${m}" != "1" ]; then
points="'fort.24' u 2:3 w l lt 2 ti \"gravDisk\",
        'fort.24' u 2:4 w l lt 5 ti \"Reynolds\",
        'fort.24' u 2:10 w l lt 1 ti \"totalTorque\""
fi
plotCommand="
reset\n
set terminal png\n
set output \"ee3.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set auto\n
plot ${points}
"
echo -e $plotCommand | gnuplot
}
function graph_ee4() {
   #ee4
plotCommand="
reset\n
set terminal png\n
set output \"ee4.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set auto\n
plot 'fort.27' using 1:3 with points lt 3 ti 'Ek',\
    'fort.27' using 1:2 with points lt 6 ti 'Eh'\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee5() {
   #ee5
plotCommand="
reset\n
set terminal png\n
set output \"ee5.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set auto\n
plot 'fort.28' using 1:2 with points lt 0 ti 'R stress',\
    'fort.28' using 1:3 with points lt 1 ti 'G work',\
    'fort.28' using 1:4 with points lt 3 ti 'Acoustic flux'\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee6() {
   #ee6
plotCommand="
reset\n
set terminal png\n
set output \"ee6.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set auto\n
plot 'fort.29' using 1:2 with lines ti 'dj'\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee8() {
   #ee8
plotCommand="
reset\n
set terminal png\n
set output \"ee8.png\"\n
set title \"m${m}/n${n}/q${q}/r-+${r}-j${jin}/M${starMass}/${jmax}\"\n
set auto\n
plot 'fort.76' using 1:2 with points lt 0 ti 'R stress/E',\
    'fort.76' using 1:3 with points lt 1 ti 'G work/E',\
    'fort.76' using 1:4 with points lt 3 ti 'Acoustic flux/E'\n
"
echo -e $plotCommand | gnuplot
}
### resDisks graphs
function graph_ang_mom_trans() {
        #Angular momentum transport
plotCommand="
reset\n
set terminal png\n
set output \"angMomTrans.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.43' using 2:3 with lines lw 2 ti 'L transfer'\n
"
echo -e $plotCommand | gnuplot
}
function graph_lagrangian_torque() {
        #Lagrangian torque
plotCommand="
reset\n
set terminal png\n
set output \"lagrangTorq.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.130' u 3:5 w l lw 2 ti \"gravity\",\
     'fort.130' u 3:4 w l lw 2 ti \"Reynolds\",\
     'fort.130' u 3:6 w linespoints lw 2 ti \"total\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_djj() {
        #dJ/J
plotCommand="
reset\n
set terminal png\n
set output \"ee6.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.131' using 2:4 w l lw 2 ti 'dJ/J'\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee5_stresses() {
        #ee5 stresses
plotCommand="
reset\n
set terminal png\n
set output \"ee5.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.28' using 1:2 with points lt 0 ti 'R stress',\
         'fort.28' using 1:3 with points lt 1 ti 'G work',\
         'fort.28' using 1:4 with points lt 3 ti 'Acoustic flux'\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee4_work_integral() {
        #ee4 work integrals
plotCommand="
reset\n
set terminal png\n
set output \"ee4.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.27' using 1:3 with points lt 3 ti \"Ek\",\
         'fort.27' using 1:2 with points lt 6 ti \"Eh\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee3_torques() {
        #ee3 torques
plotCommand="
reset\n
set terminal png\n
set output \"ee3.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.125' u 3:4 w l lt 1 lw 2 ti \"Gravity\",\
     'fort.125' u 3:5 w l lt 2 lw 2 ti \"Reynolds\",\
     'fort.125' u 3:6 w l lt 3 lw 2 ti \"Total torque\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee2m_phase() {
#ee2m phase plots
if [ "${m}" = "1" ]; then
        points="'fort.63' using 1:2 with points lt 1 ti \"W phase\",
         'fort.53' using 1:2 with points lt 3 ti \"drho phase\","
elif [ "${m}" = "2" ]; then
        points="'fort.63' with points lt 1 ti \"W phase\",
         'fort.53' with points lt 3 ti \"drho phase\",
         'fort.63' using 3:2 with points lt 1 notitle,
         'fort.53' using 3:2 with points lt 3 notitle,"
elif [ "${m}" = "3" ]; then
        points="'fort.64' with points lt 1 ti \"W phase\",
         'fort.54' with points lt 3 ti \"drho phase\",
         'fort.64' using 3:2 with points lt 1 notitle,
         'fort.54' using 3:2 with points lt 3 notitle,
         'fort.64' using 4:2 with points lt 1 notitle,
         'fort.54' using 4:2 with points lt 3 notitle,"
elif [ "${m}" = "4" ]; then
        points="'fort.63' with points lt 1 ti \"W phase\",
         'fort.53' with points lt 3 ti \"drho phase\",
         'fort.63' using 3:2 with points lt 1 notitle,
         'fort.53' using 3:2 with points lt 3 notitle,
         'fort.63' using 4:2 with points lt 1 notitle,
         'fort.53' using 4:2 with points lt 3 notitle,
         'fort.63' using 5:2 with points lt 1 notitle,
         'fort.53' using 5:2 with points lt 3 notitle,"
elif [ "${m}" = "5" ]; then
        points="'fort.67' with points lt 1 ti \"W phase\",
         'fort.57' with points lt 3 ti \"drho phase\",
         'fort.67' using 3:2 with points lt 1 notitle,
         'fort.57' using 3:2 with points lt 3 notitle,
         'fort.67' using 4:2 with points lt 1 notitle,
         'fort.57' using 4:2 with points lt 3 notitle,
         'fort.67' using 5:2 with points lt 1 notitle,
         'fort.57' using 5:2 with points lt 3 notitle,
         'fort.67' using 6:2 with points lt 1 notitle,
         'fort.57' using 6:2 with points lt 3 notitle,"
elif [ "${m}" = "6" ]; then
        points="'fort.64' with points lt 1 ti \"W phase\",
         'fort.54' with points lt 3 ti \"drho phase\",
         'fort.64' using 3:2 with points lt 1 notitle,
         'fort.54' using 3:2 with points lt 3 notitle,
         'fort.64' using 4:2 with points lt 1 notitle,
         'fort.54' using 4:2 with points lt 3 notitle,
         'fort.64' using 5:2 with points lt 1 notitle,
         'fort.54' using 5:2 with points lt 3 notitle,
         'fort.64' using 6:2 with points lt 1 notitle,
         'fort.54' using 6:2 with points lt 3 notitle,
         'fort.64' using 7:2 with points lt 1 notitle,
         'fort.54' using 7:2 with points lt 3 notitle,"
elif [ "${m}" = "7" ]; then
        points="'fort.69' with points lt 1 ti \"W phase\",
         'fort.59' with points lt 3 ti \"drho phase\",
         'fort.69' using 3:2 with points lt 1 notitle,
         'fort.59' using 3:2 with points lt 3 notitle,
         'fort.69' using 4:2 with points lt 1 notitle,
         'fort.59' using 4:2 with points lt 3 notitle,
         'fort.69' using 5:2 with points lt 1 notitle,
         'fort.59' using 5:2 with points lt 3 notitle,
         'fort.69' using 6:2 with points lt 1 notitle,
         'fort.59' using 6:2 with points lt 3 notitle,
         'fort.69' using 7:2 with points lt 1 notitle,
         'fort.59' using 7:2 with points lt 3 notitle,
         'fort.69' using 8:2 with points lt 1 notitle,
         'fort.59' using 8:2 with points lt 3 notitle,"
elif [ "${m}" = "8" ]; then
        points="'fort.63' with points lt 1 ti \"W phase\",
         'fort.53' with points lt 3 ti \"drho phase\",
         'fort.63' using 3:2 with points lt 1 notitle,
         'fort.53' using 3:2 with points lt 3 notitle,
         'fort.63' using 4:2 with points lt 1 notitle,
         'fort.53' using 4:2 with points lt 3 notitle,
         'fort.63' using 5:2 with points lt 1 notitle,
         'fort.53' using 5:2 with points lt 3 notitle,
         'fort.69' using 9:2 with points lt 1 notitle,
         'fort.59' using 9:2 with points lt 3 notitle,
         'fort.69' using 10:2 with points lt 1 notitle,
         'fort.59' using 10:2 with points lt 3 notitle,
         'fort.69' using 11:2 with points lt 1 notitle,
         'fort.59' using 11:2 with points lt 3 notitle,
         'fort.69' using 12:2 with points lt 1 notitle,
         'fort.59' using 12:2 with points lt 3 notitle,"
fi
rPlus=`echo "scale=2; $($val rPlusR0)/1" | bc`
rMinus=`echo "scale=2; $($val rMinusR0)/1" | bc`
rStar=`echo "scale=2; $($val rStarR0)/1" | bc`
if [ "$($val RcoR0)" = "NaN" ]; then
        plotRcR0=0
        dispRcR0=NaN
elif [ `echo "$($val RcoR0) > $rPlus" | bc` = 1 ]; then
        plotRcR0=0
        dispRcR0=$(echo "scale=2; $($val RcoR0)/1" | bc)
else
        plotRcR0=$(echo "scale=2; $($val RcoR0)/1" | bc)
        dispRcR0=$plotRcR0
fi
plotCommand="
reset\n
set terminal png\n
set output \"ee2m${m}.png\"\n
set title $modelTitle\n
set polar\n
set angles degrees\n
set size square\n
set samples 160,160\n
set trange [0:360]\n
plot ${points}
         ${rPlus} lt 3 ti \"r+/ro = ${rPlus}\",
         1.00 lt 4 ti \"ro/ro = 1.00\",
         ${rMinus} lt 3 ti \"r-/ro =  ${rMinus}\",
         ${rStar} lt 1 ti \"r*/ro =  ${rStar}\",
         ${plotRcR0} lt 5 ti \"rc/ro = ${dispRcR0}\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_ee1() {
        #ee1
plotCommand="
reset\n
set terminal png\n
set output \"ee1.png\"\n
set title $modelTitle\n
set logscale y\n
set auto\n
plot 'fort.52' using 1:2 with points lt 3 ti \"drho\",\
         'fort.52' using 1:3 with points lt 1 ti \"dW\"\n
"
echo -e $plotCommand | gnuplot
unset logscale y\n
}
function graph_torque_time_history() {
echo -e $plotCommand | gnuplot

        #torque time history
plotCommand="
reset\n
set terminal png\n
set output \"torqueHistory.png\"\n
set title $modelTitle\n
set auto\n
set xlabel 'time (MIRP)'\n
plot 'fort.74' using 1:2 with points ti \"starTorque\",\
     'fort.74' using 1:3 with points ti \"diskTorque\",\
     'fort.74' using 1:4 with points ti \"totalTorque\"\n
"
echo -e $plotCommand | gnuplot
}
function graph_plotit2star() {
        #plotit2Star
plotCommand="
reset\n
set terminal png\n
set output \"plotit2Star.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.22' using 1:3 with lines ti \"fort.22\",\
         'fort.22' using 1:5 with lines notitle,\
         'fort.22' using 1:7 with lines notitle\n
"
echo -e $plotCommand | gnuplot
}
function graph_plotit2() {
        #plotit2
plotCommand="
reset\n
set terminal png\n
set output \"plotit2.png\"\n
set title $modelTitle\n
set auto\n
plot 'fort.23' using 1:3 with lines ti \"fort.23\",\
         'fort.23' using 1:5 with lines notitle,\
         'fort.23' using 1:7 with lines notitle\n
"
echo -e $plotCommand | gnuplot
}
function graph_plotitstar() {
        #plotitStar
plotCommand="
reset\n
set terminal png\n
set output \"plotitStar.png\"\n
set title $modelTitle\n
set logscale y\n
set autoscale\n
plot 'fort.22' using 1:2 with lines ti \"fort.22\",\
         'fort.22' using 1:4 with lines notitle,\
         'fort.22' using 1:6 with lines notitle\n
"
echo -e $plotCommand | gnuplot
}
function graph_plotit() {
        #plotit
plotCommand="
reset\n
set terminal png\n
set output \"plotit.png\"\n
set title $modelTitle\n
set logscale y\n
set autoscale\n
plot 'fort.23' using 1:2 with lines ti \"fort.23\",\
         'fort.23' using 1:4 with lines notitle,\
         'fort.23' using 1:6 with lines notitle\n
"
echo -e $plotCommand | gnuplot
}
####

main "$@"
#end
