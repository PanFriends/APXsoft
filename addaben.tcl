proc addaben {compnum energy sig losig strength} {

#addab 2 6.67 1e-3 1e-6 0.1

#Add absorption gaussian with reasonable ranges for energy and sigma

set lowen [expr $energy-0.02]
set hien [expr $energy+0.02]

#Hi sig limit is symmetric to losig wrt sig
set hisig [expr $sig+$sig-$losig]

addcomp $compnum gabs & $energy & $sig & $strength

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
