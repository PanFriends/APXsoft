proc fpar {co pa} {

#Find par number from co-par name

#co= mys, myz, tr, gs, zpo     --- zpo will only work if only one zpowerlw!!
#pa= z, fe, gam, nh, no, sig, i

    tclout modcomp
    set n_comp $xspec_tclout
    #Which is the last param number?
    tclout compinfo $n_comp

#In gen:
set testpa $pa

#co
#trans
    if { [string first tr $co] != -1} {
	set testco trans
	#puts $testco

	#pars
    if { [string first fe $pa] != -1} {
	set testpa Fe
	#puts $testpa 
    }

    if { [string first gam $pa] != -1} {
	set testpa Pho
	#puts $testpa 
    }

    if { [string first no $pa] != -1} {
	set testpa norm
	#puts $testpa 
    }

    if { [string first nh $pa] != -1} {
	set testpa nH
	#puts $testpa 
    }




    }


#gsmooth
    if { [string first gs $co] != -1} {
	set testco gsmooth
	#puts $testco

	#Sig@6keV
    if { [string first sig $pa] != -1} {
	set testpa Sig
	#puts $testpa 
    }
    }





#MYtorusS
    if { [string first mys $co] != -1} {
	set testco MYtorusS
	#puts $testco

	#z
    if { [string first z $pa] != -1} {
	set testpa z
	#puts $testpa 
    }

	#NH
    if { [string first nh $pa] != -1} {
	set testpa NH
	#puts $testpa 
    }

	#PhoIndx
    if { [string first gam $pa] != -1} {
	set testpa PhoIndx
	#puts $testpa 
    }


	#IncAng
    if { [string first i $pa] != -1} {
	set testpa IncAng
	#puts $testpa 
    }

    }

#MYtorusZ
    if { [string first myz $co] != -1} {
	set testco MYtorusZ
	#puts $testco

	#z
    if { [string first z $pa] != -1} {
	set testpa z
	#puts $testpa 
    }

	#NH
    if { [string first nh $pa] != -1} {
	set testpa NH
	#puts $testpa 
    }

	#IncAng
    if { [string first i $pa] != -1} {
	set testpa IncAng
	#puts $testpa 
    }

    }


#zpowerlw -- if only one!
    if { [string first zpo $co] != -1} {
	set testco zpowerlw
	#puts $testco

	#z
    if { [string first z $pa] != -1} {
	set testpa Redshift
	#puts $testpa 
    }

	#PhoIndex
    if { [string first gam $pa] != -1} {
	set testpa PhoIndex
	#puts $testpa 
    }

	#IncAng
    if { [string first no $pa] != -1} {
	set testpa norm
	#puts $testpa 
    }

    }




#pa



    #Iterate through components to find $testco
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
    if { [string first $testco $xspec_tclout] != -1 } {
    #puts "$testco is comp $i"
    scan $xspec_tclout "%s %i %i" name par1 npars
	#Find par $testpa

#puts "$name $par1 $npars"

        for {set j $par1} {$j <= [expr $par1+$npars-1]} {incr j} {

	tclout pinfo $j
	scan $xspec_tclout "%s" parname
	    #puts [string first $testpa $parname]
	    if { [string first $testpa $parname] != -1 } {
	#puts "$testpa is par $j"
        tclout param $j
	scan $xspec_tclout "%f" parvalue
	#puts $parvalue

#output for other routines to grab
	set out [open "npar.txt" "w"]
	puts $out [format "%i" $j]
	close $out
	    }



#for (inner)
	}

#if
    }
#for (outer)
    } 

}
