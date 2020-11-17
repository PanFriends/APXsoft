proc sfin {} {

#name strings
set objname [exec more stub.txt]
set obs $::env(otex[exec more stub.txt])
set obs [lindex [split $obs ~] 2]

#my or sph?
tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type "sph"
} else {
set type "myun"
}

tclout noticed energy
set out [open "noticed.txt" "w"]
puts $out $xspec_tclout
close $out
exec noticed_energy.sh noticed.txt

#scan $xspec_tclout "%f-%f" lo  hi

#puts [format "%.1f" $lo]
#set slo [format "%.1f" $lo]
#set shi [format "%.1f" $hi]
set slo [exec more TEMP_noticed_lo.txt]
set shi [exec more TEMP_noticed_hi.txt]

set t1 "25_"
set t2 "_"
set t3 ".xcm"
set name $type$t1$slo$t2$shi$t3

echo $slo $shi > band.txt

puts "save all $name"
save all $name

#For TY
exec cp $name $objname\_$obs\_$name
exec tablepath $objname\_$obs\_$name

echo $objname\_$obs\_$name > FILES_sfin_$type.txt

file delete noticed.txt TEMP_noticed_lo.txt TEMP_noticed_hi.txt
}
