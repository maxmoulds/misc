gnuplot <<-__EOF
reset
set terminal png
#set view map
set datafile separator " "
##set dgrid3d
set output "test.png"
splot 'parse1.txt' using 1:2:3

__EOF
