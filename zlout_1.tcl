proc zlout {par lo hi i} {

#zlout 1e-5 1e-4 20

    tclout modcomp
    set n_comp $xspec_tclout
 
#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type trans
	puts "type $type"
	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+4}]
	puts "z par is $par_z"
	}

#for
	} 

#if sphere
}


    if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
	puts "type $type"
	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first MYtorusS $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+3}]
	puts "z par is $par_z"
	}

#for
	} 

#if mytorus
}



#Central value
tclout param $par_z
scan $xspec_tclout "%f" zl


#del zl for zooming  -- NOT AS NH
    set del 1e-7

#First estimate
    while {$lo != 0} {
    steppar $par_z $lo $hi $i
    plot contour 

    puts [format "more? (%.3e %.3e %i -- 0 ends)" $lo $hi $i]
    set ans [gets stdin]
    scan $ans "%f %f %i" lo hi i
    }

    stepw $par_z prov
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

    steppar $par_z $lo $hi $i
    plot contour 
    stepw $par_z prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Zllo.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmin [exec more Zllo.txt]

    puts "Zl low $nhmin"


#High end
    exec /bin/sh -c "findhi.sh $par"


    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

    steppar $par_z $lo $hi $i
    plot contour 
    stepw $par_z prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Zlhi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more Zlhi.txt]

    puts "Zl high $nhmax"


#Final file with correct units
#Files are NHlo.txt, NHhi.txt
#Vars  are NH, nhmin, nhmax

set out [ open "Zl_$type.txt" "w" ]
puts $out "$zl $nhmin $nhmax"
close $out



file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt Zllo.txt Zlhi.txt 

}
