proc deout { {predelta 0.1} {uponly 0} {doonly 0}} {
    
        
    #output energy shift from best-fit redshift wrt cosmological

    #Strategy: An unfrozen z, and steppar will find the limits. For the final
    #fit, this z is frozen.
    
    #4C74
    #set zRef 0.104
    set zRef [exec more z.txt]

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    set suffix ${name}_${obs}_${xcm}

    #zl output
    set outz z_$suffix.txt
    
    #ΔΕ output
    #set outtex [ open "r12_$suffix.tex" "w" ]
    set outtex [ open "rde_$suffix.tex" "w" ]
    
    findncomp_first zpowerlw
    set par1 [exec more /tmp/npar1.txt]
    set zpo [expr $par1+1]
    tclout param $zpo
    scan $xspec_tclout "%f" zfit

    puts "z fitted $zfit"

    #This is frozen; unfreeze; in the end refreeze.
    thaw $zpo
    
    errout $zpo $predelta $uponly $doonly
    freeze $zpo
    exec mv errout.txt $outz

    #Best-fit Eshift, eV:
    set E0 6.400e3
    scan [exec more $outz] "%f %f %f %f %f" zFit zLow chilow zHi chiHi 
    set Dz [expr $zFit-$zRef]
    set DE_fit [expr -$E0 * ( $Dz / (1+$Dz) )]

    set Dz [expr $zHi-$zFit]
    set DE_low  [expr -$E0 * ( $Dz / (1+$Dz) )]

    set Dz [expr $zLow-$zFit]
    set DE_hi  [expr -$E0 * ( $Dz / (1+$Dz) )]

    puts $outtex [format "& \\aer{%.1f}{+%.1f}{%.1f}" $DE_fit $DE_hi $DE_low]
    close $outtex

    exec more rde_$suffix.tex
}
