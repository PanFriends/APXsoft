proc EWgauss {} {

    #EW for gaussian instead of MYTORUS or BN11 model line

    chatter 5
    if {[file exists "myun25_2.4_8.0_u.xcm"]==1} {
    set infile myun25_2.4_8.0_u.xcm
} else {
    set infile myun25_2.4_8.0.xcm
}
    @$infile
    this25m
    @$infile
    scan [exec more Line_lo_hi.txt] "%f %f" lowE highE
    rig 5. 6.6
    #T10 is 4.96 keV–7.74 keV
     
    #Identify parameters to use as guesses

    findncomp MYtorusS
    set npar1 [exec more npar1.txt]

    set n_myS_norm [expr {$npar1+4}]
    tclout param $n_myS_norm
    scan $xspec_tclout "%f" myS_norm

    file delete npar1.txt

    findncomp zpowerlw
    set npar1 [exec more npar1.txt]
    set n_phoZ $npar1
    set n_normZ [expr {$npar1+2}]
    
    tclout param $n_phoZ
    scan $xspec_tclout "%f" phoZ
    
    tclout param $n_normZ
    scan $xspec_tclout "%f" normZ
    
    file delete npar1.txt

    set sig 8.5e-4
    set z 0.0
    model po+zgauss & $phoZ & $normZ & 6.4 & $sig & $z &$myS_norm


    #Line energy
    freeze 3
    freeze 4
    freeze 5
    #norm something to make it iterate
    newpar 6 1e-3

    #chatter 5
    show
    fit 
    newpar 3 6.4
    fit 
    newpar 6 1e-4
    fit

    #Now thaw
    thaw 3 4 5
    fit 100000
    fit 100000
    fit 100000
    fit 100000
    fit 100000
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
    fit
 
    plot data ratio
    logoff
    chatter 10
    show all
    puts "FILE $infile"
    puts "ignore 5. 6.6"
    puts "lowE highE $lowE $highE"
    svall EWgauss.xcm

    puts "OK? - 88 to quit, 77 to load xcm, 9 continue"
    set ans [gets stdin]
    scan $ans "%f" q
    if {$q == 88}    {
	puts "terminated"
	return
    }
    if {$q == 77}    {
	chatter 0
	puts "xcm file:"
	set ans [gets stdin]
	scan $ans "%s" newinfile
	@$newinfile
	this25m
	@$newinfile
	rig 5. 6.6
	fit
	fit
	fit
        plot data ratio
        logoff
        chatter 10
        show all
        puts "FILE $infile"
        puts "ignore 5. 6.6"
        puts "lowE highE $lowE $highE"
    }


    #######################
    #AV CONT "AT" LINE PEAK
    #######################
    #ignore **-$lowE $highE-**
    ignore *
    notice $lowE-$highE
    file delete wgline.pco wgline.qdp
    set out [open "wgfile.pco" "w"]
    puts $out  "wdata wgline"
    close $out
    
    setplot command @wgfile
    plot ufspec
    exec /bin/cp wgline.qdp gauss.qdp
    exec /bin/cp wgfile.pco gauss.pco
    setplot delete all
    
    #Average continuum in ph/cm-2/s-1/keV-1 around line:
    set avcont [exec avwgline.sh]
    #This is the continuum to divide by for EW as well.
    puts " "
    #puts "OK?  - 88 to end -- 99 to replot"
    #    set ans [gets stdin]
    
    ##############
    #Remove powerlaw and isolate gaussian
    delcomp 1

    ##############
    #LINE 
    ##############
    flux $lowE $highE err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" fxline fxloline fxhiline phline phloline phhiline 
    
    set out [open "Fx_line_gauss.txt" "w"]
    puts $out  "#phline phloline phhiline     fxline fxloline fxhiline " 
    puts $out [format "%.3e %.3e %.3e     %.3e %.3e %.3e " $phline $phloline $phhiline $fxline $fxloline $fxhiline]
    close $out

    #####################
    #EW - no errors
    #####################
    set out [open "EW_gauss.txt" "w"]
    #EW in eV
    set ew [expr 1e3*$phline/$avcont]
    puts $out [format "%.1f" $ew ]
    close $out


    puts "#phline phloline phhiline "

    set a [expr $phline*1e4 ]
    set b [expr $phloline*1e4 ]
    set c [expr $phhiline*1e4 ]
    puts [format "avcont %.1e" $avcont ]
    puts [format "%.2e %.2e %.2e " $a $b $c ]
    puts [format "EW %.1f" $ew ]

}
