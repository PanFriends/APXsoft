proc plotout {xcmfile {loy2 0.5} {hiy2 1.5} {rex 15} {rey 10}} {

#For MULTIPLE observations, run in single obs*/ADD dir

#Plot and output plot points and info

    #This version: square aspect for DARA only, for fast resubmission!
    #No x-y labels for DARA either!
    
set nameobs $::env(name[exec more stub.txt])
set objname [exec more stub.txt]
set obs $::env(otex[exec more stub.txt])
set obs [lindex [split $obs ~] 2]
if {[string equal -nocase "4u17a" $objname] == 0 && \
	[string equal -nocase "gamcasa" $objname] == 0} {
    set let [string toupper [string index $objname end]]} else {
    set let " "
    }
set vlet 0.85

puts "$nameobs $let"

echo $rex $rey > rebin.txt

file delete provcon.qdp provcon.pco wfile.pco 

chatter 1
@$xcmfile
chatter 10

#type?
tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
	set type sph
        set stype Spherical
}
if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
        set stype MYtorus
}

set lw 1    
#set lw 4 PROP!
###############################
# UFSPEC - RATIO
###############################
if {[file exists "ufra_lo_hi.txt"]==1} {
    scan [exec more ufra_lo_hi.txt] "%f %f" ylo yhi
}
if {[file exists "ufra_lo2_hi2.txt"]==1} {
    scan [exec more ufra_lo2_hi2.txt] "%f %f" loy2 hiy2
}

setplot rebin $rex $rey
setplot energy
cpd /xs
setplot command re y 1e-3
setplot add
setplot command log x
plot ufspec ratio

exec provcon.sh
setplot command @wfile
plot
setplot delete all
if {[file exists "ufra_lo_hi.txt"]==0} {
#"Best" y-limits from data plotted
#scan [exec yuest.bash] "%f %f" ylo yhi
scan [exec yest.bash] "%f %f" ylo yhi
}
set lob $ylo
while {$lob != 88} {
setplot command re y $ylo $yhi
setplot command lw $lw
setplot command lw $lw on 2
setplot command label title $nameobs $stype (Unfolded Spectrum)
setplot command label y Photons cm\\u-2\\d s\\u-1\\d keV\\u-1\\d
setplot command time off
setplot command Csize 1.2
setplot command font roman
#set lety [expr $yhi-($yhi-$ylo)/6]
#set lety [expr $ylo*($yhi/$ylo)*0.9]

set lety 0.9

#setplot command lab 10 pos 7.6 $lety cs 2 \"$let\"
setplot command lab 10 vpos $vlet $vlet cs 2 \"$let\"

setplot command window 2
setplot command re y $loy2 $hiy2
setplot command label y data/model
setplot command LAB  2 COL 2 LIN 0 100 JUS Lef
setplot command window 1

if {[string  equal -nocase "sph" $type] == 1} {
sphadd $lw
}
if {[string  equal -nocase "myun" $type] == 1} {
myunadd $lw
}
#setplot command err off 3
plot ufspec ratio

puts "OK? ($ylo $yhi $loy2 $hiy2) lo hi lo2 hi2- 88 to end"
    set ans [gets stdin]
    scan $ans "%f %f %f %f" lob hib lob2 hib2
if {$lob != 88} {
    set ylo $lob
    set yhi $hib
    set loy2 $lob2
    set hiy2 $hib2

    puts "ylow $ylo yhigh $yhi   2: $loy2 $hiy2"

    }
}
exec echo $ylo $yhi > "ufra_lo_hi.txt"
exec echo $loy2 $hiy2 > "ufra_lo2_hi2.txt"


#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

#=1 line red in residuals
exec coresid provcon.pco

#err off does not transmit from setplot to pco - fix
exec cat  provcon.pco /tmp/erroffU > /tmp/tplot


exec cp /tmp/tplot provcon.pco

exec mv provcon.pco $objname\_$obs\_UFRA\_$type.pco
exec mv provcon.qdp $objname\_$obs\_UFRA\_$type.qdp
exec mv pgplot.ps   $objname\_$obs\_UFRA\_$type.eps

#Fix new pco file
exec rnamepco2 $objname\_$obs\_UFRA\_$type.pco $objname\_$obs\_UFRA\_$type.qdp 

#Final ps
#exec qitps $objname\_$obs\_UFRA\_$type
#exec okular $objname\_$obs\_UFRA\_$type.eps > /dev/null 2>&1 &

