proc mp123 { {ylo 0} {yhi 2} } {

    #(For [propord]

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

file delete provcon.qdp provcon.pco wfile.pco 
###############################
# DATA (ZOOM) - 
###############################

set data1 [exec /bin/sh -c "ls *m1p1.pha" ]
set data2 [exec /bin/sh -c "ls *m2p2.pha" ]
set data3 [exec /bin/sh -c "ls *m3p3.pha" ]
if {[file exists "mp123_lo_hi.txt"]==1} {
    scan [exec more mp123_lo_hi.txt] "%f %f" ylo yhi
}

set lw 1
data $data1 $data2 $data3
method leven 1000 0.0001
setplot rebin 1 1
setplot energy
#ig **-5.8 7.6-**
cpd /xs
setplot add
#colors
setplot command co 4 on 3
plot data 
pfadd $lw
logoff

exec provcon.sh
setplot command @wfile
plot
setplot delete all

set nlo $ylo
set nhi $yhi
while {$nlo != 88} {
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $nameobs
setplot command time off
setplot command Csize 1.2
setplot command font roman
setplot command co 4 on 3
xlohi 6.2 6.6
#xlohi 6.3 6.5
ylohi $ylo $yhi
logoff
plot data 
#plot counts

puts "ylo yhi - 88 exit"
set ans [get stdin]
scan $ans "%e %e" nlo nhi
if { $nlo != 88 } {
    set ylo $nlo
    set yhi $nhi
    puts "ylo $ylo yhi $yhi"
    ylohi $ylo $yhi
    plot
}
exec echo $ylo $yhi > "mp123_lo_hi.txt"

#hardcopy
setplot command hardcopy /cps
plot

#keep full info in qdp and pco files
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
plot
setplot delete all

exec mv provcon.pco $objname\_$obs\_DA.pco
exec mv provcon.qdp $objname\_$obs\_DA.qdp
exec mv pgplot.ps   $objname\_$obs\_DA.eps

#Fix new pco file
exec rnamepco2 $objname\_$obs\_DA.pco $objname\_$obs\_DA.qdp

echo $objname\_$obs\_DA.pco > /tmp/namprov
echo $objname\_$obs\_DA.qdp >> /tmp/namprov
echo $objname\_$obs\_DA.eps >> /tmp/namprov 

more /tmp/namprov
mv /tmp/namprov FILES_DA_first.txt

}


}
