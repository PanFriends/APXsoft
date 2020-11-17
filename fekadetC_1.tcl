proc fekadetC1 {} {

#This fully working version does no fitting though.

chatter 0
set with myun25_2.4_8.0.xcm
@$with

tclout stat
set cwith [scan [tcloutr stat] "%f"]

#Find number of MYTorusL comp
tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {

tclout compinfo $i
if { [string first "MYTorusL" $xspec_tclout] != -1 } {
#this is MYTorusL component number
set n_my $i 
}
}

set num [expr {$n_my-2}]

delcomp $num
delcomp $num
delcomp $num

fit 
svall without
#plot
#this25m without.xcm

tclout stat
set cwithout [scan [tcloutr stat] "%f"]
set out [open "DelC_Fe.txt" "w"]

puts $out "#with     without     deltaC"
puts $out [format "%.4f %.4f %.4f" $cwith $cwithout [expr {$cwithout-$cwith}]]
close $out

@$with

chatter 10
exec more DelC_Fe.txt





}
