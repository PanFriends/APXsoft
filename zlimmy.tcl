proc zlimmy { {z 0.0} } {

    #zlimmy 0.104

    #Set limits for z and other parameters in a mytorus model
    #Adapted from fixsphmy.tcl

    #soft/hard limits for line -- -1e-2 ?
    set z1 [expr {$z-5e-3}] 
    set z2 [expr {$z-1e-3}]
    set z3 [expr {$z+1e-3}]
    set z4 [expr {$z+5e-3}]

    #soft/hard limits for gsmooth sig
    set sig1 [expr 0]
    set sig2 [expr 0]
    set sig3 [expr 0.1]
    set sig4 [expr 0.1]


###############################################################################
    #MYTORUS model

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
	puts " MYtorusZ comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytorusz_z [expr {$par+2}]
        puts "z par is $n_mytorusz_z"
	}
	if { [string first MYtorusS $xspec_tclout] != -1 } {
	puts " MYtorusS comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytoruss_z [expr {$par+3}]
        puts "z par is $n_mytoruss_z"
	set n_mytoruss_G [expr {$par+2}]
        puts "Gamma par is $n_mytoruss_G"
	}
	if { [string first MYTorusL $xspec_tclout] != -1 } {
	puts " MYTorusL comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusZ z
	set n_mytorusl_z [expr {$par+3}]
        puts "z par is $n_mytorusl_z"
	set n_mytorusl_G [expr {$par+2}]
        puts "Gamma par is $n_mytorusl_G"
	}
	if { [string first gsmooth $xspec_tclout] != -1 } {
	puts " gsmooth comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_gsmooth_sig $par    
        puts "sig par is $n_gsmooth_sig"
	}
	if { [string first zpowerlw $xspec_tclout] != -1 && [info exists n_zpowerlw1_z] == 0} {
	puts " zpowerlw 1 comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_zpowerlw1_z [expr {$par+1}]    
        puts "z par is $n_zpowerlw1_z"
	set n_zpowerlw1_G $par    
        puts "Γ par is $n_zpowerlw1_G"
	}
	#Second zpowerlw, checking it doesn't find the first again!
	if { [string first zpowerlw $xspec_tclout] != -1 && [info exists n_zpowerlw1_z] == 1 && $n_zpowerlw1_z != [expr {$par+1}]} {
	puts " zpowerlw 2 comp is $i"
	scan $xspec_tclout "%s %i %i" name par npars
	set n_zpowerlw2_z [expr {$par+1}]    
        puts "z par is $n_zpowerlw2_z"
	}


#for
    }
    
#if
    }
















}
