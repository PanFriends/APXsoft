proc nfreeze {args} {

#nfreeze 23 24 25
#freeze all EXCEPT these parameters

tclout modpar
scan $xspec_tclout "%i" npars

#Freeze all
#iterate through all parameters to find this one
chatter 0
for {set j 1} {$j <= $npars} {incr j} {
freeze $j
}

#Now thaw just the arguments given

    for {set i 0} {$i < [llength $args]} {incr i} {

	puts "thaw [lindex $args $i]"
	thaw [lindex $args $i]



    }



chatter 10
show

#Output frozen numbers
puts "Later:"
puts -nonewline "thaw "
for {set j 1} {$j <= $npars} {incr j} {
tclout param $j
scan $xspec_tclout "%f %f" one two
        if {$two < 0} {
	puts -nonewline [format " %i " $j] 
}

}
puts " "

}
