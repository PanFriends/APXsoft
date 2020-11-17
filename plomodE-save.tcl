proc plomodE {xcmfile} {

    #2020 for Cthin
    set pin 1

    #Plot model components only

    #PGPLOT line styles are:
    # 1=Solid, 2=Dash, 3=Dash-dot, 4=Dot, 5=Dash-dot-dot-dot
    
    #PGPLOT colors are:
    #  0=Backg,     1=Foreg,       2=Red,         3=Green,
    #  4=Blue,      5=Light blue,  6=Magenta,     7=Yellow,
    #  8=Orange,    9=Yel.+Green, 10=Green+Cyan, 11=Blue+Cyan,
    # 12=Blue+Mag, 13=Red+Mag,    14=Dark Grey,  15=Light Grey
	
    set name [exec more stub.txt | gawk { {if(NF>2) {print $1$2,$3} else {print $1,$2}} } ]
    exec echo $name > /tmp/logname.log
    exec echo $xcmfile >> /tmp/logname.log
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]

    #Find xlow xhigh from the Erange* files used:
    #If there is PIN in the name of the xcm file, it has to be XIS+PIN;
    #if theres XIS but no PIN, it is PIN only;
    #else it's NuSTAR AB
    #set pin 0
    #if {[ string first "PIN" $xcm ]>-1} {
    #	set xlo [exec gawk -F- {{print $2}} ErangeXIS.txt | gawk {{print $1}} ]
    #	set xhi [exec gawk {{print $2}} ErangePIN.txt | gawk -F- {{print $1}} ]
    #	set pin 1
    #}
    #if {[ string first "PIN" $xcm ]==-1 && [ string first "XIS" $xcm ]>-1 } {
    #	set xlo [exec gawk -F- {{print $2}} ErangeXIS.txt | gawk {{print $1}} ]
    #	set xhi [exec gawk {{print $NF}} ErangeXIS.txt | gawk -F- {{print $1}} ]
    #}
    #if {[ string first "XIS" $xcm ]==-1 } {
    #	set xlo [exec gawk -F- {{print $2}} ErangeAB.txt | gawk {{print $1}} ]
    #	set xhi [exec gawk {{print $NF}} ErangeAB.txt | gawk -F- {{print $1}} ]
    #}

    #Cthin
    set xlo 2.3
    set xhi [exec gawk {{print $2}} ErangePIN.txt | gawk -F- {{print $1}} ]
    
    file delete provcon.qdp provcon.pco wfile.pco 
    chatter 1
    @$xcmfile
    chatter 10
    data 2 none/
    dummyrsp
    
    #set let "b"
    #set vlet 0.85
    #set vobs 0.8
    
    set lw 1

    setplot energy
    cpd /xs
    setplot command log y
    setplot command log x
    set ylo 1e-5
    set yhi 2
    setplot command re y $ylo $yhi
    setplot command re x $xlo $xhi
    setplot command co off 1..1000
    #setplot add
    plot eemodel

    exec provcon.sh
    setplot command @wfile
    setplot command log y
    setplot command log x
    setplot command co off 1..1000
    setplot command co error off 1
    setplot command co error off 2
    setplot command co 1 on 1
    setplot command co 2 on 2
    plot eemodel
    setplot delete all
    if {[file exists "${xcm}_mod_x_x_y_y.txt"]==1} {
	scan [exec more ${xcm}_mod_x_x_y_y.txt] "%f %f %f %f" xlo xhi ylo yhi
    }
    set loy $ylo
    set hiy $yhi
    set lox $xlo
    set hix $xhi
    set ans $loy
    set scax 0.2
    set scay 0.2
    set dirx 0.5
    set diry 0.5
    if {[file exists "${xcm}_scadir_xy.txt"]==1} {
	scan [exec more ${xcm}_scadir_xy.txt] "%f %f %f %f" scax scay dirx diry
    }

    while { [regexp {[0-9]} $ans ] } {
	
	setplot command re y $ylo $yhi
	setplot command re x $xlo $xhi
	setplot command lw 2
	setplot command lw $lw on 2
	setplot command lw $lw on 3
	setplot command lw $lw on 4
	setplot command co off 1..1000
	setplot command line on 1
	setplot command line on 2
	setplot command line on 3
	setplot command error off 1
	setplot command error off 2
	setplot command error off 3
	setplot command co 1 on 1
	setplot command co 4 on 2
	setplot command co 2 on 3
	setplot command ls 1 on 2
	setplot command ls 1 on 3
	setplot command ls 1 on 4
	#If XIS and PIN, need to find numbers of PIN data and total additives
	#Then only use XIS set but full energy extent with dummyrsp command
	if { $pin == 1 } {
	    #tclout model
	    #offset between PIN data columns and XIS data columns is
	    #number of columns -3
	    set numoff [exec gawk { {if(NR==5) {print NF-3}} } provcon.qdp]
	    #set numplus [regexp -all {\+} $xspec_tclout]
	    #data 2 none/
	    #dummyrsp
	    setplot command co 1 on [expr 1+$numoff]
	    setplot command co 4 on [expr 2+$numoff]
	    setplot command co 2 on [expr 3+$numoff]
	    setplot command lw $lw on [expr 1+$numoff]
	    setplot command lw $lw on [expr 2+$numoff]
	    setplot command lw $lw on [expr 3+$numoff]
	}
	setplot command label title 
	setplot command label y \\fiE f(E)\\fr (keV\\u2\\d photons cm\\u-2\\d s\\u-1\\d keV\\u-1\\d)
	setplot command label x Energy (keV)
	setplot command time off
	setplot command Csize 1.2
	setplot command font roman
	set lety 0.9
#	setplot command lab 10 vpos $vlet $vlet cs 2 \"($let)\"
#	setplot command lab  9 vpos $vlet $vobs cs 2 \"$obs\"
#	setplot command lab 10 vpos $vobs $vlet cs 2 \"($let)\"
#	setplot command lab  9 vpos $vobs $vobs cs 2 \"$obs\"
	setplot command lab 11 vpos $scax $scay cs 1.2 co 2 \"scattered continuum\"
	setplot command lab 12 vpos $dirx $diry cs 1.2 co 4 \"zeroth-order continuum\"
	setplot command log y
	setplot command log x
	plot eemodel

	
	puts "OK? ($xlo $xhi $ylo $yhi) x1 x2  y1 y2 - <RET> ends"
	set ans [gets stdin]
	scan $ans "%f %f %f %f" lox hix  loy hiy
	if { [regexp {[0-9]} $ans ] } {
	    set xlo $lox
	    set xhi $hix
	    set ylo $loy
	    set yhi $hiy
	    puts "xlow $xlo xhigh $xhi   ylow $ylo yhigh $yhi"
	    exec echo $xlo $xhi $ylo $yhi > "${xcm}_mod_x_x_y_y.txt"
	}

	set asca 1
	while { [regexp {[0-9]} $asca ] } {
	    puts "scattered label OK? ($scax $scay) x y - <RET>"
	    set asca [gets stdin]
	    scan $asca "%f %f" scax scay
	    setplot command lab 11 vpos $scax $scay cs 1.2 co 2 \"scattered continuum\"
	    plot eemodel
	}
	set adir 1
	while { [regexp {[0-9]} $adir ] } {
	    puts "direct label OK? ($dirx $diry) x y - <RET>"
	    set adir [gets stdin]
	    scan $adir "%f %f" dirx diry
	    setplot command lab 12 vpos $dirx $diry cs 1.2 co 4 \"zeroth-order continuum\"
	    plot eemodel
	}
	exec echo $scax $scay $dirx $diry > ${xcm}_scadir_xy.txt
	
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

    exec mv provcon.pco $name\_$obs\_$xcm\_MO_efe.pco
    exec mv provcon.qdp $name\_$obs\_$xcm\_MO_efe.qdp
    exec ps2pdf pgplot.ps pgplot.pdf
    exec mv pgplot.pdf   $name\_$obs\_$xcm\_MO_efe.pdf
    set pdir /home/pana/TEX/PAPERS/CTHIN
    set thisdir [exec pwd]
    exec ln -s -f $thisdir/$name\_$obs\_$xcm\_MO_efe.pdf $pdir/.


}
