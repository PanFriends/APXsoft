proc aout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#aout 5 --OR-- normout 5 0 1 0

#Normally, this will be As (=AL), but let's be clear by giving param number.

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
exec /bin/sh -c "echo $parval f > As_$type.txt"
}


if {$frozen == 0} {
puts "not frozen"
exec echo aout $par $predelta $uponly $doonly > "aout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt As_$type.txt
}

puts " "
exec more As_$type.txt
}

