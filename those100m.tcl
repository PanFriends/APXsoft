proc those100m {args} {

#For MULTIPLE observations, run in single obs*/ADD dir
#stub.txt must exist in obs*/ADD dir
#Copies nh.txt from COMB dir

#Quick version of      plobnh 4u17 b0100
#Requires stub.txt in ADD directory
#Eg for 4U17_1   stub.txt contains just 4u17

#optional arguments are
#    model.xcm to plot just that
#    ylow value to plot

    switch -exact [llength $args] {
        0 {puts "no xcm file"}
        1 {@[lindex $args 0]}
        2 {@[lindex $args 0]}
    }




    set name $::env(name[exec more stub.txt])

#To be read when this script ends
#    exec cp ../../COMB/nh.txt .
    set nh [exec more nh.txt]


set data1 [exec /bin/sh -c "ls *heg_m1_b0100.pha" ]
set data2 [exec /bin/sh -c "ls *heg_p1_b0100.pha" ]

data $data1 $data2
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


if {[llength $args] >= 1} {@[lindex $args 0]}
plot
if {[llength $args] == 2} {
set ylo [lindex $args 1]
ylow $ylo}

}