echo $objname\_$obs\_UFRA\_$type.pco > /tmp/namprov
echo $objname\_$obs\_UFRA\_$type.qdp >> /tmp/namprov
echo $objname\_$obs\_UFRA\_$type.eps >> /tmp/namprov

###############################
# DATA (ZOOM) - RATIO 5.8 to 7.6 keV
###############################
if {[file exists "dara_lo_hi.txt"]==1} {
    scan [exec more dara_lo_hi.txt] "%f %f" ylo yhi
}
if {[file exists "dara_lo2_hi2.txt"]==1} {
    scan [exec more dara_lo2_hi2.txt] "%f %f" loy2 hiy2
}

puts $objname
puts $type
setplot rebin 1 1
setplot energy
ig **-5.8 7.6-**   
#ig **-6.2 6.6-** PROP!
cpd /xs
setplot command re y 1e-3
setplot add
plot data ratio
pfadd $lw
logoff

exec provcon.sh
setplot command @wfile
plot
setplot delete all
if {[file exists "dara_lo_hi.txt"]==0} {
#"Best" y-limits from data plotted
scan [exec yest.bash] "%f %f" ylo yhi
}
set lob $ylo
while {$lob != 88} {
setplot command re y $ylo $yhi
setplot command lw $lw
#PROP!
setplot command lw $lw on 1   
#PROP!
setplot command lw $lw on 7
setplot command lw $lw on 8
setplot command lw $lw on 9
setplot command lw $lw on 10

#
setplot command lw $lw on 2

#Remove x y labels for final massive Fig. 2 in draft
setplot command label title $nameobs $stype (Data and Folded Model)
setplot command label x " "    
setplot command time off
setplot command Csize 1.2   
#setplot command Csize 1.4 #PROP!
#
setplot command font roman
#set lety [expr $yhi-($yhi-$ylo)/10]
set lety [expr $ylo*($yhi/$ylo)*0.8]
setplot command lab 10 pos 7.5 $lety cs 2 \"$let\"
#setplot command lab 10 vpos $vlet $vlet cs 2 \"$let\"     #PROP!
logoff

setplot command window 2
setplot command view 0.1 0.1 0.71 0.4
setplot command re y $loy2 $hiy2
setplot command label x " "    

#Remove for final massive Fig. 2 in draft
#setplot command label y data/model
setplot command label y  " "
setplot command LAB  2 COL 2 LIN 0 100 JUS Lef
setplot command window 1
setplot command view  0.1 0.4 0.71 0.9
setplot command label y  " "

plot data ratio
if {[string  equal -nocase "sph" $type] == 1} {
sphaddz $lw
}
if {[string  equal -nocase "myun" $type] == 1} {
myunaddz $lw
}
plot data ratio



puts "OK? ($ylo $yhi $loy2 $hiy2) lo hi lo2 hi2- 88 to end"
    set ans [gets stdin]
    scan $ans "%f %f %f %f" lob hib lob2 hib2 
if {$lob != 88} {
    set ylo $lob
    set yhi $hib
    set loy2 $lob2
    set hiy2 $hib2

    puts "ylow $ylo yhigh $yhi   2: $loy2 $hiy2"

    }

}
exec echo $ylo $yhi > "dara_lo_hi.txt"
exec echo $loy2 $hiy2 > "dara_lo2_hi2.txt"

#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

#=1 line red in residuals
exec coresid provcon.pco

#err off does not transmit from setplot to pco - fix
exec cat  provcon.pco /tmp/erroffD > /tmp/tplot
exec mv /tmp/tplot provcon.pco

exec mv provcon.pco $objname\_$obs\_DARA\_$type.pco
exec mv provcon.qdp $objname\_$obs\_DARA\_$type.qdp
exec mv pgplot.ps   $objname\_$obs\_DARA\_$type.eps


#Write out low and high limit from xcmfile name
exec /bin/sh -c "getlim.bash $xcmfile"

#Fix new pco file
exec rnamepco2 $objname\_$obs\_DARA\_$type.pco $objname\_$obs\_DARA\_$type.qdp 

#Final ps
#exec qitps $objname\_$obs\_DARA\_$type
#exec okular $objname\_$obs\_DARA\_$type.eps > /dev/null 2>&1 &

echo $objname\_$obs\_DARA\_$type.pco >> /tmp/namprov
echo $objname\_$obs\_DARA\_$type.qdp >> /tmp/namprov
echo $objname\_$obs\_DARA\_$type.eps >> /tmp/namprov

more /tmp/namprov
mv /tmp/namprov FILES_plotout_$type.txt
}
