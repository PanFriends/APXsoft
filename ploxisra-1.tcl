proc ploxisra {xcmfile} {


    #Plot XIS ratio

    set name [exec more stub.txt]
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
    set pin 0
    if {[ string first "PIN" $xcm ]>-1} {
	set xlo [exec gawk -F- {{print $2}} ErangeXIS.txt | gawk {{print $1}} ]
	set xhi [exec gawk {{print $2}} ErangePIN.txt | gawk -F- {{print $1}} ]
	set pin 1
    }
    if {[ string first "PIN" $xcm ]==-1 && [ string first "XIS" $xcm ]>-1 } {
	set xlo [exec gawk -F- {{print $2}} ErangeXIS.txt | gawk {{print $1}} ]
	set xhi [exec gawk {{print $NF}} ErangeXIS.txt | gawk -F- {{print $1}} ]
    }
    if {[ string first "XIS" $xcm ]==-1 } {
	set xlo [exec gawk -F- {{print $2}} ErangeAB.txt | gawk {{print $1}} ]
	set xhi [exec gawk {{print $NF}} ErangeAB.txt | gawk -F- {{print $1}} ]
    }

    file delete provcon.qdp provcon.pco wfile.pco 
    chatter 1
    @$xcmfile
    chatter 10

    set let "c"
    set vlet 0.85
    set vobs 0.8
    
    set lw 1

    setplot energy
    cpd /xs
    setplot command log off
    setplot command log x
    if {[file exists "${xcm}_ra_lo_hi.txt"]==1} {
	scan [exec more ${xcm}_ra_lo_hi.txt] "%f %f" ylo yhi
    } else {
	set ylo -2
	set yhi 2
    }
    setplot command re y $ylo $yhi
    setplot command re x $xlo $xhi
    setplot command co off 1..1000
    plot ratio

    exec provcon.sh
    setplot command @wfile
    setplot command log off
    setplot command log x
    setplot command co off 1..1000
    setplot command co 1 on 1
    #setplot command co 2 on 2
    plot ratio
    setplot delete all
    set lob $ylo
    set ans $lob
    set hib $lob
   
    while { [regexp {[0-9]} $ans ] } {
	
	setplot command re y $ylo $yhi
        setplot command re x $xlo $xhi
	setplot command lw $lw
	setplot command co off 1..1000
	setplot command co 1 on 1
	#setplot command co 2 on 2
	#If XIS and PIN
	if { $pin == 1 } {
	    setplot command co 1 on 2
	}
	setplot command label title 
	setplot command label y Data/model ratio
	setplot command label x Energy (keV)
	setplot command time off
	setplot command Csize 1.2
	setplot command font roman
	set lety 0.9
#	setplot command lab 10 vpos $vlet $vlet cs 2 \"($let)\"
#	setplot command lab  9 vpos $vlet $vobs cs 2 \"$obs\"
	setplot command lab 10 vpos $vobs $vlet cs 2 \"($let)\"
	setplot command lab  9 vpos $vobs $vobs cs 2 \"$obs\"
	setplot command log off
	setplot command log x
	plot ratio
 	setplot command label 1 co 2 lin 0 100 jus lef
	plot
	
	puts "OK? ($ylo $yhi) lo hi - <RET> ends"
	set ans [gets stdin]
	scan $ans "%f %f" lob hib
	if { [regexp {[0-9]} $ans ] } {
	    set ylo $lob
	    set yhi $hib
	    puts "ylow $ylo yhigh $yhi"
	}
	    exec echo $ylo $yhi > "${xcm}_ra_lo_hi.txt"
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

    
    exec mv provcon.pco $name\_$obs\_$xcm\_RA.pco
    exec mv provcon.qdp $name\_$obs\_$xcm\_RA.qdp
    exec mv pgplot.ps   $name\_$obs\_$xcm\_RA.eps

}

    
