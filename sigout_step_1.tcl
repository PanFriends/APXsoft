proc sigout_step {par lo hi i type} {

#sigout_step

#type is used for final filename

    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    #Iterate through components to find gsmooth sig@6keV
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first gsmooth $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_gsmooth $i
	    puts "gsmooth is comp $n_gsmooth"
	    tclout compinfo $n_gsmooth
	    scan $xspec_tclout "%s %i %i" name par npars
	    puts "sig@6keV par is $par"
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






#Central value
tclout param $par
scan $xspec_tclout "%f" sig


#del  for zooming
    set del 0.01e-4


#First estimate
    while {$lo != 0} {
    steppar $par $lo $hi $i
    plot contour 

    puts "more? ( $lo $hi $i )"
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
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

    steppar $par $lo $hi $i
    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh siglo.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmin [exec more siglo.txt]

    puts "sig low $nhmin"


#High end
    exec /bin/sh -c "findhi.sh $par"


    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

    steppar $par $lo $hi $i
    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh sighi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more sighi.txt]

    puts "sig low $nhmin"
    puts "sig high $nhmax"



set out [ open "sig_$type.txt" "w" ]
puts $out "$sig $nhmin $nhmax"
close $out

file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt siglo.txt sighi.txt 
}
