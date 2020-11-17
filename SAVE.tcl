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
	if {[ string equal "MYtorusZ" $name ] == 1 } {
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
	#Check that there is a zphabs there instead, after Galactic phabs:
	#Assume zphabs is there instead, after Galactic phabs:
	if { $ngroup == 1 } {
	    tclout compinfo 2
	}
	if { $ngroup == 2 } {
	    tclout compinfo 3
	}
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if { $ngroup == 1 && [ string first "zphabs" $name ] != -1 } {
	    is nhz 2 2
	    is z 3 2
	    is g 4 3
	    is norm 6 3
	}
	if { $ngroup == 1 && [ string first "zphabs" $name ] == -1 } {
	    #is nhz 2 2
	    puts "No NHZ"
	    is z 3 2
	    is g 2 2
	    is norm 4 2
	}
	    
	if { $ngroup == 2 && [ string first "zphabs" $name ] != -1 } {
	    is nhz 3 3
	    is z 4 3
	    is g 5 4
	    is norm 7 4
	}
	if { $ngroup == 2 && [ string first "zphabs" $name ] == -1 } {
	    #is nhz 2 2
	    puts "No NHZ"
	    is z 4 3
	    is g 3 3
	    is norm 5 3
	}
	    
	
    }

    #MYtorusS + As ###########################################
    set notfound 1
    for {set i $start} {$i<=$n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if {[ string equal "MYtorusS" $name ] == 1 } {
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
	#puts "$name $npar1 $npars"
	set compf 0
	if {[ string equal "MYTorusL" $name ] == 1 } {
	    is sig [expr $npar1-2] [expr $i-1]
	    #Check that there is a const where f should be:
	    set compf [expr $i+1]
	    #If there is a $compf to begin with:
	    if {$compf <= $n_comp } {
		puts $compf
		tclout compinfo $compf
		scan $xspec_tclout "%s %i %i" namef npar1f nparsf
		if {[ string equal "constant" $namef ] == 1 } {
		    is f $npar1f $compf
		} else {
		    puts "No f!"
		    is f 0 0
		}
	    }
	    #else {
	    #	puts "No G!"
	    #}
	    
	    set notfound 0
	}
    }
    #puts $notfound
    
    #if { $notfound == 1 } {
#	puts "MYtorusL not found!"
#    } else {
#	puts "MYtorusL found!"
#    }

}

