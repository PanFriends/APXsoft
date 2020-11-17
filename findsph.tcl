proc findsph {} {

    #Find main BN11 sph components and set aliases for parameters

    #For more than one data group there will be extra xnorm
    #component in front!
    tclout datagrp
    scan $xspec_tclout "%i" ngroup
    if { $ngroup == 1 } {
	set start 1
    } 
    if { $ngroup == 2 } {
	set start 2
	is xnorm 1 1
    } 



    tclout modcomp
    set n_comp $xspec_tclout

    #trans + (main) zpowerlw + one partial powerlw ##############
    set notfound 1
    for {set i $start} {$i<=$n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if {[ string equal "trans" $name ]} {
	    #puts "nhz $npar1"
	    is nh $npar1 $i
	    is g [expr $npar1+1] $i
	    is fe [expr $npar1+2] $i
	    is z [expr $npar1+4] $i
	    is norm [expr $npar1+5] $i

	    is f [expr $npar1+6] [expr $i+1]

	    is sig [expr $npar1-2] [expr $i-1]
	    
	    set notfound 0
	}
    }
    if { $notfound == 1 } {
	puts "trans not found!"
    }



}

