proc myunline_z {} {

    #myunline_z


    #→ 8/2020: For cthin, all lumin results converted to 1e42 units up front ←
    #8/2018: Strictly, should take into account best fit z, or? - not done!
    #5/2018: Take into account z≠0
    #5/2018: Give energy bounds to avwline.sh, ∵ not doing
    #avcont correctly otherwise when 2 data groups
    #5/2018: BUG: The first time, you must replot (99)
    #5/2018: Mpc only for distance in DL.txt
    #5/2018: Version with redshift, new writeout type
    
    #Switch off all components except for mytorusL for
    #estimating flux / lumin

    #Calculate continuum 2-10 keV by
    #(1) switching off any Gaussian lines
    #(2) subtracting MytorusL from total

    #Best fit should be loaded
    #if {[file exists "myun25_2.4_8.0_u.xcm"]==1} {
    #	set infile myun25_2.4_8.0_u.xcm
    #} else {
    #	set infile myun25_2.4_8.0.xcm
    #}

    #Naming:
    set fin  "/tmp/logname.log"
#    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set name [exec gawk { { {if(NR==1) {if(NF>2) {print $1$2} else {print $1}}}}} $fin ]
    #    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set obs [exec gawk { { {if(NR==1) {if(NF>2) {print $3} else {print $2}}}}} $fin ]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]

    #PIN data used if more than 1 data groups - or it's NuSTAR!
    #In both cases, can do the 10-30 keV measurements:
    tclout datagrp
    scan $xspec_tclout "%i" pin
        
    set suffix ${name}_${obs}_${xcm}
    
    #z-sensitive:
    set z [exec more z.txt]
    if {[file exists "Line_lo_hi.txt"]==1} {
	scan [exec more Line_lo_hi.txt] "%f %f" lowE highE
    } else {
	set lowE [expr 6.3/(1.+$z)]
	set highE [expr 6.5/(1.+$z)]
    }
    puts "lowE highE $lowE $highE"
    #exec /bin/rm wline*
    #puts "FILE $infile"

    #    @$infile
    #this100 for COMB
    #   this25m
    #  @$infile
    plot

    set name [exec more stub.txt]
    set kpc double(3.08568025e21)
    set Mpc double(3.08568025e24)
    set pi double(3.1415926535897931)
    #set dist [expr $::env(d$name)*$kpc] for COMB
    #set namebase [exec /bin/sh -c "findbasename.sh"]
    #set dist [expr $::env(d$namebase)*$kpc]
    #set dist [exec more DL.txt]
    exec /home/pana/cPrograms/X/cosmo70/dlum70 $z > dout.txt
    set dist [exec gawk { {if(NR==2) {print $3} } } dout.txt]
    set dist [expr $dist*$Mpc]
    #fit

    ##############
    #Find and remove any Gaussian line components first
    gaussrm

    ##############
    #TOTAL 2-10 keV  (for cont 2-10 after line flux done)
    ##############
    #Observed frame:
    flux 2 10 err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" fxtot fxlotot fxhitot phtot phlotot phhitot

    #Rest frame
    #set lxtot [expr 4.0*$pi*$fxtot*$dist*$dist]
    lumin 2 10 $z
    tclout lumin 1
    scan $xspec_tclout "%f" lxtot
    set lxtot [expr $lxtot*100.]
    
    #For later, do the 10-30 keV if warranted
    if {$pin > 1} {
	flux 10 30 err 100
	tclout flux 1
	scan $xspec_tclout "%f %f %f %f %f %f" fxtot2 fxlotot2 fxhitot2 phtot2 phlotot2 phhitot2

	lumin 10 30 $z
	tclout lumin 2
	scan $xspec_tclout "%f" lxtot2
	#set lxtot2 [expr 4.0*$pi*$fxtot2*$dist*$dist]
	set lxtot2 [expr $lxtot2*100.]
    }
    	
    #######################
    #AV CONT "AT" LINE PEAK
    #######################
    #ignore **-$lowE $highE-**
    set lob $lowE
    set hib $highE
    set ans $lob
    while { [regexp {[0-9]} $ans ] } {
	ignore *
	notice $lowE-$highE
	setplot command re x $lowE $highE
	set loy 1e-4
	set hiy 1e-3
	if {[file exists "myunline_z_ylohi"]==1} {
	    scan [exec more myunline_z_ylohi] "%f %f" loy hiy
	    setplot command re y $loy $hiy
	}
	setplot command log off
	plot ufspec
	fadd 7
	puts [format "OK? (%.2f %.2f) low high - <RET> ends -- 99 replots" $lowE $highE]
	set ans [gets stdin]
	scan $ans "%f %f" lob hib
	if { [regexp {[0-9]} $lob] && $lob != 99 } {
	    set lowE $lob
	    set highE $hib
	    puts "low $lowE high $highE"
	   }
	if {$lob == 99} {
	    puts "ylohi ($loy $hiy)"
	    set repl [gets stdin]
	    scan $repl "%f %f" loy hiy
	    setplot command re y $loy $hiy
	    #save
	    exec /bin/sh -c "echo $loy $hiy > myunline_z_ylohi"
	}
    }
    
	    
    #Save for ref:
    set out [open "Line_lo_hi.txt" "w"]
    puts $out [format "%.3f %.3f " $lowE $highE]
    close $out
    
    file delete wline.pco wline.qdp wfile.pco
    set out [open "wfile.pco" "w"]
    puts $out  "wdata wline"
    close $out

    setplot command @wfile
    plot ufspec
    exec /bin/cp wline.qdp myun.qdp
    exec /bin/cp wfile.pco myun.pco
    setplot delete all

    #Average continuum in ph/cm-2/s-1/keV-1 around line:
    set avcont [exec avwline.sh $lowE $highE]
    #This is the continuum to divide by for EW as well.
    puts "avcont $avcont"
    puts " "
    #puts "OK?  - 88 to end -- 99 to replot"
    #    set ans [gets stdin]

    ##############
    #MYTL COMPONENT ISOLATE
    ##############
    set infile [exec gawk {NR==2 {print}} /tmp/logname.log]
    puts "$infile -OK?"
    set ans [gets stdin]
    if {[regexp {[a-zA-Z]} $ans ]} {
    	set infile $ans
    }
    	
    @$infile

    #y-limits for plotting this
    setplot command re x $lowE $highE
    setplot command log off
    plot ufspec
    #scan [exec ysphline.bash $z] "%f %f" ylo yhi
    file delete provcon.qdp provcon.pco wfile.pco 
    exec provcon.sh
    setplot command @wfile
    setplot command log off
    plot ufspec
    setplot delete all
    setplot command log off
    scan [exec ysphline.bash $z] "%f %f" ylo yhi
    setplot command re y $loy  $hiy
    fadd 7
    plot
    
    tclout modcomp
    set n_comp $xspec_tclout

    #Find number of MYTorusL comp
    findncomp MYTorusL
    set n_my [exec more /tmp/thecomp.txt]
    
    #Find greatest "gsmooth" comp number < $n_my
    findncomp gsmooth
    set n_gsmooth [exec more /tmp/thecomp.txt]
    
    #delcomp AFTER $n_my
    set n_after [ expr $n_comp - $n_my ]
    set j [ expr $n_my+1 ]

    for {set i 1}  {$i <= $n_after} {incr i} {
	delcomp $j
    }

    #delcomp BEFORE AND UP TO $n_gsmooth


    ###############################################################
    #This will only keep MYTorusL
    #set n_before [ expr $n_gsmooth ]
    #
    #for {set i 1}  {$i <= $n_before} {incr i} {
    #delcomp 1
    #}
    ###############################################################

    ###############################################################
    #This will keep the A_L constant  and gsmooth  
    set n_before [ expr $n_gsmooth-2 ]
    #puts "set n_before [ expr $n_gsmooth-2 ]"
    #exit
    
    for {set i 1}  {$i <= $n_before} {incr i} {
	delcomp 1
    }
    ###############################################################

    ###############################################################
    #This will keep the A_L constant but not gsmooth    
    #set n_before [ expr $n_gsmooth-2 ]
    #delcomp $n_gsmooth
    #
    #for {set i 1}  {$i <= $n_before} {incr i} {
    #delcomp 1
    #}
    ###############################################################

    show
    puts "OK?"
    set ans [gets stdin]
    

    ###############################################################
    #Include for testing:
    #puts "n_gsmooth $n_gsmooth"
    #puts "OK?  - 88 to end -- 99 to replot"
    #    set ans [gets stdin]
    ###############################################################

    ##############
    #LINE 
    ##############
    #ONLY tex is shifted to rest frame!
    flux $lowE $highE err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" fxline fxloline fxhiline phline phloline phhiline 
    set lxline [expr 4.0*$pi*$fxline*$dist*$dist]

    set out [open "FxLx_line_$suffix.txt" "w"]
    puts $out  "#phline fxline lxline    fxloline fxhiline" 
    puts $out [format "%.3e %.3e %.3e     %.3e %.3e " $phline $fxline $lxline $fxloline $fxhiline ]
    close $out

    #Units 1e-5 - The error from the relative error in As_$suffix.txt -- if As not frozen!
    set phlineSC [expr $phline/1e-5]
    set flag [scan [exec gawk {{print $6, $7}} As_$suffix.txt] "%f %f" Asrelo Asrehi]
    #flag will be -1 if As was frozen; then use alternate file, and calculate relative errors
    if {$flag < 0} {
	exec gawk {{printf"%.4e %.4e\n", ($1-$2)/$1, ($4-$1)/$1}} As-alt.txt  > relohi.txt
	scan [exec gawk {{print $1, $2}} relohi.txt] "%f %f" Asrelo Asrehi
    }	
    set phlinehi [expr $phlineSC*$Asrehi]
    set phlinelo [expr $phlineSC*$Asrelo]
    #set outtex [open "r13_$suffix.tex" "w"]
    set outtex [open "rfline_$suffix.tex" "w"]
    puts $outtex [format "& \\aer{%.2f}{+%.2f}{-%.2f}" [expr (1.+$z)*$phlineSC] [expr (1.+$z)*$phlinehi] [expr (1.+$z)*$phlinelo]]
    
    close $outtex
    
    puts "++++++++++++++++++++++++++++++++++++"
    puts " "
    puts "MYTorusL component $n_my"
    puts " "
    puts "delcomp all other components"
    puts "$n_after components after MYTorusL"
    puts "gsmooth is component $n_gsmooth"
    puts "$n_before components before MYTorusL"
    puts " "
    puts "FxLx_line_$suffix.txt"
    puts [format "Fx line %.3e ph/cm2/s %.3e erg/cm2/s" $phline $fxline ]
    puts [format "Lx line %.3e" $lxline ]

    #set ans [gets stdin]

    #####################
    #EW - no errors
    #####################
    #ONLY tex is shifted to rest frame!
    set out [open "EW_$suffix.txt" "w"]
    #EW in eV
    set ew [expr 1e3*$phline/$avcont]
    puts $out [format "%.1f" $ew ]
    close $out

    #Tex: The error from the relative error in As_$suffix.txt
    #Read above in Asrelo Asrehi
    set ewhi [expr $ew*$Asrehi]
    set ewlo [expr $ew*$Asrelo]
    #set outtex [open "r14_$suffix.tex" "w"]
    set outtex [open "rew_$suffix.tex" "w"]
    puts $outtex [format "& \\aer{%.0f}{+%.0f}{-%.0f}" [expr (1.+$z)*$ew]  [expr (1.+$z)*$ewhi] [expr (1.+$z)*$ewlo]]
    close $outtex

    ####################################################
    #The bits below will be repeated for CONT 10-30 keV#
    ####################################################
    
    #####################
    #OBS. CONT 2-10 keV
    #####################
    set fx210 [expr $fxtot-$fxline]
    #set lx210 [expr $lxtot-$lxline]
    set lx210 $lxtot
    
    set out [open "FxLx_2-10_$suffix.txt" "w"]
    puts $out  "#fx210 lx210 "
    puts $out [format "%.3e %.3e    " $fx210 $lx210 ]
    close $out

    puts " "
    puts "flux - lumin for cont 2-10 keV"
    puts "FxLx_2-10_$suffix.txt"
    puts [format "%.3e %.3e" $fx210 $lx210 ]

    #Tex:units 1e-11 (flux) 1e42 (Lx) - NB 1e44 is xspec default
    #set outtex [open "r16_$suffix.tex" "w"]
    set outtex [open "rfobs210_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" [expr $fx210/1e-11]]
    close $outtex
    #set outtex [open "r17_$suffix.tex" "w"]
    set outtex [open "rlabso210_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" $lx210]
    close $outtex
    
    #####################
    #UNABSORBED CONT 2-10 keV
    #####################
    #Find first zpowerlw PhoIndex and norm (z=0)
    #cpd none
    chatter 0
    this $infile
    chatter 10

    puts " "
    puts "unabsorbed continuum 2-10 keV"
    findzpo

    flux 2 10 err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" ufx210 ufx210lotot ufx210hitot uph210tot uph210lotot uph210hitot
    #set ulx210 [expr 4.0*$pi*$ufx210*$dist*$dist]
    lumin 2 10 $z
    tclout lumin 1
    scan $xspec_tclout "%f" ulx210
    set ulx210 [expr $ulx210*100.]
    
    set out [open "FxLx_2-10_un_$suffix.txt" "w"]
    puts $out  "#ufx210 ulx210 "
    puts $out [format "%.3e %.3e    " $ufx210 $ulx210 ]
    close $out

    #Tex: Lx only, units 1e44 - rest frame
    #set outtex [open "r18_$suffix.tex" "w"]
    set outtex [open "rlunabso210_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" $ulx210]
    close $outtex
    
    #ALL TOGETHER ON SCREEN

    puts "FxLx_line_$suffix.txt"
    puts [format "Fx line %.3e ph/cm2/s %.3e erg/cm2/s" $phline $fxline ]
    puts [format "Lx line %.3e" $lxline ]

    puts " "
    puts "flux - lumin for cont 2-10 keV"
    puts "FxLx_2-10_$suffix.txt"
    puts [format "%.3e %.3e" $fx210 expr $lx210 ]


    puts " "
    puts "unabsorbed flux - lumin for cont 2-10 keV"
    puts "FxLx_2-10_un_$suffix.txt"
    puts [format "%.3e %.3e" $ufx210 expr $ulx210 ]

    puts " "
    puts "avcont"
    puts "$avcont"

    puts " "
    puts "EW (eV)"
    puts [format "%.1f" $ew ]

    #puts "flux $lowE $highE"

    file delete wline.pco wline.qdp


    #cpd none
    chatter 0
    this $infile


    #Check if need to do 10-30 keV
    if {$pin > 1} {
    #####################
    #OBS. CONT 10-30 keV
    #####################
    
    set fx1030 $fxtot2
    set lx1030 $lxtot2

    set out [open "FxLx_10-30_$suffix.txt" "w"]
    puts $out  "#fx1030 lx1030 "
    puts $out [format "%.3e %.3e    " $fx1030 $lx1030 ]
    close $out

    puts " "
    puts "flux - lumin for cont 10-30 keV"
    puts "FxLx_10-30_$suffix.txt"
    puts [format "%.3e %.3e" $fx1030 $lx1030 ]

    #Tex:units 1e-11 (flux) 1e44 (Lx)
    #set outtex [open "r19_$suffix.tex" "w"]
    set outtex [open "rfobs1030_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" [expr $fx1030/1e-11]]
    close $outtex
    #set outtex [open "r20_$suffix.tex" "w"]
    set outtex [open "rlabso1030_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" [expr $lx1030]]
    close $outtex
    
    #####################
    #UNABSORBED CONT 10-30 keV
    #####################
    #Find first zpowerlw PhoIndex and norm (z=0)
    #cpd none
    chatter 0
    this $infile
    chatter 10

    puts " "
    puts "unabsorbed continuum 10-30 keV"
    findzpo

    flux 10 30 err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" ufx1030 ufx1030lotot ufx1030hitot uph1030tot uph1030lotot uph1030hitot
    #set ulx1030 [expr 4.0*$pi*$ufx1030*$dist*$dist]

    
    lumin 10 30 $z
    tclout lumin 2
    scan $xspec_tclout "%f" ulx1030
    set ulx1030 [expr $ulx1030*100.]
    
    set out [open "FxLx_10-30_un_$suffix.txt" "w"]
    puts $out  "#ufx1030 ulx1030 "
    puts $out [format "%.3e %.3e    " $ufx1030 $ulx1030 ]
    close $out

    #Tex: Lx only, units 1e44
    #set outtex [open "r21_$suffix.tex" "w"]
    set outtex [open "rlunabso1030_$suffix.tex" "w"]
    puts $outtex [format "& %.2f" [expr $ulx1030]]
    close $outtex
    
    #ALL TOGETHER ON SCREEN

    puts " "
    puts "flux - lumin for cont 10-30 keV"
    puts "FxLx_10-30_$suffix.txt"
    puts [format "%.3e %.3e" $fx1030 $lx1030 ]


    puts " "
    puts "unabsorbed flux - lumin for cont 10-30 keV"
    puts "FxLx_10-30_un_$suffix.txt"
    puts [format "%.3e %.3e" $ufx1030 $ulx1030 ]

    #puts "flux $lowE $highE"

    file delete wline.pco wline.qdp


    #cpd none
    chatter 0
    this $infile
    chatter 10

    #if pin > 1 -END
} else {
    #set outtex [open "r19_$suffix.tex" "w"]
    set outtex [open "rfobs1030_$suffix.tex" "w"]
    puts $outtex "& $-$"
    close $outtex
    #set outtex [open "r20_$suffix.tex" "w"]
    set outtex [open "rlabso1030_$suffix.tex" "w"]
    puts $outtex "& $-$"
    close $outtex
    #set outtex [open "r21_$suffix.tex" "w"]
    set outtex [open "rlunabso1030_$suffix.tex" "w"]
    puts $outtex "& $-$"
    close $outtex
    
}

    #puts "LXTOT $lxtot $ulx210"
    
}
