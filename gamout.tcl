proc gamout {par {predelta 0.1} {uponly 0} {doonly 0} } {

#gamout 5 --OR-- gamout 5 0 1 0

#The parameter number must be provided as there could be several power laws.

#type is used for final filename

tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type trans
puts "type $type"
#But is it the trans power law or the "other" power law (distant thin)?
    if {[file exists tgamout.txt]==1} {
	set suffixin [exec more tgamout.txt]
	file delete tgamout.txt
    } else {
puts "s or o?"
set ans [gets stdin]
scan $ans "%s" suffixin
}

set type $suffixin\_trans
set suffix [string toupper $suffixin]

puts $type

}


    
if { [string first "mytorus" $xspec_tclout] > 0 } {
set type myun
puts "type $type"
#But is it the zeroth power law or the S or the "other" power law (distant thin)?
    if {[file exists tgamout.txt]==1} {
	set suffixin [exec more tgamout.txt]
	file delete tgamout.txt
    } else {
puts "z / s / o?"
set ans [gets stdin]
scan $ans "%s" suffixin
}

set type $suffixin\_myun
set suffix [string toupper $suffixin]

puts $type

}

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > G_$type.txt"
}

if {$frozen == 0} {
puts "not frozen"

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "$suffixin\_trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > G_$type.txt"
} else {

exec echo gamout $par $predelta $uponly $doonly > "gamout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt G_$type.txt
}
}

puts " "
exec more G_$type.txt
}
