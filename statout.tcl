proc statout {} {


    #output statistics for a fit: text & tex

    #5/2018: add unique name from /tmp/logname.log

tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type sph
}
if { [string first "mytorus" $xspec_tclout] > 0 } {
set type myun
}



tclout stat
#scan $xspec_tclout "%f" cash
#tclout stat test
scan $xspec_tclout "%f" cashchi

tclout dof
scan $xspec_tclout "%i" dof

tclout nullhyp
scan $xspec_tclout "%f" prob

#Naming:
set fin  "/tmp/logname.log"

#Below not needed now--
#First, make sure logname.log has ONLY TWO arguments:
#exec gawk { { {if(NR==1) {if(NF>2) {print $1$2,$3} else {print}}} {if(NR==2) {print}}} } $fin > /tmp/finprov
#exec mv /tmp/finprov $fin

set name [exec gawk {{if(NR==1) {print $1}}} $fin]
set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]

set suffix ${name}_${obs}_${xcm}


set out [ open "stat_$suffix.txt" "w" ]
puts $out "#cashchi    dof     chinu              prob"
set chinu [expr {$cashchi/$dof}]
puts $out "$cashchi $dof $chinu $prob"
close $out

exec /bin/sh -c "more stat_$suffix.txt"

#set out [ open "r03_4_5_$suffix.tex" "w" ]
set out [ open "rstat_$suffix.tex" "w" ]
puts $out [format "& %.1f/%i " $cashchi $dof]
#puts $out [format "& %.3f    " [expr {$cashchi/$dof}] ]
#puts $out [format "& %.3f    " $prob]
close $out

#exec more r03_4_5_$suffix.tex
exec more rstat_$suffix.tex

}
