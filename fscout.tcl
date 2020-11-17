proc fscout {{predelta 0.1} {uponly 0} {doonly 0}} {

    #fscout 21

    #This is essentially identical to aout.tcl. The output file is different.

    #Normally, this is the last const appearing, but let's be clear by giving param number.

    #type is used for final filename

    #Created by findmyt
    set varfile /home/pana/.xspec/f.var
    exec rm -f $varfile
    
    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]

    set suffix ${name}_${obs}_${xcm}

    #Fs output
    set outtex [ open "rfs_$suffix.tex" "w" ]
    set outtxt [ open "fs_$suffix.txt" "w" ]
   
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type trans
	puts "type $type"
    }

    if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
	puts "type $type"
    }

    findmyt
    scan [exec more $varfile] "%s %i %i" f npar ncomp

    #Exists?
    if {$npar == 0} {
	puts "nonexistent"
	exec echo "0"  > fs_$suffix.txt
        exec echo "&$\\ldots$" > rfs_$suffix.tex 

    } else {
	
	tclout param $npar
	scan $xspec_tclout "%f %f" val lim
    
	#Check if frozen
	frcheck $npar
	set frozen [exec more frcheck.txt]
	file delete frcheck.txt

	if {$frozen == 1} {
	    puts "frozen"
	    puts $outtxt [format "%.3f f" $val]
	    puts $outtex [format "& %.3f$^{\\rm f}$" $val]
	    close $outtxt
	    close $outtex
	}

	if {[file exists "ULm$npar.txt"]==1} {
	    set doonly 1
	}
	if {[file exists "LLm$npar.txt"]==1} {
	    set uponly 1
	}

	if {$frozen == 0} {
	    puts "not frozen"

	#Check if error calculation to be done (ie Zfe != 10 for type trans)
	#scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
	#if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
	#    tclout param $npar
	#    scan $xspec_tclout "%f" parval
	#    exec /bin/sh -c "echo $parval 0 0 0 0 > fs_$suffix.txt"
	#} else {
	    exec echo fscout $npar $predelta $uponly $doonly > "fscout_Call_$type.txt"
	    errout $npar $predelta $uponly $doonly
	    exec cp errout.txt fs_$suffix.txt
	    exec gawk {{printf"& \\aer{%.3f}{+%.3f}{-%.3f}\n", $1, $4-$1, $1-$2}} fs_$suffix.txt > rfs_$suffix.tex



	    
	#}
    }
    }
    puts " "
    exec cat fs_$suffix.txt fs_$suffix.tex
    
}

