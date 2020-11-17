proc sigfwout {{predelta 0.1} {uponly 0} {doonly 0}} {

    #sig and FW output
    #5/2018: This still does not print out upper/lower limit cases properly
    
    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set c 2.99792458e5 
    set factor [expr 2 * (2*log(2))**0.5]

    set suffix ${name}_${obs}_${xcm}

    set outtxt "sigfw_$suffix.txt"
    #set outtexs [ open "r15A_$suffix.tex" "w" ]
    #set outtexf [ open "r15B_$suffix.tex" "w" ]
    set outtexs [ open "rsig_$suffix.tex" "w" ]
    set outtexf [ open "rfw_$suffix.tex" "w" ]
  
    findncomp_first gsmooth
    set nsig [exec more /tmp/npar1.txt]

    tclout param $nsig
    scan $xspec_tclout "%f %f" val lim
    if { $lim < 0 } {
	set frozen 1
	puts "frozen"
	exec echo "$val f" > $outtxt
	exec echo "100 f" >> $outtxt
	puts $outtexs [format "& $%.1f^{\\rm f}$" [expr 1e3*$val]]
	set valF [expr $factor*$c*$val/6.]
	puts $outtexf [format "& \$%.0f^{\\rm f}\$" $valF]
        close $outtexs
        close $outtexf
    }
    if {[file exists "ULm$nsig.txt"]==1} {
	set doonly 1
    }
    if {[file exists "LLm$nsig.txt"]==1} {
	set uponly 1
    }

    if { $lim >=0 } {
	errout $nsig $predelta $uponly $doonly
	scan [exec gawk {{print $1,$2,$3,$4,$5}} errout.txt] "%f %f %f %f %f" best low chilow high chihigh
	set up [expr $high-$val]
	set do [expr $val-$low]
	#FWHM - c in km/s
	set valF [expr $factor*$c*$val/6.]
	set valFlo [expr $factor*$c*$low/6.]
	set valFhi [expr $factor*$c*$high/6.]
        set valFup [expr $valFhi-$valF]
        set valFdo [expr $valF-$valFlo]

	exec mv errout.txt $outtxt
	exec echo $valF $valFlo $valFhi >> $outtxt

	puts $outtexs [format "& \\aer{%.1f}{+%.1f}{-%.1f}" [expr 1e3*$val] [expr 1e3*$up] [expr 1e3*$do] ]
	puts $outtexf [format "& \\aer{%.0f}{+%.0f}{-%.0f}" $valF $valFup $valFdo]
        close $outtexs
        close $outtexf

    }	
        exec cat rsig_$suffix.tex rfw_$suffix.tex
    

}
