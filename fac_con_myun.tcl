proc fac_con {{nsteps 15} {x1 -888} {x2 -888} {y1 -888} {y2 -888}} {

    #5/2018: Remembers last choices for x,y, iterations, limits
    
    #2-D contours NHS or Γ or anything vs. cross-normalization factor
    #or
    #As vs. NHS

    
    #Load fitted model
    #Then

    #fac_con

    puts "............................."
    puts "y-options: As NHs sig"
    puts "x-options: Cpintoxis NHs Γs z"
    puts "............................."
    set nameobs [exec more stub.txt]
    tclout modcomp
    set n_comp $xspec_tclout


    #Doing only for mytorus
    set type myun
    set ptype MYtorus

    #Free cross-normalization is the first parameter after last parameter of
    #last cpt of first data group - cut check if more than one data group:
    tclout compinfo $n_comp
    scan $xspec_tclout "%s %i %i" name par npars
    tclout datagrp
    scan $xspec_tclout "%i" ngroups
    if { $ngroups != 1 } {
    set par_cross [expr {$par+$npars}]
	puts " Cpinxis is $par_cross"
	#Read value
	tclout param $par_cross
	scan $xspec_tclout "%f" freecross
    } else {
	set par_cross -1
	puts " No Cpinxis"
    }
    
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i

	#Find MytorusS and As
    if { [string first MYtorusS $xspec_tclout] != -1 } {    
    scan $xspec_tclout "%s %i %i" name par npars
    set par_NHs $par
    puts " NHs par is $par_NHs"
    set par_As [expr {$par-1}]
	puts " AS par is $par_As"
	set par_gammaS [expr $par+2]
	puts " ΓS is $par_gammaS"
    #Read value
    tclout param $par_NHs
    scan $xspec_tclout "%f" NHs
    
    tclout param $par_As
    scan $xspec_tclout "%f" As

    tclout param $par_gammaS
    scan $xspec_tclout "%f" Gs
    }
	#Find zpowerlw
    if { [string first zpowerlw $xspec_tclout] != -1 } {
    scan $xspec_tclout "%s %i %i" name par npars
	set par_gamma $par
	set par_z [expr $par+1]
	puts " Γ is $par_gamma"
	puts " z is $par_z"
    
    #Read value
    tclout param $par_gamma
    scan $xspec_tclout "%f" Gamma
     
    }
	#Find gsmooth via MYTorusL
    if { [string first MYTorusL $xspec_tclout] != -1 } {
    scan $xspec_tclout "%s %i %i" name par npars
	set par_sig [expr $par-2]
	puts " sig par is $par_sig"

    #Read value
    tclout param $par_sig
    scan $xspec_tclout "%f" sig
	}
	
    }

    

    #Default (returns) is y=As vs. x=NHs
    if {[file exists "last_fac_con.txt"]==1} {
	scan [exec more last_fac_con.txt] "%i %i %i" a b ni
	puts "y=$b ($par_As default) or?"
    } else {
	puts "y=As ($par_As) or?"
    }
    set y [gets stdin]
    
    if { [ regexp {[0-9]} $y ]} {
	puts "→ y=$y"
    } else  {
	if {[file exists "last_fac_con.txt"]==1} {
	    set y $b
	    puts "→ y=$y"
	} else {
	    set y $par_As
	    puts "→ y=$y"
	}
    }
    
    if {[info exists a]==1} {
	puts "x=$a ($par_NHs default) or?"
    } else {
	puts "x=NHs ($par_NHs) or?"
    }
    set x [gets stdin]
    
    if { [ regexp {[0-9]} $x ]} {
	puts "→ x=$x"
    } else  {
	if {[file exists "last_fac_con.txt"]==1} {
	    set x $a
	    puts "→ x=$x"
	} else {
	    set x $par_NHs
	    puts "→ x=$x"
	}
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
    puts "xfrozen $xfrozen yfrozen $yfrozen"

    if {[file exists "fac_con_xylim.txt"]==1} {
	scan [exec more fac_con_xylim.txt] "%f %f %f %f" x1 x2 y1 y2
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

    if {[file exists "last_fac_con.txt"]==1} {
	set i $ni
    } else {
	set i 5
    }
    puts "n_iter ($i):"
    set niter [gets stdin]
    if {[regexp {[0-9]} $niter]} {
	scan $niter "%d" i
    }

    #Read parameters from XIS-only fit
    if {[file exists "NHS_XIS_file.txt"]==1} {
	set filexis [exec more NHS_XIS_file.txt]
    } else {
	puts "NHS XIS-only fit filename?"
	set filexis [gets stdin]
	exec echo $filexis > NHS_XIS_file.txt

    }

    if {[file exists $filexis]==1} {
	scan [exec more $filexis] "%f %f %f %f %f" xis1 xis2 xis3 xis4 xis5
	#Units 1e24 for plot
	set xislow [expr $xis2/1e2]
	set xishigh [expr $xis4/1e2]
    }

    #Plot the lines?
    puts "Lines from XIS-only fit?(<RET> or n)"
    set ans [gets stdin]
    set plotlines 0
    if {[regexp {[a-zA-z]} $ans]==0} {
	set plotlines 1
    }

  
    #Record call:
    set out [open "CONTOUR\_$yname\_$xname\_Call.txt" "w"]
    puts $out "steppar $x $x1 $x2 $i   $y $y1 $y2 $i"
    puts "steppar $x $x1 $x2 $i   $y $y1 $y2 $i"
    close $out

    file delete provcon.qdp provcon.pco wfile.pco

    #Save limit choices
    set out [open "fac_con_xylim.txt" "w"]
    puts $out "$x1 $x2 $y1 $y2"
    close $out
    #Keep for next time:
    exec echo $x $y $i > last_fac_con.txt

    
    #Do it:
    steppar $x $x1 $x2 $i  $y $y1 $y2 $i     

    puts "steppar $x $x1 $x2 $i   $y $y1 $y2 $i"
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

    #puts "XNAME YNAME $xname $yname"
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
	setplot command lab y \\gs\\fi\\dL (keV)
    }
    if { [string first PhoIndx $xname] != -1 } {  
	setplot command lab x \\gG\\fr\\dS\\u 
    }
    if { [string first Redshift $xname] != -1 } {  
	setplot command lab x \\fiz\\fr 
    }

    #The following additional lines cause wrong bounding box in ps file
    #-fixed later.
    if {$plotlines==1} {
	setplot command label 10 position 1.16 0 col 4 ls 2 line 90 5
	setplot command label 11 position 1.18 0 col 4 ls 2 line 90 5
	setplot command label 12 position $x1 $xislow col 4 ls 2 line 0 5
	setplot command label 13 position $x1 $xishigh col 4 ls 2 line 0 5
    }
     
    setplot command view  0.1 0.1 .7 .85
    plot
    setplot command hardcopy /cps
    exec provcon.sh
    setplot command @wfile
    plot
    
    setplot delete all

    #Refreeze
    if { $xfrozen == 1 } {
	freeze $x
    }
    if { $yfrozen == 1 } {
	freeze $y
    }

    #Hack pgplot.ps to fix bounding box!
    set p "pgplot.ps"
    scan [exec wc -l $p] "%i %s" nlines fname
    set last [expr $nlines-8]
    exec gawk {{if(NR < l) {print}}} l=$last $p > f.prov 
    foreach {a b c d} {40 25 590 550} break
    exec echo "%%PageTrailer\n%%PageBoundingBox: $a $b $c $d\n\n%%Trailer\n%%BoundingBox: $a $b $c $d\n%%DocumentFonts: Times-Roman Times-Italic\n%%Pages: 1\n%%EOF" >> f.prov

    exec mv f.prov $p

    
    #Hack to bring title lower - careful!
    scan [exec more stub.txt] "%s" word
    scan [exec grep -n $word pgplot.ps | gawk -F: {{print $1}}] "%i" line
    #The critical number is 6750:
    exec gawk {{if(NR==l) {print "20.28  pgscale div FS gs   0.00       3395.448      6750 moveto rotate ("t") TRC gr"} else {print}}} t=$nameobs l=$line pgplot.ps > f.prov
    exec mv f.prov $p
    
    #Final name
    scan $nameobs "%s %s" src obsid
    set finalname fig_${src}_${obsid}_con_${y}_${x}.eps
    exec cp $p $finalname
}
   


