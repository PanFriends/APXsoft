proc fixsphmy {} {

#fixsphmy

#Fix minor issues with the first fit of a sph or myun model,
#bringing to standard, before fitting further.

    #soft/hard limits for line -- -1e-2 ?
    set z1 [expr -5e-3] 
    set z2 [expr -1e-3]
    set z3 [expr +1e-3]
    set z4 [expr +5e-3]

    #soft/hard limits for gsmooth sig
    set sig1 [expr 0]
    set sig2 [expr 0]
    set sig3 [expr 0.1]
    set sig4 [expr 0.1]

    chatter 1
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    tclout modcomp
    set n_comp $xspec_tclout
    #Which is the last param number?
    tclout compinfo $n_comp
    scan $xspec_tclout "%s %i %i" name par npars
	set parmax [expr {$par+$npars-1}]

    #Iterate through components to find trans z and gsmooth Sig
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_trans $i
	    puts "trans is comp $n_trans"
	    scan $xspec_tclout "%s %i %i" name par npars
	    #This is the param number for trans z
	    set n_trans_z [expr {$par+4}]
	    puts "z par is $n_trans_z"
	}
	if { [string first gsmooth $xspec_tclout] != -1 } {
	    #this is gsmooth component number
	    set n_gsmooth $i
	    puts "gsmooth is comp $n_gsmooth"
	    scan $xspec_tclout "%s %i %i" name par npars
	    #This is the param number for gsmooth Sig
	    set n_gsmooth_sig $par
	    puts "gsmooth Sig par is $n_gsmooth_sig"
    }
    
#for
    }

    #Set soft/hard limits
    puts "Set soft/hard limits:"
    puts "newpar $n_trans_z ,,, $z1  $z2  $z3  $z4"
    newpar $n_trans_z ,,, $z1 $z2 $z3 $z4
    puts "newpar $n_gsmooth_sig ,,, $sig1  $sig2  $sig3  $sig4"
    newpar $n_gsmooth_sig ,,, $sig1 $sig2 $sig3 $sig4


    #Statistic cs:
    puts "Statistic cstat"
    statistic cstat

    #Save and load on b0025:
    if {[file exists prov.xcm]==1} {file delete prov.xcm}
    save all prov.xcm
    exec /bin/sh -c "repl prov.xcm b0100 b0025"

    @prov.xcm
    #Energy range:
    puts "Energy range: 2.4-8.0 keV"
    rig 2.4 8.0

    plot

    #Will start with steppar on z. Freeze all else.
    #Make sure trans z is not frozen
    puts "freeze 1-$parmax"
    freeze 1-$parmax
    puts "gsmooth Sig at 100 km/s"
    puts "newpar $n_gsmooth_sig 8.5e-4"
    newpar $n_gsmooth_sig 8.5e-4
    puts "thaw $n_trans_z"
    thaw $n_trans_z
    
#sphere
    }

##########################################################################################

    tclout model
    if { [string first "mytorus" $xspec_tclout] > 0 } {
    set type myun
    puts "type $type"
    tclout modcomp
    set n_comp $xspec_tclout
    #Which is the last param number?
    tclout compinfo $n_comp
    scan $xspec_tclout "%s %i %i" name par npars
	set parmax [expr {$par+$npars-1}]
    #Iterate through components to find 
	#MYtorusS/L/Z z
	#gsmooth Sig
	#zpowerlw z (up to two)
	#Γ for zpowerlw1 and MYtorusS/L decoupled
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first MYtorusZ $xspec_tclout] != -1 } {
	puts "MYtorusZ comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytorusz_z [expr {$par+2}]
        puts "z par is $n_mytorusz_z"
	}
	if { [string first MYtorusS $xspec_tclout] != -1 } {
	puts "MYtorusS comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytoruss_z [expr {$par+3}]
        puts "z par is $n_mytoruss_z"
	set n_mytoruss_G [expr {$par+2}]
        puts "Gamma par is $n_mytoruss_G"
	}
	if { [string first MYTorusL $xspec_tclout] != -1 } {
	puts "MYTorusL comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytorusl_z [expr {$par+3}]
        puts "z par is $n_mytorusl_z"
	set n_mytorusl_G [expr {$par+2}]
        puts "Gamma par is $n_mytorusl_G"
	}
	if { [string first gsmooth $xspec_tclout] != -1 } {
	puts "gsmooth comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_gsmooth_sig $par    
        puts "sig par is $n_gsmooth_sig"
	}
	if { [string first zpowerlw $xspec_tclout] != -1 && [info exists n_zpowerlw1_z] == 0} {
	puts "zpowerlw 1 comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_zpowerlw1_z [expr {$par+1}]    
        puts "z par is $n_zpowerlw1_z"
	set n_zpowerlw1_G $par    
        puts "z par is $n_zpowerlw1_G"
	}
	if { [string first zpowerlw $xspec_tclout] != -1 && [info exists n_zpowerlw1_z] == 1} {
	puts "zpowerlw 2 comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_zpowerlw2_z [expr {$par+1}]    
        puts "z par is $n_zpowerlw2_z"
	}


