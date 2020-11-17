proc gammazout { {predelta 0.1} {uponly 0} {doonly 0}} {

    #ΓZ errors and output

    #Extra care -- there can be more than one- here want first!

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "GammaZ_$suffix.txt" "w" ]
    #set outtex [ open "r11_$suffix.tex" "w" ]
    set outtex [ open "rgammaz_$suffix.tex" "w" ]

    findncomp_first zpowerlw
    set gammaZ [exec more /tmp/npar1.txt]

    tclout param $gammaZ
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$gammaZ.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$gammaZ.txt"]==1} {
	set uponly 1
    }
    
    if { $lim >=0 } {
	errout $gammaZ $predelta $uponly $doonly
	exec mv errout.txt GammaZ_$suffix.txt
#	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} GammaZ_$suffix.txt > r11_$suffix.tex
#	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' GammaZ_$suffix.txt > r11_$suffix.tex" > gawk_GammaZ.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} GammaZ_$suffix.txt > rgammaz_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' GammaZ_$suffix.txt > rgammaz_$suffix.tex" > gawk_GammaZ.txt
   }

        exec cat GammaZ_$suffix.txt rgammaz_$suffix.tex
    
}
