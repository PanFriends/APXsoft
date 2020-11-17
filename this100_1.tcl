proc this100 {} {

#Quick version of      plobnh 4u17 b0100
#Requires stub.txt in COMB directory
#Eg for 4U17   stub.txt contains just 4u17

    set name $::env(name[exec more stub.txt])

#To be read when this script ends
    set nh $::env(nh[exec more stub.txt])

set file_out [open "nh.txt" "w"]
puts $file_out "$nh"  
close $file_out

set data [exec /bin/sh -c "ls *b0100*addspec.pha" ]

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
