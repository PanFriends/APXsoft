proc plotout {xcmfile} {

#For MULTIPLE observations, run in single obs*/ADD dir

#Plot and output plot points and info

set nameobs $::env(name[exec more stub.txt])
set objname [exec more stub.txt]
set obs $::env(otex[exec more stub.txt])
set obs [lindex [split $obs ~] 2]

puts $nameobs


file delete provcon.qdp provcon.pco wfile.pco 

chatter 1
@$xcmfile
chatter 10

###############################
# DATA - RATIO
###############################
#sph or myun?
tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
	set type sph
        set stype spherical
}
if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
        set stype MYtorus
}

if {[file exists "dara_lo_hi.txt"]==1} {
    scan [exec more dara_lo_hi.txt] "%f %f" ylo yhi
}

puts $objname
puts $type
setplot rebin 1 1
setplot energy
cpd /xs
setplot command re y 1e-3
setplot add
plot data ratio
fadd 7
xlogoff

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
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $nameobs $stype
setplot command time off
setplot command Csize 1.2
setplot command font roman
plot data ratio
fadd 7
xlogoff

puts "OK? ($ylo $yhi) lo hi - 88 to end"
    set ans [gets stdin]
    scan $ans "%f %f" lob hib 
if {$lob != 88} {
    set ylo $lob
    set yhi $hib
    puts "ylow $ylo yhigh $yhi"

    }

}
exec echo $ylo $yhi > "dara_lo_hi.txt"

#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

exec mv provcon.pco $objname\_$obs\_DARA\_$type.pco
exec mv provcon.qdp $objname\_$obs\_DARA\_$type.qdp
exec mv pgplot.ps   $objname\_$obs\_DARA\_$type.eps
#exec okular $objname\_DARA\_$type.eps &
#Write out low and high limit from xcmfile name
exec /bin/sh -c "getlim.bash $xcmfile"


###############################
# UFSPEC - RATIO
###############################
if {[file exists "ufra_lo_hi.txt"]==1} {
    scan [exec more ufra_lo_hi.txt] "%f %f" ylo yhi
}
setplot rebin 1 1
setplot energy
cpd /xs
setplot command re y 1e-3
setplot add
setplot command log x
plot ufspec ratio
fadd 7
xlogoff

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
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $nameobs $stype
setplot command time off
setplot command Csize 1.2
setplot command font roman
plot ufspec ratio
fadd 7
#setplot command log x
xlogoff

puts "OK? ($ylo $yhi) lo hi - 88 to end"
    set ans [gets stdin]
    scan $ans "%f %f" lob hib 
if {$lob != 88} {
    set ylo $lob
    set yhi $hib
    puts "ylow $ylo yhigh $yhi"

    }
}
exec echo $ylo $yhi > "ufra_lo_hi.txt"

#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

exec mv provcon.pco $objname\_$obs\_UFRA\_$type.pco
exec mv provcon.qdp $objname\_$obs\_UFRA\_$type.qdp
exec mv pgplot.ps   $objname\_$obs\_UFRA\_$type.eps
#exec okular $objname\_UFRA\_$type.eps &

###############################
# RATIO 
###############################
setplot rebin 1 1
setplot energy
cpd /xs
#setplot command re y 1e-3
#setplot add
#setplot command log x
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $nameobs $stype
setplot command time off
setplot command Csize 1.2
setplot command font roman
setplot command log x off
plot ratio
#fadd 7
#xlogoff

#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all
exec mv provcon.pco $objname\_$obs\_RA\_$type.pco
exec mv provcon.qdp $objname\_$obs\_RA\_$type.qdp
exec mv pgplot.ps   $objname\_$obs\_RA\_$type.eps


#exit
}
