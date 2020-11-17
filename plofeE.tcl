proc plofeE {xcmfile} {

    #Plot data zoomed on Fe region

    set name [exec more stub.txt]
    set z [exec more z.txt]
    exec echo $name > /tmp/logname.log
    exec echo $xcmfile >> /tmp/logname.log
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]
    
    file delete provcon.qdp provcon.pco wfile.pco 
    chatter 1
    @$xcmfile
    chatter 10

    set let "d"
    set vlet 0.85
    set vobs 0.8
    set lw 1

    setplot energy
    cpd /xs
    #setplot command log off
    
    set xlo [expr 5.4/(1.+$z)]
    set xhi [expr 8.2/(1.+$z)]
    if {[file exists "${xcm}_Fe_ylo_yhi.txt"]==1} {
	scan [exec more ${xcm}_Fe_ylo_yhi.txt] "%f %f" ylo yhi
    } else {
	set ylo 1e-5
	set yhi 2
    }
    if {[file exists "${xcm}_FeK_xy.txt"]==1} {
	scan [exec more ${xcm}_FeK_xy.txt] "%f %f" fex fey
    } else {
    set fex $xlo
	set fey [expr $yhi/2.]
    }
    if {[file exists "${xcm}_lline_length.txt"]==1} {
	scan [exec more ${xcm}_lline_length.txt] "%f" lline
    } else {
    set lline 1.1
    }
    
    set ans .1
    set lob $ylo
    set hib $yhi
    setplot command re y $ylo $yhi
    setplot command re x $xlo $xhi
    setplot command co off 1..1000
    plot eeufspec

    exec provcon.sh
    setplot command @wfile
    setplot command co off 1..1000
    setplot command co 1 on 1
    setplot command co 2 on 2
    plot eeufspec
    setplot delete all
    
    while { [regexp {[0-9]} $ans ] } {
	
	setplot command re y $ylo $yhi
	setplot command re x $xlo $xhi
	setplot command lw $lw
	setplot command lw $lw on 2
	setplot command co off 1..1000
	setplot command co 1 on 1
	setplot command co 2 on 2
	setplot command label title " " 
	setplot command label y \\fiE f(E)\\fr (keV\\u2\\d photons cm\\u-2\\d s\\u-1\\d keV\\u-1\\d)
	setplot command label x Energy (keV)
	setplot command time off
	setplot command Csize 1.2
	setplot command font roman
	set lety 0.9
#	setplot command lab 10 vpos $vlet $vlet cs 2 \"($let)\"
#	setplot command lab  9 vpos $vlet $vobs cs 2 \"$obs\"
	setplot command lab 10 vpos $vobs $vlet cs 2 \"($let)\"
	setplot command lab  9 vpos $vobs $vobs cs 2 \"$obs\"
	#setplot command log off
	#Fe K line
	setplot command label 11 position [expr 6.4/(1.+$z)] 0 co 1 ls 2 line 90 $lline
#	setplot command lab 12 vpos $vlet $vlet cs 2 \"($let)\"
	plot eeufspec

	puts "OK? ($ylo $yhi) lo hi - <RET> ends"
	set ans [gets stdin]
	scan $ans "%f %f" lob hib
	if { [regexp {[0-9]} $lob ] } {
	    set ylo $lob
	    set yhi $hib
	    puts "ylow $ylo yhigh $yhi"
	    exec echo $ylo $yhi > "${xcm}_Fe_ylo_yhi.txt"

	}
	set afek 1
	setplot command lab 13 position $fex $fey cs 1.2 co 1 \"Fe K\\ga\\fr\"
	plot
	while { [regexp {[0-9]} $afek ] } {
	    puts "FeKa label OK? ($fex $fey) x y - <RET>"
	    set afek [gets stdin]
	    scan $afek "%f %f" fex fey
	    setplot command lab 13 position $fex $fey cs 1.2 co 1 \"Fe K\\ga\\fr\"
	    plot eeufspec
	    exec echo $fex $fey > ${xcm}_FeK_xy.txt
	}
	setplot command label 11 position [expr 6.4/(1.+$z)] 0 co 1 ls 2 line 90 $lline
	plot
	set ansline $lline
	while { [regexp {[0-9]} $ansline ] } {
	    puts "Dashed line OK? ($lline) length - <RET>"
	    set ansline [gets stdin]
	    scan $ansline "%f" lline
	    setplot command label 11 position [expr 6.4/(1.+$z)] 0 co 1 ls 2 line 90 $lline
	    plot eeufspec
	    exec echo $lline > ${xcm}_lline_length.txt
	}
	
	


	
    }

    #hardcopy
    setplot command hardcopy /cps
    plot

    #Info in qdp and pco files
    file delete provcon.qdp provcon.pco wfile.pco
    exec provcon.sh
    setplot command @wfile
    plot
    setplot delete all


    exec mv provcon.pco $name\_$obs\_$xcm\_Fe_efe.pco
    exec mv provcon.qdp $name\_$obs\_$xcm\_Fe_efe.qdp
    exec mv pgplot.ps   $name\_$obs\_$xcm\_Fe_efe.eps

}

    
