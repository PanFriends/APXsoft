proc cba { {predelta 0.1} {uponly 0} {doonly 0}} {

    #8/2018: Based on Cpintoxis.tcl
    
    #C FPMB to A errors and output


    

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "Cba_$suffix.txt" "w" ]
    set outtex [ open "r07_$suffix.tex" "w" ]


    #Are there two datagroups?
    tclout datagrp
    scan $xspec_tclout "%d" ngrps

    if { $ngrps == 2} {
	
    #Look for first component in second data group
    tclout compinfo 1 2
    scan $xspec_tclout "%s %d %d" var Cba ncomp
    

    tclout param $Cba
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.2f f" $val]
	puts $outtex [format "& %.2f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$Cba.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$Cba.txt"]==1} {
	set uponly 1
    }

    if { $lim >=0 } {
	errout $Cba $predelta $uponly $doonly
	#Output also relative errors:
	exec gawk {{printf"%.4e %.4e\n", ($1-$2)/$1, ($4-$1)/$1}} errout.txt  > relohi.txt
	exec paste errout.txt relohi.txt > Cba_$suffix.txt
	exec gawk {{printf"& \\aer{%.2f}{+%.2f}{-%.2f}\n", $1, $4-$1, $1-$2}} Cba_$suffix.txt > r07_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.2f}{+%.2f}{-%.2f}\\n\", \$1, \$4-\$1, \$1-\$2}' Cba_$suffix.txt > r07_$suffix.tex" > gawk_Cba.txt
   }




} else {
    exec echo "-" > Cba_$suffix.txt
    exec echo "& \$-\$" > r07_$suffix.tex
}
    exec cat Cba_$suffix.txt r07_$suffix.tex
    
    
}




