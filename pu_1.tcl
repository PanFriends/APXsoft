proc pu {co pa {niter 5}} {

#Run qu.tcl finding param number

#co= mys, myz, tr
#pa= z,

    tclout modcomp
    set n_comp $xspec_tclout
    #Which is the last param number?
    tclout compinfo $n_comp

#co
    if { [string first tr $co] != -1} {
	set testco trans
	puts $testco

	#z
    if { [string first z $pa] != -1} {
	set testpa z
	puts $testpa 
    }

    }




    if { [string first mys $co] != -1} {
	set testco MYtorusS
	puts $testco

	#z
    if { [string first z $pa] != -1} {
	set testpa z
	puts $testpa 
    }



    }


#pa



    #Iterate through components to find $testco
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
    if { [string first $testco $xspec_tclout] != -1 } {
    puts "$testco is comp $i"
    scan $xspec_tclout "%s %i %i" name par1 npars
	#Find par $testpa

puts "$name $par1 $npars"

        for {set j $par1} {$j <= [expr $par1+$npars-1]} {incr j} {

	tclout pinfo $j
	scan $xspec_tclout "%s" parname
	    #puts [string first $testpa $parname]
	    if { [string first $testpa $parname] != -1 } {
	puts "$testpa is par $j"
        tclout param $j
	scan $xspec_tclout "%f" parvalue
	puts $parvalue

	    }



#for (inner)
	}

#if
    }
#for (outer)
    } 

}
