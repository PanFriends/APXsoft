proc feout {{predelta 0.1} {uponly 0} {doonly 0}} {

#feout --OR-- zlout 0 1 0

#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    #Iterate through components to find trans Fe abund
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_trans $i
	    puts "trans is comp $n_trans"
	    tclout compinfo $n_trans
	    scan $xspec_tclout "%s %i %i" name parstart npars
	    set par [expr $parstart+2]
	    puts "Fe par is $par"
	}
    }
 
    }


#Check if Zfe = 10 Zsun
#If so, write Fe_trans.txt with no errors;
#This will be flag for other files to be written with no errors either.

tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max
    if {$value == 10.0} {
set out [open "Fe_$type.txt" "w"]
puts $out [format "%.2f 0 0 0 0 " $value]

close $out } else {

exec echo feout $predelta $uponly $doonly > "feout_Call_$type.txt"

if {[file exists "ULs$par.txt"]==1} {
set doonly 1 
}
if {[file exists "LLs$par.txt"]==1} {
set uponly 1 
}


errout $par $predelta $uponly $doonly
exec cp errout.txt Fe_$type.txt

}

puts " "
exec more Fe_$type.txt
}