#for
    }

    #z for MYtorusZ and zpowerlw to 0 and frozen
	if { [info exists n_mytorusz_z] == 1} {
    puts "newpar $n_mytorusz_z 0"
    newpar $n_mytorusz_z 0
    freeze $n_mytorusz_z
	
    puts "newpar $n_mytorusz_z 0"
	}

    newpar $n_zpowerlw1_z 0
    freeze $n_zpowerlw1_z
	if { [info exists n_zpowerlw2_z] == 1} {
	    puts "newpar $n_zpowerlw2_z 0"
    newpar $n_zpowerlw2_z 0
    freeze $n_zpowerlw2_z 
	}
 
    #Statistic cs:
    puts "Statistic cstat"
    statistic cstat

    #Set soft/hard limits for MYtorusS z; make sure untied
    puts "Untied MYtorusS z."
    untie $n_mytoruss_z
    puts "Set soft/hard limits MYtorusS z:"
    puts "newpar $n_mytoruss_z ,,, $z1  $z2  $z3  $z4"
    newpar "$n_mytoruss_z" ,,, $z1  $z2  $z3  $z4

    #Set soft/hard limits for gsmooth sig
    puts "Set soft/hard limits gsmooth sig:"
    puts "newpar $n_gsmooth_sig ,,, $sig1  $sig2  $sig3  $sig4"
    newpar "$n_gsmooth_sig" ,,, $sig1  $sig2  $sig3  $sig4


    #Untie MYtorusS and zpowerlw1 Gammas
    puts "Untied MYtorusS Gamma."
    untie $n_mytoruss_G
    puts "Untied MYtorusL Gamma."
    untie $n_mytorusl_G
    puts "Untied zpowerlw1 Gamma."
    untie $n_zpowerlw1_G

    #Tie MYtorusS and MYTorusL z's and Gammas
    puts "Tie MYtorusS and MYTorusL z"
    puts "newpar $n_mytorusl_z = $n_mytoruss_z"
    newpar $n_mytorusl_z = $n_mytoruss_z
    puts "Tie MYtorusS and MYTorusL Gammas"
    puts "newpar $n_mytorusl_G = $n_mytoruss_G"
    newpar $n_mytorusl_G = $n_mytoruss_G

 
    #Save and load on b0025:
    if {[file exists prov.xcm]==1} {file delete prov.xcm}
    save all prov.xcm
    exec /bin/sh -c "repl prov.xcm b0100 b0025"

    @prov.xcm
    #Energy range:
    puts "Energy range: 2.4-8.0 keV"
    rig 2.4 8.0

    plot

    #Will start with steppar on MYtorusS z. Freeze all else.
    #Make sure trans z is not frozen
    puts "freeze 1-$parmax"
    freeze 1-$parmax
    puts "gsmooth Sig at 100 km/s"
    puts "newpar $n_gsmooth_sig 8.5e-4"
    newpar $n_gsmooth_sig 8.5e-4
    puts "thaw $n_mytoruss_z"
    thaw $n_mytoruss_z


#myun
    }


    chatter 10
    show


#proc
}
