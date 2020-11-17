proc bsig {parnum hisig} {

#Broaden the allowd limits for sigma


tclout param $parnum
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max
set losig [expr $value-$hisig+$value]
newpar $parnum $value 0.05 $losig $losig $hisig $hisig

}
