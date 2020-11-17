proc zphout { {predelta 0.1} {uponly 0} {doonly 0}} {

    #based on nhZ.tcl
    #errout for zphabs NH  [any partial zphabs is *first*]

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "NHZ_$suffix.txt" "w" ]
    set outtex [ open "r08_$suffix.tex" "w" ]
    
    findncomp zphabs
    if {[file exists "/tmp/npar1.txt"]==1} {
	set npar1 [exec more /tmp/npar1.txt]
	set nh $npar1
    }

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

    if { $lim >=0 } {
	errout $nh $predelta $uponly $doonly
	exec mv errout.txt NHZ_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} NHZ_$suffix.txt > r08_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' NHZ_$suffix.txt > r08_$suffix.tex" > gawk_NHZ.txt
   }

    exec more NHZ_$suffix.txt
    exec more r08_$suffix.tex
 

}