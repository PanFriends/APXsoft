proc p1m1 {num} {

#p1m1 0025

#eg for data GX301m2_3433_heg_m1_b0025.pha GX301m2_3433_heg_p1_b0025.pha

#Plot +1 -1 order around 6.4 keV, mainly for GX301 HEG spectra
#to check for offset and corrections

set name $::env(name[exec more stub.txt])
set data1 [exec /bin/sh -c "ls *heg_m1_b*$num*.pha" ]
set data2 [exec /bin/sh -c "ls *heg_p1_b*$num*.pha" ]


#set data [ glob *heg_m1_b$num.pha *heg_p1_b$num.pha ]

data $data1 $data2
cpd /xs
setplot command lw 5
setplot command lw 5 on 1
setplot command lw 5 on 2
setplot command label title $name
setplot command time off
setplot energy
xlohi 6.3 6.5
logoff
plot

}
