proc exfit { {flag 0} {niter 1e10} {del 5e-7}  } {

    #fit with concurrent plotting every few iterations
    #Extreme fit in the convergence demands to ensure full convergence.

    #Display key parameter values if flag=1; default 0
    
    set diter 1000
    
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
