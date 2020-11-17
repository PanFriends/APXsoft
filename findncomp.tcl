proc findncomp {cname} {

    #5/2018: include case that $cname NOT found
    
    #find number of given component "cname";
    #first parameter number into npar1.txt
    #component number into thecomp.txt



    tclout modcomp
    set n_comp $xspec_tclout
    #file delete {*}[glob /tmp/npar*txt]
    
    
    set notfound 1
    echo 0 > /tmp/npar1.txt
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	scan $xspec_tclout "%s %i %i" name npar1 npars
	if { [string equal $cname $name] == 1 } {
	    

	    #puts "$npar1 $npars"
	    #echo $cname > cname.txt
	    echo $npar1 > /tmp/npar1.txt
	    echo $i > /tmp/thecomp.txt
	    set notfound 0
	    
	    #echo $npars
	} 

	
}

    if {$notfound == 1} {
	echo 0 > /tmp/npar1.txt
	echo 0 > /tmp/thecomp.txt
	
    }
    

    


}
