proc azout { {predelta 0.1} {uponly 0} {doonly 0}} {

    #8/2018: Adapted from asout.tcl
    #Assumes a partial MYtorusZ is on top
    
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

    set outtxt [ open "Az_$suffix.txt" "w" ]
    set outtex [ open "r9A_$suffix.tex" "w" ]

    findncomp_first MYtorusZ
    set npar1 [exec more /tmp/npar1.txt]
    set Az [expr $npar1-1]

    tclout param $Az
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$Az.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$Az.txt"]==1} {
	set uponly 1
    }

    if { $lim >=0 } {
	errout $Az $predelta $uponly $doonly
	#Output also relative errors:
	exec gawk {{printf"%.4e %.4e\n", ($1-$2)/$1, ($4-$1)/$1}} errout.txt  > relohi.txt
	exec paste errout.txt relohi.txt > Az_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} Az_$suffix.txt > r9A_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' Az_$suffix.txt > r9A_$suffix.tex" > gawk_Az.txt
   }

    exec cat Az_$suffix.txt r9A_$suffix.tex
    
    
}




