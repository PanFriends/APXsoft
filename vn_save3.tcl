proc vn {args} {

    #vn nh 5

    set npar [lindex $args 0]
    set name [exec more stub.txt]
    if {[file exists /home/pana/.xspec/$npar.var]==1} {
    	set par [exec more /home/pana/.xspec/$npar.var | gawk {{print $2}}]
    	#puts $par
    } else {
    	puts "No $npar.var"
    	return
    }

    if {[llength $args]==2} {
	set val [lindex $args 1]
	newpar $par $val
	setplot add
        setplot command lw 5
        setplot command lw 5 on 2
        setplot command label title $name
        setplot command time off
        #plot
        fadd
        show all
    }
    
    
    if {[llength $args]==1} {
	set par [exec more /home/pana/.xspec/$npar.var | gawk {{print $2}}]
	tclout param $par
        scan $xspec_tclout "%f" val
#	if {$val < 1e-2} {
#	    puts [format "%s %i %.5e" $npar $par $val]
#	} else {
#	    puts [format "%s %i %.5f" $npar $par $val]
#	}

	set ans 888
	set delplot 0
	while {[regexp {[0-9+-]} $ans ]} {
	#Current:
	    tclout param $par
	    scan $xspec_tclout "%f" val
	    if {$val < 1e-2} {
		puts [format "%s %i %.5e" $npar $par $val]
	    } else {
		puts [format "%s %i %.5f" $npar $par $val]
	    }

	    puts "value?"
	    set ans [gets stdin]
        
	    if {[regexp {[0-9+-]} $ans ] != 1} {
		break
	    }

	    #Rest is as in pnew.tcl
	    if {[string first "=" $ans] != -1} {
		#Replace = with 
		regsub {^([=])*} $ans {} ans
		scan $ans "%f" val
		#puts "VAL $val"
		newpar $par = $val
	    } else {
		#Just +: calculate offset
		if {[string equal "+" $ans]} {

#		    if {$val < 1e-5} {
#			set d [expr $val*0.4]
#		    }
#		    if {$val >= 1e-5 && $val < 1e-4} {
#			set d [expr $val*0.2]
#		    }
#		    if {$val >= 1e-4 && $val < 1e-3} {
#			set d [expr $val*]
#		    }
#		    if {$val >= 1e-3 && $val < 1e-2} {
#			set d [expr $val*4]
#		    }

		    set delplot [expr abs(0.1*$val)]
#		    set delplot [expr abs($delplot)]
		} elseif {[string equal "-" $ans]} {
		    #Just -: calculate
		    set delplot [expr -abs(0.1*$val)]
#		    set delplot [expr abs($d)]   
#		    set delplot [expr -abs($delplot)]
		} elseif {[string first "+" $ans]==0} {
		    set delplot [lindex [split $ans \+] 1]
		    scan $delplot "%f" delplot
		} elseif {[string first "-" $ans]==0} {
		    set delplot [lindex [split $ans \-] 1]
		    scan [expr -1*$delplot] "%f" delplot
		}
		
		if {$delplot != 0} {
		    newpar $par [expr $val+$delplot]
		} else {
		    scan $ans "%f" val
		    newpar $par $val
		}
	    
	    }
	    
	    #fadd 7
	    setplot add
	    setplot command lw 5
	    setplot command lw 5 on 2
	    setplot command label title $name
	    setplot command time off
	    #plot
	    fadd
	    show all
	}
    }



}




