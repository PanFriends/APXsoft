proc nhZ { {predelta 0.1} {uponly 0} {doonly 0}} {

    #Written from scratch 8/2020 based on nhS.tcl
    
    #errout for NHZ - Units must be 1e22 \cunits

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    set outtxt [ open "NHZ_$suffix.txt" "w" ]
    set outtex [ open "rnhz_$suffix.tex" "w" ]
    
    findncomp MYtorusZ
    set nz [exec more /tmp/npar1.txt]
    set nfound 1

    #If NOT FOUND, assume it's zphabs, comp 3
    if { $nz == 0 } {
	set nz 3
	set nfound 0 
    }

    tclout param $nz
    scan $xspec_tclout "%f %f" val lim
    #If found, reset units to 1e22
    if { $nfound == 1 } {
	set val [expr 100.*$val]
    }
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	puts $outtxt [format "%.3f f" $val]
	puts $outtex [format "& %.3f$^{\\rm f}$" $val]
        close $outtxt
        close $outtex
    }

    if {[file exists "ULm$nz.txt"]==1} {
	set doonly 1 
    }
    if {[file exists "LLm$nz.txt"]==1} {
	set uponly 1 
    }

    if { $lim >=0 } {
	errout $nz $predelta $uponly $doonly
	
	#Reset units to 1e22, IF FOUND
	if { $nfound == 1 } {
	    exec gawk {{print $1*1e2,$2*1e2,$3,$4*1e2,$5}} errout.txt > NHZ_$suffix.txt
	} else {
	    exec cp errout.txt NHZ_$suffix.txt
	}
	if { $uponly == 1 } { #lower limit
	    exec gawk {{printf"& $>%.3f$\n", $2}} NHZ_$suffix.txt > rnhz_$suffix.tex
	    exec echo "gawk '{printf\"& $>%.3f$\\n\", \$2}' NHZ_$suffix.txt > rnhz_$suffix.tex" > gawk_NHZ.txt
	} else {
	    exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} NHZ_$suffix.txt > rnhz_$suffix.tex
	    exec echo "gawk '{printf\"& \\aer{%.3f}{+%.3f}{-%.3f}\\n\", \$1, \$4-\$1, \$1-\$2}' NHZ_$suffix.txt > rnhz_$suffix.tex" > gawk_NHZ.txt
	}

    exec more NHZ_$suffix.txt
    exec more rnhz_$suffix.tex
 
  
    }
}
    
