proc normlineout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#normlineout 5 --OR-- normout 5 0 1 0

#This is a combination of normout and lineout, for the norm of extra gaussians.


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

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > Norm_Line{$par}_$type.txt"
} else {

exec echo normlineout $par $predelta $uponly $doonly > normlineout_Call_{$par}_$type.txt
errout $par $predelta $uponly $doonly
exec cp errout.txt Norm_Line{$par}_$type.txt
}

puts " "
exec more Norm_Line{$par}_$type.txt
}

