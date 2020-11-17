proc nhout {} {

#nhout 


#type is used for final filename

    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    #Iterate through components to find trans NH
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_trans $i
	    puts "trans is comp $n_trans"
	    tclout compinfo $n_trans
	    scan $xspec_tclout "%s %i %i" name par npars
	    puts "NH par is $par"
	}
    }
 
    }

    
    if { [string first "mytorus" $xspec_tclout] > 0 } {
	#Is this s  or   z   NH?
    puts "s or z?"
    set ans [gets stdin]
    scan $ans "%s" suffixin
    set type $suffixin\_myun
    set suffix [string toupper $suffixin]
    set mycomp "MYtorus$suffix"

    puts $type
    puts $mycomp

#Iterate through components to find MYtorus$suffix
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first $mycomp $xspec_tclout] != -1 } {
	    #this is gaussian component number
	    set n_my $i
	    puts "$mycomp is comp $n_my"
	    tclout compinfo $n_my
	    scan $xspec_tclout "%s %i %i" name par npars
	    puts "NH par is $par"
	}
    }
}




#Central value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" NH delta minimum lowest highest maximum



#Trial lo/up limits are param +- factor*( 0.1 * param)
#if no errors $lo is <0 
set factor 3
    set lo [expr $NH-$factor*(0.1*$NH)]
    set hi [expr $NH+$factor*(0.1*$NH)]
    set i 30

    puts [format "lo %.2e  val %.2e  hi %.2e" $lo $NH $hi]

if {$lo >= 0} {

#del nh for zooming
    set del 0.01
    tclout model
    if { [string first "my" $xspec_tclout] == -1 } {
    set del 0.0001
    }


#If not frozen, steppar...
    puts "delta $delta"
    if { $delta > 0 } {



#First estimate
    while {$lo != 0} {

#save last $lo $hi $i for future ref
set out [ open "NH_lo_hi_i_$type.txt" "w" ]
puts $out "$lo $hi $i"
close $out

    steppar  $par $lo $hi $i
    plot contour 

puts [format "more? ( %.2e %.2e %i -- 0 ends)" $lo $hi $i ]
    set ans [gets stdin]
    scan $ans "%f %f %i" lo hi i
}

    stepw $par prov
    exec paste prov delstat.txt > prov2
    exec cp prov2 first

    exec /bin/sh -c "findlo.sh $par"

#Low end
    puts "LOW END"
    set lo [exec cat lonhi1.txt]
    set hi [exec cat hinhi1.txt]
    #puts "steppar  $par $lo $hi 10"

    set flag  1 

#Number of iterations and high limit will be changed dynamically
#as set in niter.txt initially and by zoomlo.sh
set out [ open "niter.txt" "w" ]
set numiter [expr {int(2.*$i)}]
puts $out "$numiter"
close $out
set out [ open "lo.txt" "w" ]
puts $out "$lo"
close $out
set out [ open "hi.txt" "w" ]
puts $out "$hi"
close $out


    while {$flag != 0} {
	set niter [ exec more niter.txt ]
	set lo   [ exec more lo.txt ]
	set hi   [ exec more hi.txt ]

#Change delta, not niter
#
#	set curstep [expr ($hi-$lo)/$niter ]
#	set step [expr {$curstep-$curstep/10.0}]
#
#	puts "delta $step $niter"
#	steppar $par delta $step $niter
	steppar  $par $lo $hi $niter
#	puts "$lo $hi $niter"

    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh NHlo.txt $niter"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

}

    set nhmin [exec more NHlo.txt]

    puts "NH low $nhmin"


#High end
    exec /bin/sh -c "findhi.sh $par"


    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]
    #puts "steppar  $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

	steppar  $par $lo $hi [expr {int(2*$i)}]
    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh NHhi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

}

    set nhmax [exec more NHhi.txt]

    puts "NH low $nhmin"
    puts "NH high $nhmax"



#Final file with correct units
#Files are NHlo.txt, NHhi.txt
#Vars  are NH, nhmin, nhmax

#if sph
set out [ open "NH_$type.txt" "w" ]
if {$lo >= 0} { 
puts $out "$NH $nhmin $nhmax"
} else {
puts $out "$NH f"
}

close $out


#check and produce for MY
#units of 10^22 cm^-2
tclout model
if { [string first "sphere" $xspec_tclout] == -1 } {
#mytorus

#keep first arg
    if {$lo >= 0} {
scan $nhmin "%f %f" nmin dchimin
scan $nhmax "%f %f" nmax dchimax
    

    set uNH [expr {double($NH)*100.}]
    set uNH_lo [expr {double($nmin)*100.}]
    set uNH_hi [expr {double($nmax)*100.}]

set NH $uNH
set nhmin $uNH_lo
set nhmax $uNH_hi

set out [ open "NH_$type.txt" "w" ]
puts $out "$uNH $nhmin $dchimin $nhmax $dchimax"
close $out
} else {
    set uNH [expr {double($NH)*100.}]
set NH $uNH

set out [ open "NH_$type.txt" "w" ]
puts $out "$uNH f"
close $out
}

}


#if not frozen
} else {
#Frozen, so produce other files

#Assume sph and write
set out [ open "NH_$type.txt" "w" ]
puts $out "$NH f"
close $out


#If mytorus, rewrite
tclout model
if { [string first "sphere" $xspec_tclout] == -1 } {
set uNH [expr {double($NH)*100.}]
set NH $uNH
set out [ open "NH_$type.txt" "w" ]
puts $out "$uNH f"
close $out
}

}

file delete lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt NHlo.txt NHhi.txt niter.txt hi.txt

}
}
