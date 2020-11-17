proc nhS { {predelta 0.1} {uponly 0} {doonly 0}} {

    #5/2018: based on nhs.tcl, nhout.tcl

    #errout for NHS - Units must be 1e22 \cunits

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "NHS_$suffix.txt" "w" ]
#    set outtex [ open "r09_$suffix.tex" "w" ]
    set outtex [ open "rnhs_$suffix.tex" "w" ]

    findncomp MYtorusS
    set ns [exec more /tmp/npar1.txt]

    tclout param $ns
    scan $xspec_tclout "%f %f" val lim
    #Reset units to 1e22
    set val [expr 100.*$val]
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

  
    if {[file exists "ULm$ns.txt"]==1} {
	set doonly 1 
    }
    if {[file exists "LLm$ns.txt"]==1} {
	set uponly 1 
    }

    if { $lim >=0 } {
	errout $ns $predelta $uponly $doonly
	
	#Reset units to 1e22
	exec gawk {{print $1*1e2,$2*1e2,$3,$4*1e2,$5}} errout.txt > NHS_$suffix.txt
	if { $uponly == 1 } { #lower limit
	    exec gawk {{printf"& $>%.3f$\n", $2}} NHS_$suffix.txt > rnhs_$suffix.tex
	    exec echo "gawk '{printf\"& $>%.3f$\\n\", \$2}' NHS_$suffix.txt > rnhs_$suffix.tex" > gawk_NHS.txt
	} else {
	    exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} NHS_$suffix.txt > rnhs_$suffix.tex
	    exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' NHS_$suffix.txt > rnhs_$suffix.tex" > gawk_NHS.txt
	}

    exec more NHS_$suffix.txt
    exec more rnhs_$suffix.tex
 
  
    }
}
