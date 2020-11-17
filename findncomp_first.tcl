proc findncomp_first {cname} {

    #5/2018: first parameter number into npar1.txt;
    #component number into thecomp.txt
    
    #5/2018: find first instance of $cname and into /tmp/npar1.txt
    #5/2018: include case that $cname NOT found
    
    tclout modcomp
    set n_comp $xspec_tclout

    exec echo this > /tmp/npartest.txt
    file delete {*}[glob /tmp/npar*txt]
    set notfound 1
    #puts "$notfound"
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if { [string equal $cname $name] == 1 } {

	    if {$i < 10} {
		echo $npar1 > /tmp/npar0$i.txt
		echo $i > /tmp/thecomp0$i.txt
	    } else {
		echo $npar1 > /tmp/npar$i.txt
		echo $i > /tmp/thecomp$i.txt
	    }		
	    set notfound 0
	    #puts "$notfound"
	}
	

	
    }
	if { $notfound == 1} {
	    #puts "$notfound"
	    echo 0 > /tmp/npar_notfound.txt
	    echo 0 > /tmp/thecomp.txt
	} else {
	    #At least one $cname found.
	    #Make /tmp/list* in order they are found;
	    #then choose the entry in the file on the first line of the list:
	    exec /bin/sh -c "ls /tmp/npar* > /tmp/listpar"
	    set toread [exec gawk {{if(NR==1) {print}}} /tmp/listpar]
	    #This is the result:
	    #puts "$toread"
	    exec cp $toread /tmp/prov
	    exec mv /tmp/prov /tmp/npar1.txt

	    #Same for component
	    exec /bin/sh -c "ls /tmp/thecomp* > /tmp/listcomp"
	    set toread [exec gawk {{if(NR==1) {print}}} /tmp/listcomp]
	    #This is the result:
	    #puts "$toread"
	    exec cp $toread /tmp/prov
	    exec mv /tmp/prov /tmp/thecomp.txt
	    
	    
	}


    


}
