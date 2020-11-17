proc lfit { {flag 0} {niter 1000} {del 0.01} } {

    #fit with concurrent plotting every few iterations

    set diter 10

#    set flag 0
#    set flagfile "~/.xspec/fitflag.txt"
#    #fit flag for extra info to display on plot
#    if {[file exists $flagfile]==1} {
#	set flag [exec more $flagfile]
#    }
#    
    #chatter 0
    for {set i 1} {$i <= $niter} {incr i $diter} {
	if { [info exists statcurr]==1 } {
	    set statprev $statcurr
	}
	chatter 0
	fit [expr $i+$diter] $del
	chatter 10
	show all
	if {$flag != 0} {
	    otplot g nhs nhz
	} else {
	    plot
	}
	tclout stat
	scan $xspec_tclout "%f" statcurr
	if { [info exists statprev]==1 && $statcurr == $statprev } {
	    break
	}
    }

    #chatter 10
}
