proc icnt {} {

set xrbydir "/home/pana/DATA/XRBY/TGCAT/TORREJON/direct"

#cp/paste in temp the alias definitions in .bashrc; then
#gawk '{if($0~/[a-z]/) {print $3} }' temp | g" '{print $2}' | gawk -F"ADD" '{printf $1" "}'

set all " /4U1700m37/obs_657_tgid_3585/ /4U1822m371/obs_671_tgid_4350/ /4U1822m371/obs_9076_tgid_4121/ /4U1822m371/obs_9858_tgid_4137/ /4U1908p075/obs_5476_tgid_3929/ /4U1908p075/obs_5477_tgid_3931/ /4U1908p075/obs_6336_tgid_3968/ /CenXm3/obs_1943_tgid_3690/ /CenXm3/obs_705_tgid_3598/ /CenXm3/obs_7511_tgid_4068/ /CirXm1/obs_12235_tgid_4316/ /CirXm1/obs_1905_tgid_3663/ /CirXm1/obs_1906_tgid_3664/ /CirXm1/obs_1907_tgid_3665/ /CirXm1/obs_5478_tgid_3932/ /CirXm1/obs_706_tgid_3625/ /CirXm1/obs_8993_tgid_4117/ /CygXm1/obs_11044_tgid_4258/ /CygXm1/obs_12313_tgid_4320/ /CygXm1/obs_12314_tgid_4318/ /CygXm1/obs_12472_tgid_4339/ /CygXm1/obs_13219_tgid_4338/ /CygXm1/obs_1511_tgid_4376/ /CygXm1/obs_2415_tgid_3739/ /CygXm1/obs_2741_tgid_3766/ /CygXm1/obs_2742_tgid_3768/ /CygXm1/obs_2743_tgid_3770/ /CygXm1/obs_3407_tgid_3824/ /CygXm1/obs_3724_tgid_3850/ /CygXm1/obs_3814_tgid_3844/ /CygXm1/obs_8525_tgid_4092/ /CygXm1/obs_9847_tgid_4134/ /CygXm3/obs_101_tgid_4343/ /CygXm3/obs_6601_tgid_3983/ /CygXm3/obs_7268_tgid_4032/ /gamCas/obs_1895_tgid_3661/ /GX301m2/obs_103_tgid_3535/ /GX301m2/obs_2733_tgid_3763/ /GX301m2/obs_3433_tgid_3798/ /GX1p4/obs_2710_tgid_3765/ /GX1p4/obs_2744_tgid_3767/ /HerXm1/obs_2703_tgid_3758/ /HerXm1/obs_2704_tgid_3762/ /HerXm1/obs_2705_tgid_3760/ /HerXm1/obs_2749_tgid_3772/ /HerXm1/obs_3821_tgid_3846/ /HerXm1/obs_3822_tgid_3847/ /HerXm1/obs_4375_tgid_3858/ /HerXm1/obs_4585_tgid_3887/ /HerXm1/obs_6149_tgid_3948/ /HerXm1/obs_6150_tgid_3949/ /LMCXm4/obs_9571_tgid_4126/ /LMCXm4/obs_9573_tgid_4127/ /LMCXm4/obs_9574_tgid_4129/ /OAO1657m415/obs_12460_tgid_4454/ /OAO1657m415/obs_1947_tgid_3683/ /VelaXm1/obs_102_tgid_3529/ /VelaXm1/obs_14654_tgid_14654/ /VelaXm1/obs_1926_tgid_3681/ /VelaXm1/obs_1927_tgid_4659/ /VelaXm1/obs_1928_tgid_3676/ "

foreach datum $all {
    lassign [split $datum \S+] v
lappend dirs $v
}

    set numdirs [llength $dirs]
    puts "$numdirs obsdirs"

#Go to each obsdir and load spectra - must do so that rsp read
    foreach dir $dirs {
cd $xrbydir/$dir/ADD



set quickname [exec more stub.txt]
set m1p1 [exec /bin/sh -c "ls *heg_m1p1_b0100.pha" ]
set m1 [exec /bin/sh -c "ls *heg_m1_b0100.pha" ]
set   p1 [exec /bin/sh -c "ls *heg_p1_b0100.pha" ]

data $m1p1
ignore **-1. 8.-**
tclout rate 1
scan $xspec_tclout "%f" rate
tclout expos 1
scan $xspec_tclout "%f" expo
set cm1p1 [expr $rate*$expo]

data $m1
ignore **-1. 8.-**
tclout rate 1
scan $xspec_tclout "%f" rate
tclout expos 1
scan $xspec_tclout "%f" expo
set cm1 [expr $rate*$expo]

data $p1
ignore **-1. 8.-**
tclout rate 1
scan $xspec_tclout "%f" rate
tclout expos 1
scan $xspec_tclout "%f" expo
set cp1 [expr $rate*$expo]

set sum [expr $cm1+$cp1]

set out [ open "/home/pana/notes/HETXRB/cnt_4_sel.txt" "a" ]
puts $out [format "%s %.2e %.2e %.2e %.2e" $quickname $cm1p1 $sum $cm1 $cp1 ]
close $out

}


exec more /home/pana/notes/HETXRB/cnt_4_sel.txt







}
