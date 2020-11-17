proc normout {par lo hi i type} {

#

#type is used for final filename

#Central value
tclout param $par
scan $xspec_tclout "%f" norm


#del norm for zooming  -- NOT AS NH
    set del 1e-5

#First estimate
    while {$lo != 0} {
    steppar $par $lo $hi $i
    plot contour 

    puts "more?"
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
    
    exec /bin/sh -c "zoomlo.sh Normlo.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmin [exec more Normlo.txt]

    puts "Norm low $nhmin"


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
    
    exec /bin/sh -c "zoomlo.sh Normhi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more Normhi.txt]

    puts "Norm high $nhmax"


#Final file with correct units
#Files are NHlo.txt, NHhi.txt
#Vars  are NH, nhmin, nhmax

set out [ open "Norm_$type.txt" "w" ]
puts $out "$norm $nhmin $nhmax"
close $out



file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt Normlo.txt Normhi.txt 

}
