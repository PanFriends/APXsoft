proc ig2.3 {xcm} {

    #ig2.3 myun_XIS_PIN1.xcm

    #Convert to ignore >$lowlim keV

    #CALLS: iglow  (bash)


    set newxcm "/tmp/[expr { round(1000.*rand()) }]_iglow.xcm"
    exec iglow $xcm $newxcm
    @$newxcm
    plot ldata ratio
    fadd
    puts $newxcm
    puts "SAVE?"

}
