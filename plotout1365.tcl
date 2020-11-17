proc plotout1365 {} {

#run in /home/pana/Applications/ADAP2017/PT/NGC1365

@broad.xcm

set lw 4

setplot energy
cpd /xs
setplot command re y 1e-3
setplot add
setplot command log x
setplot delete all
setplot command Csize 1.4
setplot command font roman
setplot command lab t 
setplot command re y 0 5
setplot command re x 2 10
setplot command lw $lw
setplot command lw $lw on 1
setplot command time off
plot ratio
setplot command hardcopy /cps

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

mv pgplot.ps broad1365.eps
exec okular broad1365.eps > /dev/null 2>&1 &


}
