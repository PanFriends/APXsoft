proc limout {param} {

#limout 2

#Find upper limit with steppar for parameter $param
#Model is loaded


    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type trans
    }
    if { [string first "mytorus" $xspec_tclout] > 0 } {
    set type myun
    }
    puts "type $type"



    tclout modpar
    scan $xspec_tclout "%i" npars
    freeze 1-$npars
    thaw $param
    tclout param $param
    scan $xspec_tclout "%f" value
    tclout pinfo $param
    scan $xspec_tclout "%s" provname
    #Keep only 3 characers as @ is problematic
    set parname [string range $provname 0 2]

puts $parname
    set factor 100
    set hi [expr $value*$factor]
    set i 10
    
    #First estimate [NB: Always low lim of iteration is $value]
    while {$hi != 0} {
#save last for future ref
	set out [ open "sig_LIM_val_hi_i_$type.txt" "w" ]
	puts $out  "$value $hi $i"
	close $out

	steppar $param $value $hi $i
	plot contour

	puts [format "more? ( (%.2e) %.2e %i -- 0 ends)" $value $hi $i ]
	set ans [gets stdin]
	scan $ans "%f %i" hi i
    }

    stepw $param prov
    exec paste prov delstat.txt > prov2
    exec cp prov2 first

#High end
    exec /bin/sh -c "findhilim.sh $param"
    puts "HIGH END"
    set lo [exec cat lonhi2.txt]
    set hi [exec cat hinhi2.txt]

    set del [exec more del.txt]

    set flag  1 
    while {$flag != 0} {

	steppar $param $lo $hi [expr {int(2*$i)}]

    plot contour 
    stepw $param prov
    exec paste prov delstat.txt > prov2
    
    exec /bin/sh -c "zoomlo.sh Ghi.txt"
    set flag  [ exec more flag.txt ]

    set lo [expr {double($lo)+$del}]
    set hi [expr {double($hi)-$del}]

    }

    set nhmax [exec more Ghi.txt]
    puts "LIMIT: $nhmax"


    set out [ open "LIM\_$parname\_$type.txt" "w" ]
puts $out "$value $nhmax"
close $out

file delete  lonhi1.txt hinhi1.txt prov2 prov3 delchis flag.txt found.txt lonhi2.txt hinhi2.txt delstat.txt Glo.txt Ghi.txt del.txt

}
