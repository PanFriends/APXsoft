proc zlout {{predelta 0.1} {uponly 0} {doonly 0}} {

#zlout --OR-- zlout 0 1 0

    tclout modcomp
    set n_comp $xspec_tclout
 
#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type trans
	puts "type $type"
	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+4}]
	puts "z par is $par_z"
	}

#for
	} 

#if sphere
}


    if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
	puts "type $type"
	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first MYtorusS $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+3}]
	puts "z par is $par_z"
	}

#for
	} 

#if mytorus
}


#Check if frozen
frcheck $par_z
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par_z
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > zl_$type.txt"
}

if {$frozen == 0} {
puts "not frozen"

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par_z
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > zl_$type.txt"
} else {

#z needs a different slope threshold for interpolation
#Write a file, if it exists this is used by errout.tcl
exec echo zslope > "zslope.txt"
exec echo zlout $predelta $uponly $doonly > "zlout_Call_$type.txt"
errout $par_z $predelta $uponly $doonly
exec cp errout.txt zl_$type.txt
file delete "zslope.txt"

}
}

puts " "
exec more zl_$type.txt
}
