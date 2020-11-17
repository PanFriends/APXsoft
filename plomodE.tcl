proc plomodE {xcmfile {auto 0}} {

    #auto 1   for batch auto plotting

    #2020 for Cthin
    set pin 1

    set nmytz /home/pana/.xspec/naddmytz
    set nmyts /home/pana/.xspec/naddmyts
    set nmytl /home/pana/.xspec/naddmytl
    set nf /home/pana/.xspec/naddf
    set nsf /home/pana/.xspec/naddsf

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
    
    set let "b"
    set xlet 0.65
    set ylet 0.15
    #set vobs 0.8
    
    set lw 3

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
    setplot command view  0.1 0.1 .7 .85
    plot eemodel

    exec provcon.sh
    setplot command @wfile
    setplot command log y
    setplot command log x
    setplot command co off 1..1000
    #setplot command co error off 1
    #setplot command co error off 2
    #setplot command co 1 on 1
    #setplot command co 2 on 2
    setplot command view  0.1 0.1 .7 .85
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
    set totx 0.72
    set toty 0.7
    set dirx $totx
    set diry 0.65
    set scax $totx
    set scay 0.6
    set lx $totx
    set ly 0.55
    set fx $totx
    set fy 0.5
#    if {[file exists "${xcm}_scadir_xy.txt"]==1} {
#	scan [exec more ${xcm}_scadir_xy.txt] "%f %f %f %f" scax scay dirx diry
#    }

    #How many additives are there? Note this will include zgauss, which don't want
    tclout model
    #set nadd [expr [regexp -all {\+} $xspec_tclout] + 2]
    #Write them out - this will not write zgauss
    eval file delete [glob /home/pana/.xspec/nadd* ]
    exec echo $xspec_tclout > xout
    exec findadd xout
    #puts findadd
    
    scan [exec more $nmytz] "%i" naddz
    scan [exec more $nmyts] "%i" nadds
    scan [exec more $nmytl] "%i" naddl
    if {[file exists $nf]==1} {
	scan [exec more $nf] "%i" naddf
    } else {
	set naddf -1
    }
    if {[file exists $nsf]==1} {
	scan [exec more $nsf] "%i" naddsf
    } else {
	set naddsf -1
    }
    
    #puts "naddz $naddz"
    
    while { [regexp {[0-9]} $ans ] } {
	
	setplot command re y $ylo $yhi
	setplot command re x $xlo $xhi
	setplot command lw 3
	for {set i 1} {$i <= 10} {incr i} {
	    setplot command lw $lw on $i
	}
	setplot command co off 1..1000
	#Total
	setplot command line on 1
	setplot command error off 1
	setplot command co 1 on 1
	setplot command ls 1 on 1
	setplot command lab 10 vpos $totx $toty cs 1.2 co 1 \" TOTAL\" justify left
	setplot command lab 10 line 0 ls 1 co 1
	#Z
	setplot command line on $naddz
	setplot command error off $naddz
	setplot command co 2 on $naddz
	setplot command ls 2 on $naddz
	setplot command lab 11 vpos $dirx $diry cs 1.2 co 2 \" MYTorusZ\"
	setplot command lab 11 line 0 ls 2 co 2
	#S
	setplot command line on $nadds
	setplot command error off $nadds
	setplot command co 4 on $nadds
	setplot command ls 3 on $nadds
	setplot command lab 12 vpos $scax $scay cs 1.2 co 4 \" MYTorusS\"
	setplot command lab 12 line 0 ls 3 co 4
	#L
	setplot command line on $naddl
	setplot command error off $naddl
	setplot command co 6 on $naddl
	setplot command ls 4 on $naddl
	setplot command lab 13 vpos $lx $ly cs 1.2 co 6 \" MYTorusL\"
	setplot command lab 13 line 0 ls 4 co 6
	#f
	if {[file exists $nf]==1} {
	    setplot command line on $naddf
	    setplot command error off $naddf
	    setplot command co 8 on $naddf
	    setplot command ls 5 on $naddf
	    setplot command lab 14 vpos $fx $fy cs 1.2 co 8 \" Second PL\"
	    setplot command lab 14 line 0 ls 5 co 8
	}
	#sf -- EITHER f OR sf EXIST
	if {[file exists $nsf]==1} {
	    setplot command line on $naddsf
	    setplot command error off $naddsf
	    setplot command co 8 on $naddsf
	    setplot command ls 5 on $naddsf
	    setplot command lab 14 vpos $fx $fy cs 1.2 co 8 \" Second PL\"
	    setplot command lab 14 line 0 ls 5 co 8
	}
	

	setplot command label title 
	setplot command label y \\fiE f(E)\\fr (keV\\u2\\d photons cm\\u-2\\d s\\u-1\\d keV\\u-1\\d)
	setplot command label x Energy (keV)
	setplot command time off
	setplot command Csize 1.2
	setplot command font roman
	setplot command lab 15 vpos $xlet $ylet cs 2 \"($let)\"
	#setplot command lab  9 vpos $vobs $vobs cs 2 \"$obs\"
	setplot command log y
	setplot command log x
	setplot command view  0.1 0.1 .7 .85
	plot eemodel

	
	#Skip this if doing batch auto plotting:
	if { $auto == 0 } {
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
	} else {
	    set ans "a"
	}

	#set asca 1
	#while { [regexp {[0-9]} $asca ] } {
	#    puts "scattered label OK? ($scax $scay) x y - <RET>"
	#    set asca [gets stdin]
	#    scan $asca "%f %f" scax scay
	#    setplot command lab 11 vpos $scax $scay cs 1.2 co 1 \"scattered continuum\"
	#    plot eemodel
	#}
	#set adir 1
	#while { [regexp {[0-9]} $adir ] } {
	#    puts "direct label OK? ($dirx $diry) x y - <RET>"
	#    set adir [gets stdin]
	#    scan $adir "%f %f" dirx diry
	#    setplot command lab 12 vpos $dirx $diry cs 1.2 co 1 \"zeroth-order continuum\"
	#    plot eemodel
	#}
	#exec echo $scax $scay $dirx $diry > ${xcm}_scadir_xy.txt
	
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
