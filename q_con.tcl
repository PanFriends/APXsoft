proc q_con {} {

    #Quick contours

    set b ""
    set a ""
    set ni ""
    set x1 ""
    set x2 ""
    set y1 ""
    set y2 "" 
    
    set nameobs [exec more stub.txt]

    if {[file exists "q_con_last.txt"]==1} {
	scan [exec more q_con_last.txt] "%i %i %i" a b ni
    }

    #Parameters
    puts "y= ($b)"
    set ans [gets stdin]
    if {[regexp {[0-9]} $ans]==0} {
	set y $b
    } else {
	scan $ans "%i" y
    }
    puts "x= ($a)"
    set ans [gets stdin]
    if {[regexp {[0-9]} $ans]==0} {
	set x $a
    } else {
	scan $ans "%i" x
    }

    
    #Limits
    tclout pinfo $y
    scan $xspec_tclout "%s" yname
    tclout param $y
    scan $xspec_tclout "%f %f" yval yerr
    #thaw if frozen
    set yfrozen 0
    if {$yerr < 0} {
	set yfrozen 1
	thaw $y
    }
    tclout pinfo $x
    scan $xspec_tclout "%s" xname
    tclout param $x
    scan $xspec_tclout "%f %f" xval xerr
    set xfrozen 0
    if {$xerr < 0} {
	set xfrozen 1
	thaw $x
    }
    if {[file exists "q_con_xylim.txt"]==1} {
	scan [exec more q_con_xylim.txt] "%f %f %f %f" x1 x2 y1 y2
    }
    puts "y ($yname=$yval) vs. x ($xname=$xval)"
    puts "y-limits (low high - $y1 $y2):"
    set ylim [gets stdin]
    if {[regexp {[0-9]} $ylim]} {
	scan $ylim "%f %f" y1 y2
    }
    puts "x-limits (low high - $x1 $x2):"
    set xlim [gets stdin]
    if {[regexp {[0-9]} $xlim]} {
	scan $xlim "%f %f" x1 x2
    }

    #N_iter
    puts "n_iter ($ni):"
    set niter [gets stdin]
    if {[regexp {[0-9]} $niter]} {
	scan $niter "%d" ni
    }

    #Record call:
    set out [open "q_con_CONTOUR\_$yname\_$xname.txt" "w"]
    puts $out "steppar $x $x1 $x2 $ni   $y $y1 $y2 $ni"
    puts "steppar $x $x1 $x2 $ni   $y $y1 $y2 $ni"
    close $out
   
    file delete provcon.qdp provcon.pco wfile.pco


    #Save limit choices
    set out [open "q_con_xylim.txt" "w"]
    puts $out "$x1 $x2 $y1 $y2"
    close $out
    #Keep for next time:
    exec echo $x $y $ni > q_con_last.txt


    #Do it:
    steppar $x $x1 $x2 $ni  $y $y1 $y2 $ni     

    puts "steppar $x $x1 $x2 $ni   $y $y1 $y2 $ni"
    plot contour
    setplot command re x $x1 $x2
    setplot command re y $y1 $y2
    setplot command csize 1.3
    setplot command font Ro
    setplot command time off
    setplot command lwidth 5
    setplot command cont 1 lwid 2 2 2
    setplot command cont 1 color 1 2 4
    setplot command cont 1 lstyle 1 1 1
    setplot command lab F 
    setplot command lab T $nameobs
    setplot command lab 1 col 1

    if { [string first factor $xname] != -1 } {  
	setplot command lab x \\fiC\\d\\frPIN:XIS\\fr
    }
    if { [string first NH $xname] != -1 } {  
	setplot command lab x \\fiN\\fr\\dH,S\\u (10\\u24\\d cm\\u-2\\d)
    }
    if { [string first factor $yname] != -1 } {  
	setplot command lab y \\fiA\\fr\\dS\\u 
    }
    if { [string first NH $yname] != -1 } {  
	setplot command lab y \\fiN\\fr\\dH,S\\u (10\\u24\\dcm\\u-2\\d)
    }
    if { [string first Sig $yname] != -1 } {  
	setplot command lab y \\gs\\fi\\dL \\fr(keV)
    }
    if { [string first PhoIndx $xname] != -1 } {  
	setplot command lab x \\gG\\fr\\dS\\u 
    }
    if { [string first Redshift $xname] != -1 } {  
	setplot command lab x \\fiz\\fr 
    }
    if { [string first nH $yname] != -1 } {  
	setplot command lab y \\fiN\\fr\\dH,sph\\u (10\\u22\\dcm\\u-2\\d)
    }
    if { [string first Fe $xname] != -1 } {  
	setplot command lab x \\fiA\\fr\\dFe,sph\\u (\\fiA\\fr\\dFe\\(2281)\\u)
    }


    setplot command view  0.1 0.1 .7 .85
    plot
    setplot command hardcopy /cps
    exec provcon.sh
    setplot command @wfile
    plot
    setplot delete all


    set p "pgplot.ps"
   
    #Final name
    scan $nameobs "%s %s" src obsid
    set finalname fig_${src}_${obsid}_q_con_${yname}_${xname}.eps
    exec mv $p $finalname
    
    #Refreeze
    if { $xfrozen == 1 } {
	freeze $x
    }
    if { $yfrozen == 1 } {
	freeze $y
    }



}
