proc mobs {} {

#Simple multiobs PL fitting to test for variability

#Start in */COMB

    set name $::env(name[exec more stub.txt])

cd ".."
    set top [pwd]
    puts $top

#Make obs* dirs array
    set all [exec /bin/sh -c "ls | grep obs | grep -v Nobs" ] 

    foreach datum $all {
	lassign [split $datum \S+] v
lappend dirs $v
    } 

#There are $numdirs obs* dirs under $top
    set numdirs [llength $dirs]
    puts "$numdirs obsdirs"

#Go to each obsdir and load spectra - must do so that rsp read
set i 1
    foreach dir $dirs {
cd $top/$dir/ADD

	    data $i:$i [glob *heg*m1p1*b0100*pha]
ig $i:**-3. 6.2-7.2 8.-**
set i [expr $i+1]
}
 
#So that xcm file in COMB
cd $top/COMB

#phoindex and norm for each data group
set numpar [expr ($i-1)*2]

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

xlohi 3 8
#logoff


#tie indexes, free norms
model powerlaw
/*
set index 1.9
newpar 1 $index
newpar 2 1.0
freeze 1
for {set j 1} {$j < [expr $i-1] } {incr j} {
    newpar [expr $j*2+1] = 1
    newpar [expr $j*2+2] 1.0
}

addcomp 1 constant & 1
for {set j 1} {$j < [expr $i-1] } {incr j} {
    untie [expr $j*3+1] 
}

/*

fit
plot ratio

}
