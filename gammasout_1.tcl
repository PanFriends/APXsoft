proc gammasout { {predelta 0.1} {uponly 0} {doonly 0}} {

    #ΓS errors and output

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "GammaS_$suffix.txt" "w" ]
    set outtex [ open "r12_$suffix.tex" "w" ]

    findncomp MYtorusS
    set par1 [exec more /tmp/npar1.txt]
    set GammaS [expr $par1+2]

    tclout param $gammaS
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$gammaS.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$gammaS.txt"]==1} {
	set uponly 1
    }
    
    if { $lim >=0 } {
	errout $gammaS $predelta $uponly $doonly
	exec mv errout.txt GammaS_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $1-$2, $4-$1}} GammaS_$suffix.txt > r12_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$1-\$2, \$4-\$1}' GammaS_$suffix.txt > r12_$suffix.tex" > gawk_GammaS.txt
   }

    exec cat GammaS_$suffix.txt r12_$suffix.tex
    

    
}
