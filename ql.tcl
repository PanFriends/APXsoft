proc ql {par {niter 5}} {

    #Run qs.tcl FROM lower val TO last best fit 

    #par can be a number of a standard findmyt name
    
    if {[regexp {[a-z]} $par ] == 1} {
	set parval [getparval $par]
	scan [getparmod $par] "%d %d" npar nmod
	puts "$npar $parval"
	
    } else {
	tclout param $par
	scan $xspec_tclout "%f" parval
	set npar $par
    }

    set lo [exec /bin/sh -c "flosplit $parval d"]
    #Provision for not going below Γ=1.4 for mytorus
    #If "g" entered, easiest - else check more
    if {[regexp {[a-z]} $par ] == 1} {
	scan [ exec more /home/pana/.xspec/$par.var ] "%s" parcode
	if {[string equal "g" $parcode] == 1 } {
	    set lo 1.4
	}
    } else { 
	tclout model
	if { [string first "mytorus" $xspec_tclout] != -1 } {
	    tclout pinfo $par
	    if {[string first PhoInd $xspec_tclout] != -1 } {
		set lo 1.4
	    }
	}
    }
	
    
    qs $npar $parval $lo $niter

}
