proc mp25 {ylo yhi} {

#for b0025 observations in one dir
set name $::env(name[exec more stub.txt])

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
setplot command label title $name
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
