proc qu {par {niter 5}} {

    #Run qs.tcl FROM last best fit value up to...

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

    set hi [exec /bin/sh -c "flosplit $parval u"]
    qs $npar $parval $hi $niter
	
}
