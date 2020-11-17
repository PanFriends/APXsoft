proc gamout {} {

#gamout

#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    #Iterate through components to find trans PhoIndex
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_trans $i
	    puts "trans is comp $n_trans"
	    tclout compinfo $n_trans
	    scan $xspec_tclout "%s %i %i" name parstart npars
	    set par [expr $parstart+1]
	    puts "PhoIndex par is $par"
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
	if { [string first zpowerlw $xspec_tclout] != -1 } {
	    #this is first zpowerlw component number
	    set n_pl $i
	    puts "zpowerlw is comp $n_pl"
	    tclout compinfo $n_pl
	    scan $xspec_tclout "%s %i %i" name parthis npars
	    puts "PhoIndex par is $parthis"
	    lappend parvalues $parthis
	}
    }

	#Choose smallest
	puts "PhoIndex pars found: $parvalues"
	set par [ lindex $parvalues 0]
	puts "Using: PhoIndex par is $par"
    }

#Central value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" G delta minimum lowest highest maximum

#Trial lo/up limits are param +- factor*( 0.1 * param)
#if no errors $lo is <0 
set factor 2
    set lo [expr $G-$factor*(0.1*$G)]
    set hi [expr $G+$factor*(0.1*$G)]
    set i 30

#del G for zooming  -- NOT AS NH
    set del 0.0001

#If not frozen, steppar...
    puts "delta $delta"
    if { $delta > 0 } {



#First estimate
    while {$lo != 0} {
#save last $lo $hi $i for future ref
set out [ open "G_lo_hi_i_$type.txt" "w" ]
puts $out "$lo $hi $i"
close $out

    steppar $par $lo $hi $i
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
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

  	steppar  $par $lo $hi [expr {int(2*$i)}]

    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Glo.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmin [exec more Glo.txt]

    puts "G low $nhmin"


#High end
    exec /bin/sh -c "findhi.sh $par"


    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]
    #puts "steppar $par $lo $hi 10"

    set flag  1 
    while {$flag != 0} {

 	steppar  $par $lo $hi [expr {int(2*$i)}]

    plot contour 
    stepw $par prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Ghi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more Ghi.txt]

    puts "G low $nhmin"
    puts "G high $nhmax"


#Final file with correct units
#Files are NHlo.txt, NHhi.txt
#Vars  are NH, nhmin, nhmax


set out [ open "G_$type.txt" "w" ]
puts $out "$G $nhmin $nhmax"
close $out
} else {

set out [ open "G_$type.txt" "w" ]
puts $out "$G f"
close $out

}





file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt Glo.txt Ghi.txt 

}
