proc fscout {} {

#Search for LAST   "constant"    component

#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    #Iterate through components to find trans *last*   constant
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	lappend parvalues
	if { [string first constant $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_const $i
	    puts "constant is comp $n_const"
	    tclout compinfo $n_const
	    scan $xspec_tclout "%s %i %i" name parthis npars
	    puts "constant par is $parthis"
	    lappend parvalues $parthis
	}
    }
    }


    if { [string first "mytorus" $xspec_tclout] > 0 } {
    set type myun
    puts "type $type"
    #Iterate through components to find zpowerlw PhoIndex
    #Always the LOWEST param is this zpowerlw
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	lappend parvalues
	if { [string first constant $xspec_tclout] != -1 } {
	    #this is first zpowerlw component number
	    set n_const $i
	    puts "constant is comp $n_const"
	    tclout compinfo $n_const
	    scan $xspec_tclout "%s %i %i" name parthis npars
	    puts "constant par is $parthis"
	    lappend parvalues $parthis
	}
    }
    }
	#Choose largest
	puts "constant pars found: $parvalues"
	set lastindex [expr [llength $parvalues] - 1] 
	puts "last index $lastindex"
	set par [ lindex $parvalues $lastindex ]
	puts "Using: constant par is $par"




#Central value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" fs delta minimum lowest highest maximum

#Trial lo/up limits are param +- factor*( 0.1 * param)
#if no errors $lo is <0 
set factor 0.3
    set lo [expr $fs-$factor*(0.1*$fs)]
    set hi [expr $fs+$factor*(0.1*$fs)]
    set i 10

#del fs for zooming  -- NOT AS NH
    set del 1e-6

#If not frozen, steppar...
    puts "delta $delta"
    if { $delta > 0 } {

#First estimate
    while {$lo != 0} {
#save last $lo $hi $i for future ref
set out [ open "Fs_lo_hi_i_$type.txt" "w" ]
puts $out "$lo $hi $i"
close $out

    steppar $par $lo $hi $i
    plot contour 

    puts [format "more? ( %.3f %.3f %i -- 0 ends)" $lo $hi $i ]
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

 	steppar  $par $lo $hi [expr {int(2.*$i)}]

    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Fslo.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmin [exec more Fslo.txt]

    puts "Fs low $nhmin"


#High end
    exec /bin/sh -c "findhi.sh $par"


    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

 	steppar  $par $lo $hi [expr {int(2.*$i)}]

    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Fshi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more Fshi.txt]

    puts "Fs low $nhmin"
    puts "Fs high $nhmax"


#Final file with correct units
#Files are NHlo.txt, NHhi.txt
#Vars  are NH, nhmin, nhmax

set out [ open "Fs_$type.txt" "w" ]
puts $out "$fs $nhmin $nhmax"
close $out
} else {
set out [ open "Fs_$type.txt" "w" ]
puts $out "$fs f"
close $out
}



file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt Fslo.txt Fshi.txt 

}
