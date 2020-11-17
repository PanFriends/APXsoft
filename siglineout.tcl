proc siglineout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#lineout 5 --OR-- normout 5 0 1 0

#This is essentially identical to fscout.tcl. The output file is different.

#this is the gaussian LineE parameter for extra gaussians

#type is used for final filename

#Predelta variable is used as offset in errout, because lines c-stat
#rises very quickly

tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type trans
puts "type $type"
}

if { [string first "mytorus" $xspec_tclout] > 0 } {
set type myun
puts "type $type"
}

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > Sig_Line{$par}_$type.txt"
}


if {$frozen == 0} {
puts "not frozen"

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > Sig_Line{$par}_$type.txt"
} else {

exec echo lineout $par $predelta $uponly $doonly > lineout_Call_{$par}_$type.txt
errout $par $predelta $uponly $doonly
exec cp errout.txt Sig_Line{$par}_$type.txt
}
}

puts " "
exec more Sig_Line{$par}_$type.txt
}

