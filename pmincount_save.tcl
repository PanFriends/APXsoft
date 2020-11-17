proc pmincount {min} {

#Plot to decide on region above 20 counts/bin




set name $::env(name[exec more stub.txt])
set data [exec /bin/sh -c "ls *heg_m1p1_b0100.pha" ]

data $data
setplot rebin 1 1
setplot channel
cpd /xs
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $name
setplot command time off
plot counts
ylohi $min 50

puts $data
}
