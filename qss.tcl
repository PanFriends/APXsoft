proc qss {par {predelta 0}} {

#A more sophisticated steppar implementation to find a value
#corresponding to a minimum

#predelta is an optional argument for the initial delta

#The first try best fit model is loaded.
#Start with that central value for the parameter, and its delta.
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max

file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty
#Use the externally provided delta, if provided
if {$predelta != 0} {
set delta $predelta
}
set niter 5 

#The idea is to exceed 2.71 at top and bottom
set delc_up 2 
set delc_do 2

#predelta=0 ends the loop if the other conditions met
set predelta 2
while {$delc_up <= 4. || $delc_do <= 4. || $predelta !=0} {
file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty

#Start with delta-based steppar, unless other requested later:
if {$predelta != 1} {
puts "steppar $par delta $delta $niter"
steppar $par delta $delta $niter
set savedelta $delta
set saveniter $niter
}
#If requested, just zoom increasing iterations
if {$predelta == 1} {
puts "steppar $par $lo  $hi"
steppar $par $lo $hi $niter
set savedelta $delta
set saveniter $niter
}



#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2





#FIRST: The "central" value
#If the min in the statistic's values in stepstat.txt
#is not the first or last line, then it might be correct.
exec /bin/sh -c "zoomcen.sh prov2"

#Get the value at the minimum
set value [exec more zoomcenval.txt]

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
exec ypco.sh


#Message from zoomcen.sh
set message [exec more message]
puts "$message"
puts "newpar $par $value"
puts [format "more? (%.4e %i -- 0 nothing -- 1 zoom)" $delta $niter ]
set ans [gets stdin]
set preniter -2
scan $ans "%f %i" predelta preniter 

if {$predelta == 0} {set delta $savedelta}
if {$predelta != 0} {
set delta $predelta
set niter $preniter
}
if {$predelta == 1} {
puts "low - high - n_iter?" 
set ans [gets stdin]
scan $ans "%f %f %i" lo hi niter
#set niter [expr $niter+5]

}

#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
    scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do

#Expand if needed
if { $delc_up <=4. || $delc_do <=4. && $preniter != -2 } {
    set niter [expr $niter+5]
}

#while
}

#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2




file delete zoomcenval.txt message prov2 stepstat.txt delstat.txt prov pre2 


}
