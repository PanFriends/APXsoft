proc NHgal_nof {{predelta 0.1} {uponly 0} {doonly 0}} {

#NHgal_nof 0 1 0

#Check if NH_gal is free, so error required - can be sph or myt

#STILL DO IF FROZEN

tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type trans
} else {
set type myun
}
puts "type $type"

#NHgal should be the top phabs - always there.
#If not frozen continue
frcheck 1
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "NH_gal frozen"
thaw 1
} else {
puts "NH_gal not frozen"
}

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param 1
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > NH_gal_$type.txt"
} else {


if {[string equal -nocase "trans" $type] == 1 && [file exists "ULs1.txt"]==1} {
set doonly 1 
}
if {[string equal -nocase "myun" $type] == 1 && [file exists "ULm1.txt"]==1} {
set doonly 1 
}

exec echo NHgal $predelta $uponly $doonly > "NHgal_Call_$type.txt"
errout 1 $predelta $uponly $doonly
#Units are 1e22
exec cp errout.txt NH_gal_$type.txt

}

#Refreeze?
if {$frozen == 1} {
puts "refreezing"
freeze 1
}

puts " "
more NH_gal_$type.txt




    









#convert units to 1e-24 for compatibility with NHz

}
