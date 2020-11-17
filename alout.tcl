proc alout {par {predelta 0.1} {uponly 0} {doonly 0}} {

#alout 5 --OR-- normout 5 0 1 0

#This is only for when As frozen and need errors to use them
#for error in EW and line flux

#type is used for final filename

set type myun
puts "type $type"

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > Al_$type.txt"
}


if {$frozen == 0} {
puts "not frozen"
exec echo alout $par $predelta $uponly $doonly > "alout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt Al_$type.txt
}

puts " "
exec more Al_$type.txt
}

