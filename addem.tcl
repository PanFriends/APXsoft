proc addem {compnum energy sig losig} {

#adem 2 6.63 1e-3 1e-6

#Add emission gaussian with reasonable ranges for energy and sigma

set lowen [expr $energy-0.02]
set hien [expr $energy+0.02]

#Hi sig limit is symmetric to losig wrt sig
set hisig [expr $sig+$sig-$losig]


addcomp $compnum gauss & $energy & $sig & .001

#First par info for this new component
tclout compinfo $compnum
scan $xspec_tclout "%s %i %i" name energynum totnum
set signum [expr $energynum+1]

#Energy range
newpar $energynum $energy 0.05 $lowen $lowen $hien $hien

#Sig range
newpar $signum $sig 0.05 $losig $losig $hisig $hisig


plot
}
