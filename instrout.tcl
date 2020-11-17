proc instrout {} {

    #5/2018 Need to update for NuSTAR
    
    #PIN or PIN,XIS 

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    set suffix ${name}_${obs}_${xcm}
    
    #Mission
    exec pwd > pwd.txt
    set mission [exec gawk {{if($0~"SUZ") {print 1} else if($0~"STAR") {print 2}}} pwd.txt]

    if {$mission == 1} {
    #PIN data used if more than 1 data groups:
	tclout datagrp
	scan $xspec_tclout "%i" pin
	set outtex [open "r02_$suffix.tex" "w"]
	if {$pin==1} {
	    puts $outtex "& XIS"
	} else {
	    puts $outtex "& XIS, PIN"
	}
    } else {
	set outtex [open "r02_$suffix.tex" "w"]
	puts $outtex "& FPMA/B"
    }
    close $outtex
    exec more r02_$suffix.tex
    
}
