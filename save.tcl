proc findmyt {} {

    #Find main MYTORUS components and set aliases for parameters

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
	if {[ string equal "MYtorusZ" $name ]} {
	    #puts "nhz $npar1"
	    is nhz $npar1 $i
	    is i [expr $npar1+1]  $i
	    is z [expr $npar1+2]  $i
	    is g [expr $npar1+3]  [expr $i+1]
	    is norm [expr $npar1+5] [expr $i+1]
	    set notfound 0
	}
    }
    if { $notfound == 1 } {
	puts "MYtorusZ not found!"
	#Assume zphabs is there instead, after Galactic phabs:
	if { $ngroup == 1 } {
	    is nhz 2 2
	    is z 3 2
	    is g 4 3
	    is norm 6 3
	}
	if { $ngroup == 2 } {
	    is nhz 3 3
	    is z 4 3
	    is g 5 4
	    is norm 7 4
	}
    }

    #MYtorusS + As ###########################################
    set notfound 1
    for {set i $start} {$i<=$n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if {[ string equal "MYtorusS" $name ]} {
	    #puts "nhz $npar1"
	    is nhs $npar1 $i
	    is as [expr $npar1-1] [expr $i-1]
	    set notfound 0
	}
    }
    if { $notfound == 1 } {
	puts "MYtorusS not found!"
    }

    #MYtorusL for gsmooth and other zpo ######################
    set notfound 1
    for {set i $start} {$i<=$n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if {[ string equal "MYTorusL" $name ]} {
	    is sig [expr $npar1-2] [expr $i-1]
	    is f [expr $npar1+5] [expr $i+1]
	    set notfound 0
	}
    }
    if { $notfound == 1 } {
	puts "MYtorusS not found!"
    }

}

