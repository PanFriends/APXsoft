proc resfit { {dres 0.3} } {

    #Check if all data/model residual values less than $dres

    #Results are held in dev.txt, ndev.txt, until overwritten

    #Model fit must be loaded.
    
    #First, clean previous if needed:
    chatter 0
    fit

    set dev "dev.txt"
    if {[file exists "ndev.txt"]==1} {
	set ndev [exec more ndev.txt]
	for {set i 1} {$i <= $ndev} {incr i} {
	    set x [exec /bin/bash -c "gawk '{if(NR==i) {print}}' i=$i $dev"]
	    setplot command window 2
	    set nlab [expr $i+100]
#	    puts "LABEL $nlab"
	    #setplot command label $nlab position $x 1e-10
	    setplot command label $nlab color 2 lstyle 3 lwidth 1 line 
	    plot
	    resi $dres
	}
    }
    set deverr "deverr.txt"
    if {[file exists "ndeverr.txt"]==1} {
	set ndeverr [exec more ndeverr.txt]
	for {set i 1} {$i <= $ndeverr} {incr i} {
	    set x [exec /bin/bash -c "gawk '{if(NR==i) {print}}' i=$i $deverr"]
	    setplot command window 2
	    set nlab [expr $i+300]
#	    puts "LABEL $nlab"
	    #setplot command label $nlab position $x 1e-10
	    setplot command label $nlab color 4 lstyle 4 lwidth 1 line 
	    plot
	    resi $dres
	}
    }
    
    file delete residata.qdp residata.pco
    set f residata
    setplot command wdata $f
    plot ratio

    #Find deviant points:
    set up [expr 1.+$dres]
    set lo [expr 1.-$dres]

    #1. Only data:
    exec /bin/bash -c "gawk '{if (NR>3 && (\$3>u || \$3<l)) {print \$1}}' u=$up l=$lo $f.qdp > $dev"
    #2. Data ± error
    exec /bin/bash -c "gawk '{if (NR>3 && (\$3+\$4>u || \$3-\$4<l)) {print \$1}}' u=$up l=$lo $f.qdp > $deverr"


    
    setplotclean

    plot ldata ratio
    set ndev [exec /bin/bash -c "wc -l $dev | gawk '{print \$1}'"]
    if {$ndev > 0} {
	exec echo $ndev > ndev.txt
	puts [format "\033\[1;31m%i residual values deviate by %.0f%%\033\[0;30m" $ndev [expr 100*$dres] ]

	#Now the new:
	for {set i 1} {$i <= $ndev} {incr i} {
	    set x [exec /bin/bash -c "gawk '{if(NR==i) {print}}' i=$i $dev"]
	    setplot command window 2
	    set nlab [expr $i+100]
#	    puts "LABEL $nlab"
	    setplot command label $nlab position $x 1e-10
	    setplot command label $nlab color 2 lstyle 3 lwidth 1 line 90 10000
	    plot
	    resi $dres
	}
    }


    set ndeverr [exec /bin/bash -c "wc -l $deverr | gawk '{print \$1}'"]
    if {$ndeverr > 0} {
	exec echo $ndeverr > ndeverr.txt
	puts [format "\033\[38\;5;21m%i residual±error values deviate by %.0f%%\033\[0;30m" $ndeverr [expr 100*$dres] ]

	#Now the new:
	for {set i 1} {$i <= $ndeverr} {incr i} {
	    set x [exec /bin/bash -c "gawk '{if(NR==i) {print}}' i=$i $deverr"]
	    setplot command window 2
	    set nlab [expr $i+300]
#	    puts "LABEL $nlab"
	    setplot command label $nlab position $x 1e-10
	    setplot command label $nlab color 4 lstyle 4 lwidth 1 line 90 10000
	    plot
	    resi $dres
	}
    }
    
    
    if {$ndev == 0 && $ndeverr == 0} {
	exec echo $ndev > ndev.txt
	exec echo $ndeverr > ndeverr.txt
	chatter 10
	puts [format "%i points deviate by %.0f%%" $ndev [expr 100*$dres] ]
	chatter 0
    }
	    
        
    setplotclean
    plot ldata ratio
    resi $dres
    
    chatter 10
}
