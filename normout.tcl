proc normout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#normout 5 --OR-- normout 5 0 1 0

#Normally, this will be the power law norm for trans of Z-mytorus (zpowerlw)
#But, aar number is needed, as there could be more in model

#type is used for final filename

tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type trans
puts "type $type"
}

if { [string first "mytorus" $xspec_tclout] > 0 } {
set type myun
puts "type $type"
}

#Always not frozen:
#Check if error calculation to be done (ie Zfe != 10 for type trans)

tclout param $par
scan $xspec_tclout "%f" parval

scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > Norm_$type.txt"
} else {

exec echo normout $par $predelta $uponly $doonly > "normout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt Norm_$type.txt
}

puts " "
exec more Norm_$type.txt
}

