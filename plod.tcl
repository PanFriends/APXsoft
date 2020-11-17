proc plod {pha} {

#Quick plot of data with no model

    setplot delete all
    if {[file exists "stub.txt"]} {
	set title [exec more stub.txt]
	setplot command label title $title
    } else {
	setplot command label title $pha
    }
    
    data $pha
    setplot energy
    cpd /xs
        if {[file exists "stub.txt"]} {
	    set title [exec more stub.txt]
	    set title "$title       $pha"
	    setplot command label title $title
	} else {
	    setplot command label title $pha
	}

    setplot command time off
    setplot command lw 5
    setplot command lw 5 on 1
    xlohi 2 8

    plot ldata


}
