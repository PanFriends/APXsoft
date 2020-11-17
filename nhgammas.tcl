proc nhgammas { {predelta 0.1} {uponly 0} {doonly 0}} {

    #zphabs associated to supersoft ΓS: errors and output

    #ASSUMED right after first zpo  - no other check!
    
    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "nhgammas_$suffix.txt" "w" ]
    set outtex [ open "rnhgammas_$suffix.tex" "w" ]

    #This supersoft PL is placed after first zpo and a zphabs
    findncomp_first zpowerlw
    set par1 [exec more /tmp/npar1.txt]
    set nh [expr $par1+3]

    tclout param $nh
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$nh.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$nh.txt"]==1} {
	set uponly 1
    }
    
    if { $lim >=0 } {
	errout $nh $predelta $uponly $doonly
	exec mv errout.txt nhgammas_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $1-$2, $4-$1}} nhgammas_$suffix.txt > rnhgammas_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$1-\$2, \$4-\$1}' nhgammas_$suffix.txt > rnhgammas_$suffix.tex" > gawk_nhgammas.txt
   }

    exec cat nhgammas_$suffix.txt rnhgammas_$suffix.tex
    

    
}
