proc nhout {{predelta 0.1} {uponly 0} {doonly 0}} {

#nhout --OR-- zlout 0 1 0


#type is used for final filename

    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"



    #Iterate through components to find trans NH
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {
	    #this is trans component number
	    set n_trans $i
	    puts "trans is comp $n_trans"
	    tclout compinfo $n_trans
	    scan $xspec_tclout "%s %i %i" name par npars
	    puts "NH par is $par"

            if {[file exists "ULs$par.txt"]==1} {
            set doonly 1 
            }
            if {[file exists "LLs$par.txt"]==1} {
            set uponly 1 
            }

	}
    }
 
    }

    
    if { [string first "mytorus" $xspec_tclout] > 0 } {
	#Is this s  or   z   NH?
	if {[file exists tgamout.txt]==1} {
	set suffixin [exec more tgamout.txt]
	file delete tgamout.txt
    } else {
    puts "s or z?"
    set ans [gets stdin]
    scan $ans "%s" suffixin
    }

    set type $suffixin\_myun
    set suffix [string toupper $suffixin]
    set mycomp "MYtorus$suffix"

    puts $type
    puts $mycomp





#Iterate through components to find MYtorus$suffix
    tclout modcomp
    set n_comp $xspec_tclout
    for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first $mycomp $xspec_tclout] != -1 } {
	    #this is component number
	    set n_my $i
	    puts "$mycomp is comp $n_my"
	    tclout compinfo $n_my
	    scan $xspec_tclout "%s %i %i" name par npars
	    puts "NH par is $par"
            if {[file exists "ULm$par.txt"]==1} {
            set doonly 1 
            }
            if {[file exists "LLm$par.txt"]==1} {
            set uponly 1 
            }
	}
    }
}

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval f > NH_$type.txt"

#Correct units
if { [string first "myun" $type] > 0 } {
set cparval [expr $parval*100.]
exec /bin/sh -c "echo $cparval f > NH_$type.txt" }
}

puts "HERE"
if {$frozen == 0} {
    puts "not frozen"
}

if {$frozen == 0 && [file exists "Fe_trans.txt"] == 1} {
puts "not frozen"

#Check if error calculation to be done (ie Zfe != 10 for type trans)
scan [exec more Fe_trans.txt] "%f %f %f %f %f" a b c d e
if {[string equal -nocase "trans" $type] == 1 && $a == 10.0} {
tclout param $par
scan $xspec_tclout "%f" parval
exec /bin/sh -c "echo $parval 0 0 0 0 > NH_$type.txt"
} elseif {$frozen == 0} {

puts "TYPE $type"
puts "UPONLY $uponly"

exec echo nhout $predelta $uponly $doonly > "nhout_Call_$type.txt"
errout $par $predelta $uponly $doonly
exec cp errout.txt NH_$type.txt

#If mytorus, fix units so that in 10^22cm-2
if { [string first "myun" $type] > 0 } {
exec /bin/sh -c  "myunits.sh NH_$type.txt"
}
}
}
puts " "
exec more NH_$type.txt
}

