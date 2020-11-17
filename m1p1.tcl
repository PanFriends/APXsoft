proc m1p1 {ylo yhi} {

#(For HETAGN)
#

    set top [exec /bin/sh -c "pwd"]
    set quickname1 [exec /bin/sh -c "basename `pwd`"]
    puts "$quickname1"
    set all [exec /bin/sh -c "ls -d obs*"]

    foreach datum $all {
	lassign [split $datum \S+] v
lappend obses $v
    }

    set numobses [llength $obses]
    puts "$numobses obsdirs"


    foreach obs $obses {

    cd $top/$obs
    set quickname2 [exec /bin/sh -c "basename `pwd`"]
    cd $top/$obs/ADD

set data1 [exec /bin/sh -c "ls *heg_m1_b0025.pha" ]
set data2 [exec /bin/sh -c "ls *heg_p1_b0025.pha" ]

data $data1 $data2
method leven 1000 0.0001
setplot rebin 1 1
setplot energy
statistic chi
cpd /xs
#setplot add


set nlo $ylo
set nhi $yhi
while {$nlo != 88} {


setplot command lw 5
setplot command lw 5 on 2
setplot command label title $quickname1 $quickname2
setplot command time off
model powerlaw & 1.7 & 1

xlohi 6. 7.
ylohi $ylo $yhi

logoff

plot ufspec

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

}



}



cd $top








}
