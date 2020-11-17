proc fekadetC {} {


#po+zgauss over a limited range to assess effect of removing/adding line
#Use myun25 best fit line parameters as guesses

chatter 0
@myun25_2.4_8.0.xcm 
rig 6. 6.5

#Identify parameters to use as guesses

findncomp MYtorusS
set npar1 [exec more npar1.txt]
set n_myS_z [expr {$npar1+3}]
tclout param $n_myS_z
scan $xspec_tclout "%f" myS_z

set n_myS_norm [expr {$npar1+4}]
tclout param $n_myS_norm
scan $xspec_tclout "%f" myS_norm

file delete npar1.txt

findncomp gsmooth
set n_sig [exec more npar1.txt]
tclout param $n_sig
scan $xspec_tclout "%f" sig

file delete npar1.txt
 
findncomp zpowerlw
set npar1 [exec more npar1.txt]
set n_phoZ $npar1
set n_normZ [expr {$npar1+2}]

tclout param $n_phoZ
scan $xspec_tclout "%f" phoZ

tclout param $n_normZ
scan $xspec_tclout "%f" normZ

file delete npar1.txt


model po+zgauss & $phoZ & $normZ & 6.404 & $sig & $myS_z & $myS_norm

    set z1 [expr -5e-3] 
    set z2 [expr -1e-3]
    set z3 [expr +1e-3]
    set z4 [expr +5e-3]

    set sig1 [expr 0]
    set sig2 [expr 0]
    set sig3 [expr 0.1]
    set sig4 [expr 0.1]

#Line energy
freeze 3

#redshift line
thaw 5
newpar 5 ,,, $z1 $z2 $z3 $z4
#sig line
newpar 4 ,,, $sig1 $sig2 $sig3 $sig4

#chatter 10
show
fit 100000
tclout stat
scan $xspec_tclout "%f" cwith
plot
chatter 10
show
puts "continue?"
set ans [gets stdin]
chatter 0

delcomp 2
fit 100000
tclout stat
scan $xspec_tclout "%f" cwithout
plot
chatter 10
show


puts "WITH    WITHOUT"
puts "$cwith $cwithout"
set delc [expr $cwithout-$cwith]
set out [ open "DelC_gauss.txt" "w" ]
puts $out "#cwith cwithout delc"
puts $out [format "%.4f %.4f %.4f" $cwith $cwithout $delc]
close $out

chatter 10
more DelC_gauss.txt







}
