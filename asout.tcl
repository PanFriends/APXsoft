proc asout { {predelta 0.1} {uponly 0} {doonly 0}} {

    #5/2018: Also output relative errors for later use
    #in calculating line flux and EW errors
    
    #As errors and output
    #Based on maout, aout

    

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "As_$suffix.txt" "w" ]
    #set outtex [ open "r10_$suffix.tex" "w" ]
    set outtex [ open "ras_$suffix.tex" "w" ]

    findncomp MYtorusS
    set npar1 [exec more /tmp/npar1.txt]
    set As [expr $npar1-1]

    tclout param $As
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    #This is a bug if you will do both XIS and XIS+PIN in same directory!
    if {[file exists "ULm$As.txt"]==1} {
	set doonly 1
    }
    
    if {[file exists "LLm$As.txt"]==1} {
	set uponly 1
    }

    if { $lim >=0 } {
	errout $As $predelta $uponly $doonly
	#Output also relative errors:
	exec gawk {{printf"%.4e %.4e\n", ($1-$2)/$1, ($4-$1)/$1}} errout.txt  > relohi.txt
	exec paste errout.txt relohi.txt > As_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} As_$suffix.txt > ras_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' As_$suffix.txt > ras_$suffix.tex" > gawk_As.txt
   }

    exec cat As_$suffix.txt ras_$suffix.tex
    
    
}




