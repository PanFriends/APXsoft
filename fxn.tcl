proc fxn {ks} {
    #make fake spectra for XMM-Nustar proposal

    set xcm "/tmp/fxn$ks"
    exec /bin/bash -c "fxn.bash $ks"
    @$xcm

    set nu [ exec echo fak${ks}nustar.fak ]
    set new [ exec echo fak${ks}new.fak ]
    set faktiein [ exec echo faktie${ks}in ]
    set faktieout [ exec echo faktie${ks}out ]
    
    data 1:1 $nu
    ig 1:**-2.
    ig 1:70.-**
    data 2:2 $new
    ig 2:0.-.5 
    ig 2:10.-**

    newpar 4  2.37437E-05 .1 0 0 0.998 0.998
    svall $faktiein
    
    cpd /xs
    setplot energy
    plot data


    puts "fit"
    puts "svall $faktieout"
    

    
}
