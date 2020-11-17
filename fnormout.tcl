proc fnormout {par {predelta 0} {uponly 0} {doonly 0}} {

#fnormout 5 --OR-- normout 5 0 1 0

#This is for the "soft"/distant "thin" or in gen extra power law

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

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > Norm_o_$type.txt"
}

if {$frozen == 0} {exec echo normout $par $predelta $uponly $doonly > "normout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt Norm_o_$type.txt
}

puts " "
exec more Norm_o_$type.txt
}

