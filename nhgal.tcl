proc nhgal { {predelta 0.1} {uponly 0} {doonly 0}} {

    #8/2018: Assumes the *first* phabs is the galactic NH
    

    
#Based on nhZ.tcl
    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "NHgal_$suffix.txt" "w" ]
    set outtex [ open "r07A_$suffix.tex" "w" ]


    findncomp_first phabs
    
    if {[file exists "/tmp/npar1.txt"]==1} {
	set npar1 [exec more /tmp/npar1.txt]
    	set nhgal $npar1
    }
        

    tclout param $nhgal
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }
        
    if {[file exists "ULm$nhgal.txt"]==1} {
	set doonly 1
    }

    if { $lim >=0 } {
	errout $nhgal $predelta $uponly $doonly
	    #Units 1e22:
	exec gawk {{print $1,$2,$3,$4}} errout.txt > errout2.txt
	exec mv errout2.txt NHgal_$suffix.txt
	exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} NHgal_$suffix.txt > r07A_$suffix.tex
	exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' NHgal_$suffix.txt > r07A_$suffix.tex" > gawk_NHgal.txt
   }

    exec more NHgal_$suffix.txt
    exec more r07A_$suffix.tex
 

}
