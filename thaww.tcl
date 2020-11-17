proc thaww {npar} {

    #thaww z

    if {[file exists /home/pana/.xspec/$npar.var]==1} {
    	set par [exec more /home/pana/.xspec/$npar.var | gawk {{print $2}}]
    	#puts $par
    } else {
    	puts "No $npar.var"
    	return
    }

    thaw $par
    show all
}
