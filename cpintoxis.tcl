proc cpintoxis { {predelta 0.1} {uponly 0} {doonly 0}} {

    #8/2018: No relative errors (unlike asout)
    
    #Cpintoxis errors and output
    #Based on asout.tcl

    

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "Cpx_$suffix.txt" "w" ]
#    set outtex [ open "r07_$suffix.tex" "w" ]
    set outtex [ open "rcpx_$suffix.tex" "w" ]


    #Are there two datagroups?
    tclout datagrp
    scan $xspec_tclout "%d" ngrps

    if { $ngrps == 2} {
	
    #Look for first component in second data group
    tclout compinfo 1 2
    scan $xspec_tclout "%s %d %d" var Cpx ncomp
    

    tclout param $Cpx
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.2f f" $val]
	puts $outtex [format "& %.2f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$Cpx.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$Cpx.txt"]==1} {
	set uponly 1
    }

    if { $lim >=0 } {
	errout $Cpx $predelta $uponly $doonly
	#Output also relative errors:
	exec gawk {{printf"%.4e %.4e\n", ($1-$2)/$1, ($4-$1)/$1}} errout.txt  > relohi.txt
	exec paste errout.txt relohi.txt > Cpx_$suffix.txt
#	exec gawk {{printf"& \\aer{%.2f}{+%.2f}{-%.2f}\n", $1, $4-$1, $1-$2}} Cpx_$suffix.txt > r07_$suffix.tex
	#	exec echo "gawk '{printf\"& \\aer{%.2f}{+%.2f}{-%.2f}\\n\", \$1, \$4-\$1, \$1-\$2}' Cpx_$suffix.txt > r07_$suffix.tex" > gawk_Cpx.txt
	exec gawk {{printf"& \\aer{%.2f}{+%.2f}{-%.2f}\n", $1, $4-$1, $1-$2}} Cpx_$suffix.txt > rcpx_$suffix.tex
       	exec echo "gawk '{printf\"& \\aer{%.2f}{+%.2f}{-%.2f}\\n\", \$1, \$4-\$1, \$1-\$2}' Cpx_$suffix.txt > rcpx_$suffix.tex" > gawk_Cpx.txt



	
   }




} else {
    exec echo "-" > Cpx_$suffix.txt
    #exec echo "& \$-\$" > r07_$suffix.tex
    exec echo "& \$-\$" > rcpx_$suffix.tex
}
    #exec cat Cpx_$suffix.txt r07_$suffix.tex
    exec cat Cpx_$suffix.txt rcpx_$suffix.tex
 
    
}




