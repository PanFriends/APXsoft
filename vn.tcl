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

        set ans 888
	#End explicitly with o
	while {[string equal "o" $ans ] != 1} {
	#Current:
            set delplot 0
	    tclout param $par
	    scan $xspec_tclout "%f" val
	    if {$val < 1e-2} {
		puts [format "%s %i %.5e" $npar $par $val]
	    } else {
		puts [format "%s %i %.5f" $npar $par $val]
	    }

	    puts "value?"
	    set ans [gets stdin]
	    
	    if {[string equal "o" $ans ] == 1} {
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

		    #Hold this value of $ans:
		    set hans $ans
		    
		    set delplot [expr abs(0.1*$val)]

		} elseif {[string equal "-" $ans]==1} {
		    set hans $ans
		    
		    #Just -: calculate
		    set delplot [expr -abs(0.1*$val)]
		    
		} elseif {[string first "+" $ans]==0} {
		    set delplot [lindex [split $ans \+] 1]
		    scan $delplot "%f" delplot
		} elseif {[string first "-" $ans]==0} {
		    set delplot [lindex [split $ans \-] 1]
		    scan [expr -1*$delplot] "%f" delplot
		}

		#If return entered, use $hans
		if {[regexp {[0-9o+-]} $ans ] != 1} {
		    if {[string equal "+" $hans] == 1} {
			set delplot [expr abs(0.1*$val)]
		    }
		    if {[string equal "-" $hans] == 1} {
			set delplot [expr -abs(0.1*$val)]
		    }
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




