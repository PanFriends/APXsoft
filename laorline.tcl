proc laorline {{lae 6.4}} {

    #laorline 6.97

    #Switch off all components except for laor to estimate flux/EW

    
    #For loaded model


    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set nameobs $name

    #Laor inclination for names:
    findncomp laor
    set ilaor [exec more /tmp/npar1.txt]
    set ilaor [expr $ilaor+4]
    tclout param $ilaor
    scan $xspec_tclout "%f" val
    set ilaor $val
    
    file delete /tmp/npar1.txt
    
    #z-sensitive:
    #NB: this is only for the interpolation to find continuum
    #at line peak
    set z [exec more z.txt]
    if {[file exists "Laor${lae}_${ilaor}_lo_hi.txt"]==1} {
	scan [exec more Laor${lae}_${ilaor}_lo_hi.txt] "%f %f" lowE highE
    } else {
	set lowE [expr ($lae-0.1)/(1.+$z)]
	set highE [expr ($lae+0.1)/(1.+$z)]
    }
    puts "lowE highE $lowE $highE"
   
    set name [exec more stub.txt]


    #######################
    #[AV] CONT "AT" LINE PEAK
    #######################
    #From myunline_z.tcl, where the range is interactively specified; really need at the peak itself but this should do.

    #The laor component is very broad, so will do flux of it over
    #full XIS range.

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



    ##################
    #laor ISOLATE
    ##################
    tclout modcomp
    set n_comp $xspec_tclout

    #Find number of laor comp
    for {set i 1} {$i <= $n_comp} {incr i} {
    
    tclout compinfo $i
    if { [string first "laor" $xspec_tclout] != -1 } {
    #this is MYTorusL component number
    set n_la $i 
    }
    }
    
    #delcomp AFTER $n_la
    set n_after [ expr $n_comp - $n_la ]
    set j [ expr $n_la+1 ]
    
    for {set i 1}  {$i <= $n_after} {incr i} {
    delcomp $j
    }

    #delcomp BEFORE $n_la
    set n_before [ expr $n_la ]
    
    for {set i 1}  {$i < $n_before} {incr i} {
    delcomp 1
    }

    
    set lowE elo
    set highE ehi
    
    #############
    #FLUX
    #############
    
    flux 1. 9.5 err 100
    tclout flux 1
    scan $xspec_tclout "%f %f %f %f %f %f" fxline fxloline fxhiline phline phloline phhiline
    set out [open "Flux_${lae}_${ilaor}_laor.txt" "w"]
    puts $out  "#phline fxline    fxloline fxhiline" 
    puts $out [format "%.3e %.3e     %.3e %.3e " $phline $fxline $fxloline $fxhiline ]
    close $out
    

    #####################
    #EW - no errors
    #####################
    set out [open "EW_${lae}_${ilaor}_laor.txt" "w"]
    #EW in eV
    set ew [expr 1e3*$phline/$avcont]
    puts $out [format "%.1e" $ew ]
    puts $out [format "%.1e" [expr $ew*(1.+$z)] ]
    close $out
    


    puts "Flux_${lae}_${ilaor}_laor.txt"
    puts [format "Fx line %.3e ph/cm2/s %.3e erg/cm2/s" $phline $fxline ]

    puts " "
    puts "cont"
    puts "$avcont"
    
    puts "EW_${lae}_${ilaor}_laor.txt"
    puts "EW (eV) x(1+z)"
    puts [format "%.1e" [expr $ew*(1.+$z)] ]





}
