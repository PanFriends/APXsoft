proc addlistline {line} {

    #Add line from list
    #Freeze its sigma to 100 km/s to begin with
    
    set list "/home/pana/.xspec/emlines.txt"
    scan [exec more z.txt] "%f" z
    scan [exec /bin/bash -c "grep $line $list"] "%s %f" dum erest
    set eframe [expr $erest/(1.+$z)]

    tclout modcomp
    scan $xspec_tclout "%i" nmod
    set newmod [expr $nmod+1]
    
    addcomp $newmod zgauss & $erest & 8.5e-4 & $z & 1e-5
    fixparen
        
    tclout compinfo $newmod
    scan $xspec_tclout "%s %i %i" dum par1 dum
    freeze [expr $par1+1]
    
    plot
    puts " "
    puts [format "%s %.2f → %.2f" $line $erest $eframe]




}
