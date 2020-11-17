proc findrelx {} {

    #Find main RELXILL components and set aliases for parameters
    #This ASSUMES standard relxill - no variants
    
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

    #MYtorusZ + (main) zpowerlw ##############################
    set notfound 1
    for {set i $start} {$i<=$n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if {[ string first "relxill" $name ] == 0} {
	    #puts "nhz $npar1"
	    is i1 $npar1 $i
	    is i2 [expr $npar1+1]  $i
	    is rbr [expr $npar1+2]  $i
	    is a [expr $npar1+3] $i
	    is i [expr $npar1+4] $i
	    is rin [expr $npar1+5] $i
	    is rout [expr $npar1+6] $i
	    is zrel [expr $npar1+7] $i
	    is grel [expr $npar1+8] $i
	    is logxi [expr $npar1+9] $i
	    is afe [expr $npar1+10] $i
	    is ecut [expr $npar1+11] $i
	    is rfrac [expr $npar1+12] $i
	    is nrel [expr $npar1+13] $i
	    set notfound 0
	}
    }

}

