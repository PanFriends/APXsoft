proc plonh {arg1 arg2} {

#plobnh 4u17 b0100

set name $::env(name$arg1)

#To be read when this script ends
set nh $::env(nh$arg1)
set file_out [open "nh.txt" "w"]
puts $file_out "$nh"  
close $file_out

set data [exec /bin/sh -c "ls *$arg2*addspec.pha" ]

data $data
method leven 1000 0.0001
setplot rebin 1 1
setplot energy
statistic chi
cpd /xs
setplot add
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $name
setplot command time off
plot ld ratio

}
