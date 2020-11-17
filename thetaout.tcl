proc thetaout {} {

    #5/2018: Not considering not frozen case
    
    #theta obs output
    #Mostly frozen

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtex "r06_$suffix.tex"
  
    findncomp_first MYtorusS
    set ntheta [expr 1+[exec more /tmp/npar1.txt]]

    tclout param $ntheta
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	exec printf "& \$%.0f^{\\\\rm f}\$\\n" $val > $outtex
	exec more $outtex
    }
	
}

    
