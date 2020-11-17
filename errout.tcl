proc errout {par {deloff 0.1} {uponly 0} {doonly 0} {mynh 0}} {


parallel steppar 4

#par can be a number of a standard findmyt name
if {[regexp {[a-z]} $par ] == 1} {
    set parval [getparval $par]
    scan [getparmod $par] "%d %d" npar nmod
    puts "$npar $parval"
    set par $npar
}
    

#slope threshold for interpolation
if {[file exists "zslope.txt"]==1} {
set thresh 8
} else {
set thresh 200
}

##########################################################################
#(almost) Identical to errfine.tcl
##########################################################################

######### FULLY WORKING VERSION ##########################################
##########################################################################
#This is a brute force approach for errors with steppar:
#Assume one large number of spacings, and iterate checking at each step
#if the 90% level has been reached. Would not expect it to work in
#all cases.

#In fact, starting with a minimal offset, dynamically incrementing it
#as needed, this does seem to work pretty well in most cases!

#This version uses string provconERR and wfileERR so that exploratory scripts (qu.tcl, qs.tcl etc) can run at the same time in directory


file delete provconERR.qdp provconERR.pco wfileERR.pco ~/.xspec/xspec.hty par2706u.txt par2706l.txt par2706.txt

set deloffori $deloff

# {uponly 0} {doonly 0}
set outfile errout.txt
#set tol 0.005
#set tol 0.05
set tol 0.01
#set tol 0.001
set lowtol 0.05

#Best fit value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max

#STEPPING FROM VALUE and UP
if {$uponly == 0} {

#time it
set start [clock seconds]

puts "*****************************************"
puts "STEPPING FROM VALUE and UP -- UPPER ERROR"
puts "*****************************************"
set delc_do 3.0 

#set offset 0.1
set offset $deloff

#counting iterations
set iter 1

#niter will be incremented up to maxiter
set niter 3
set maxiter 1000


while { [file exists par2706u.txt ] == 0 } {
set hi [exec /bin/sh -c "flosplitD $value u $offset"]
puts "****"
puts "$iter"
puts "****"

puts "steppar $par $value $hi $niter"
steppar $par $value $hi $niter

#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Plot
plot contour

#set out [ open "wfileERR.pco" "w" ]
#puts $out "wenviron provconERR"
#puts $out "plot"
#close $out
exec provconERR.sh
setplot command @wfileERR
plot
setplot delete all

#Adjust the min y for plotting
exec ypco_noansERR.sh

#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do

#It's just missing the fine tolerance:
set tonow [clock seconds]
set duration [expr $tonow-$start]
if { $niter > 70 || $duration > 240 } {
set tol $lowtol
}

if { $iter > 1 && $par_do == $par_do_prev } {
#get unstuck!
#puts "par_do $par_do par_do_prev $par_do_prev"
#puts "deloff $deloff"
set deloff [expr {$deloff*2.}]


#puts "deloff $deloff"

}
set par_do_prev $par_do

if { $delc_do < [expr 2.706-$tol] } {
set offset [expr $offset+$deloff]
#puts "offset $offset"
}

if { $delc_do >= [expr 2.706-$tol] } {
exec /bin/sh -c "tbz.awk prov2 $tol"
set niter [expr $niter+10]
}

if {[file exists par2706.txt ] == 1} {
exec cvlc /usr/share/sounds/KDE-Sys-List-End.ogg 2>&1 &
exec mv par2706.txt par2706u.txt
set in [ exec more par2706u.txt ]
scan $in "%f %f %f" stat271u dstat271u par271u
set par_hi $par271u
set delstat_hi $dstat271u
puts "iter $iter"
puts "$stat271u $dstat271u $par271u"
#puts "continue?"
#set ans [gets stdin]
#exec shoterr u.png
} 

set niter [expr $niter+1]
set iter [expr $iter+1]

#If we're still below 2.701, time to accelerate:
if {$iter >= 4 && $iter < 10} {
set deloff [expr {$deloff*4.}]
}
if {$iter > 10} {
set deloff [expr {$deloff*2.}]
}

if {$iter >= 7 || $niter >= 15} {
#time to interpolate
puts "INTERPOLATE"
scan [exec tbinterp.awk prov2] "%f %f %f %f %f %f %f" xl xh yl yh deldelC Cl Ch
set aslope 0
if {$deldelC > 0} {
#Normalize y for slope
scan [exec getmant $yh] "%i" power
set nyh [expr $yh/1e$power]
set nyl [expr $yl/1e$power]
set slope [expr ($Ch-$Cl)/($nyh-$nyl)]
set aslope $slope
if {$slope <0} {set aslope [expr -$slope]}

puts "slope $slope"
puts "deldel C $deldelC"
}

if { ($aslope > $thresh && $deldelC > 0) || ($niter > 20 && $deldelC > 0)} {
puts "-YES"
set par_hi [scan [linterp $xl $xh $yl $yh 2.706 ] "%e"]
set delstat_hi 2.706
exec echo interplow > par2706u.txt
exec cvlc /usr/share/sounds/KDE-Sys-List-End.ogg 2>&1 &
} else {
puts "--no--"
}
}

file delete provconERR.qdp provstat.txt provconERR.pco wfileERR.pco ~/.xspec/xspec.hty
#while
}


#if uponly 0
}


#Resetting to original
set deloff $deloffori


#STEPPING from BELOW TO VALUE -- LOWER ERROR
if {$doonly == 0} {

#time it
set start [clock seconds]
puts "*******************************************"
puts "STEPPING from BELOW TO VALUE -- LOWER ERROR"
puts "*******************************************"
set iter 1
set niter 3
set maxiter 1000
#set offset 0.1
set offset $deloff

while { [file exists par2706l.txt ] == 0 } {
set lo [exec /bin/sh -c "flosplitD $value d $offset"]
puts "****"
puts "$iter"
puts "****"


puts "steppar $par $lo $value $niter"
steppar $par $lo $value $niter
#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Plot
plot contour

#set out [ open "wfileERR.pco" "w" ]
#puts $out "wenviron provconERR"
#puts $out "plot"
#close $out
exec provconERR.sh
setplot command @wfileERR
plot
setplot delete all

#Adjust the min y for plotting
exec ypco_noansERR.sh

#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do

#It's just missing the fine tolerance:
set tonow [clock seconds]
set duration [expr $tonow-$start]
if { $niter > 70 || $duration > 240 } {
set tol $lowtol
}

if { $iter > 1 && $par_up == $par_up_prev } {
#get unstuck!
    set deloff [expr $deloff*2]
}
set par_up_prev $par_up

if { $delc_up < [expr 2.706-$tol] } {
set offset [expr $offset+$deloff]
}

if { $delc_up >= [expr 2.706-$tol] } {

exec /bin/sh -c "tbz.awk prov2 $tol"
set niter [expr $niter+10]
}

if {[file exists par2706.txt ] == 1} {
exec cvlc /usr/share/sounds/KDE-Sys-List-End.ogg 2>&1 &
exec mv par2706.txt par2706l.txt
set in [ exec more par2706l.txt ]
scan $in "%f %f %f" stat271l dstat271l par271l
set par_lo $par271l
set delstat_lo $dstat271l
puts "iter $iter"
puts "$stat271l $dstat271l $par271l"
#exec shoterr l.png
} 

#If we're still below 2.701, time to accelerate:
if {$iter >= 4 && $iter < 10} {
set deloff [expr {$deloff*4.}]
}
if {$iter > 10} {
set deloff [expr {$deloff*2.}]
}

if {$iter >= 7 || $niter >= 20} {
#time to interpolate
puts "INTERPOLATE"
scan [exec tbinterp.awk prov2] "%f %f %f %f %f %f %f" xl xh yl yh deldelC Cl Ch
set aslope 0
if {$deldelC > 0} {
#Normalize y for slope
scan [exec getmant $yh] "%i" power
set nyh [expr $yh/1e$power]
set nyl [expr $yl/1e$power]
set slope [expr ($Ch-$Cl)/($nyh-$nyl)]
set aslope $slope
if {$slope <0} {set aslope [expr -$slope]}

puts "slope $slope"
puts "deldel C $deldelC"
}

if { ($aslope > $thresh && $deldelC > 0) || ($niter > 20 && $deldelC > 0) } {
puts "-YES"
set par_lo [scan [linterp $xl $xh $yl $yh 2.706 ] "%e"]
set delstat_lo 2.706
exec echo interplow > par2706l.txt
exec cvlc /usr/share/sounds/KDE-Sys-List-End.ogg 2>&1 &
} else {
puts "--no"
}
}

set niter [expr $niter+1]
set iter [expr $iter+1]
file delete provconERR.qdp provstat.txt provconERR.pco wfileERR.pco ~/.xspec/xspec.hty
#while
}


#if doonly 0
}

#WRITE OUT
set out [open "errout.txt" "w"]
if {$uponly == 0 && $doonly == 0} {
puts $out [format "%.4e %.4e %.4f %.4e %.4f " $value $par_lo $delstat_lo $par_hi $delstat_hi]
}
if {$doonly !=0} {
puts $out [format "%.4e  0   0    %.4e %.4f " $value  $par_hi $delstat_hi]
}
if {$uponly !=0} {
puts $out [format "%.4e %.4e %.4f    0   0  " $value $par_lo $delstat_lo ]
}

close $out

#Cleanup
#file delete prov prov2 tb271.txt partop1.txt partop2.txt parbot1.txt parbot2.txt sp271.txt zm271.txt zmpar.txt par2706u.txt par2706l.txt stepstat.txt delstat.txt 





#proc
}
