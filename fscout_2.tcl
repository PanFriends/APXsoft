proc fscout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#aout 5 --OR-- normout 5 0 1 0

#This is essentially identical to aout.tcl. The output file is different.

#Normally, this is the last const appearing, but let's be clear by giving param number.

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

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > Fs_$type.txt"
}


if {$frozen == 0} {
puts "not frozen"

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > Fs_$type.txt"
} else {

exec echo fscout $par $predelta $uponly $doonly > "fscout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt Fs_$type.txt
}
}

puts " "
exec more Fs_$type.txt
}

