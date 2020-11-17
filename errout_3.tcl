proc errout {par {predelta 0} {uponly 0} {doonly 0} } {

    #predelta is an optional argument for the initial delta; par must be there
    #uponly is optional; if non-zero only the upper 90% bound should be sought
    #[low 2.71 delc]
    #doonly is optional; if non-zero only the lower 90% bound should be sought
    #[high 2.71 delc]

file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty

# {uponly 0} {doonly 0}
set outfile errout.txt
set tol 0.01


#Best fit value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max

#Use the externally provided delta, if provided
if {$predelta != 0} {
set delta $predelta
}
set niter 5 


#Make sure we have *well* exceeded 2.71 at top and bottom
set delc_up 3 
set delc_do 3

#CASE 1: LOOKING FOR TWO 2.71 BOUNDS
if {$uponly == 0 && $doonly == 0} {
    while {$delc_up <= 4. || $delc_do <= 4. || $delc_up <= 2.71 || $delc_do <= 2.71 } {
puts "steppar $par delta $delta $niter"
steppar $par delta $delta $niter
#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
    scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do

#Expand if needed
if { $delc_up <=4. || $delc_do <=4. || $delc_up <= 2.71  || $delc_do <= 2.71} {
    set niter [expr $niter+5]
}

#Plot
plot contour

#set out [ open "wfile.pco" "w" ]
#puts $out "wenviron provcon"
#puts $out "plot"
#close $out
exec provcon.sh
setplot command @wfile
plot
setplot delete all

#Adjust the min y for plotting
exec ypco_noans.sh


#while
}

#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Which are the top and bottom regions about 2.71 to zoom into?
exec /bin/sh -c "tbzoom.awk prov2"

#Top region boundaries
set partop1 [ exec more partop1.txt ]
set partop2 [ exec more partop2.txt ]

#Bottom region boundaries
set parbot1 [ exec more parbot1.txt ]
set parbot2 [ exec more parbot2.txt ]

#if
}


#CASE 2: LOOKING FOR LOW 2.71 BOUND (HIGH 90% BOUND "uponly !=0")
#CASE 3: LOOKING FOR HIGH 2.71 BOUND (LOW 90% BOUND "doonly !=0")
#There is only one change of sign, no test here, but more niter
if {$uponly !=0 || $doonly !=0} {
    puts "steppar $par delta $delta 10"
    steppar $par delta $delta 10
}

#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Which are the top OR bottom regions about 2.71 to zoom into?
if {$uponly !=0} {
exec /bin/sh -c "tbzoomBOT.awk prov2"
#Bottom region boundaries
set parbot1 [ exec more parbot1.txt ]
set parbot2 [ exec more parbot2.txt ]
}
if {$doonly !=0} {
exec /bin/sh -c "tbzoomTOP.awk prov2"
#Top region boundaries
set partop1 [ exec more partop1.txt ]
set partop2 [ exec more partop2.txt ]
}






#UPPER REGION -- LOWER ERROR
if {$uponly == 0} {
puts "***************************"
puts "UPPER REGION -- LOWER ERROR"
puts "***************************"
set niter 10
#Make sure we are spanning well 2.71, or expand
#Initial rogue values
set delc_top 3
set delc_bot 2
set ddelstat [expr $tol+1]

while {$ddelstat > $tol } {
puts [format "steppar %i %.4e %.4e %i" $par $partop1 $partop2 $niter]
steppar $par $partop1 $partop2 $niter
#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Do the test
exec /bin/sh -c "sp271.awk prov2"
set in [ exec more sp271.txt ]
    scan $in "%f %f %f %f %f %f" c_top delc_top par_top   c_bot delc_bot par_bot

#Are within $tol of 2.71?
exec /bin/sh -c "zm271.sh prov2"
    set in [ exec more zm271.txt ]
    scan $in "%i %f %f %f %f" idx stat fin_delstat fin_par ddelstat
    if { $ddelstat <= $tol } {
	puts "|2.71-delstat| <= $tol"
	puts "For stat $stat delstat $fin_delstat param=$fin_par"
        set par_lo $fin_par
	set delstat_lo $fin_delstat
	
}
    if { $ddelstat > $tol } {
	puts "|2.71-delstat| >  $tol"
        set niter [expr $niter+5]
	set in [ exec more zmpar.txt ]
	scan $in "%f %f" partop1 partop2
}

#while
}

#if
}


#LOWER REGION -- UPPER ERROR
if {$doonly == 0} {
puts "***************************"
puts "LOWER REGION -- UPPER ERROR"
puts "***************************"
set niter 10
#Make sure we are spanning well 2.71, or expand
#Initial rogue values
set delc_top 3
set delc_bot 2
set ddelstat [expr $tol+1]

while {$ddelstat > $tol } {
puts [format "steppar %i %.4e %.4e %i" $par $parbot1 $parbot2 $niter]
steppar $par $parbot1 $parbot2 $niter
#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Do the test
exec /bin/sh -c "sp271.awk prov2"
set in [ exec more sp271.txt ]
    scan $in "%f %f %f %f %f %f" c_top delc_top par_top   c_bot delc_bot par_bot

#Are within $tol of 2.71?
exec /bin/sh -c "zm271.sh prov2"
    set in [ exec more zm271.txt ]
    scan $in "%i %f %f %f %f" idx stat fin_delstat fin_par ddelstat
    if { $ddelstat <= $tol } {
	puts "|2.71-delstat| <= $tol"
	puts "For stat $stat delstat $fin_delstat param=$fin_par"
        set par_hi $fin_par
	set delstat_hi $fin_delstat
	
}
    if { $ddelstat > $tol } {
	puts "|2.71-delstat| >  $tol"
        set niter [expr $niter+5]
	set in [ exec more zmpar.txt ]
	scan $in "%f %f" parbot1 parbot2
}


#while
}

#if
}


set out [open "errout.txt" "w"]
if {$uponly == 0 && $doonly == 0} {
puts $out [format "%.4e %.4e %.4f %.4e %.4f " $value $par_lo $delstat_lo $par_hi $delstat_hi]
}
if {$uponly !=0} {
puts $out [format "%.4e  0   0    %.4e %.4f " $value  $par_hi $delstat_hi]
}
if {$doonly !=0} {
puts $out [format "%.4e %.4e %.4f    0   0  " $value $par_lo $delstat_lo ]
}

close $out

#Cleanup
file delete prov prov2 tb271.txt partop1.txt partop2.txt parbot1.txt parbot2.txt sp271.txt zm271.txt zmpar.txt

#proc
}
