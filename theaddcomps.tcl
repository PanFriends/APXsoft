proc theaddcomps {var} {

    foreach datum $var {
	lassign [split $datum "+"] v
	lappend comps $v
	
    }
    puts $comps
    puts [llength $comps]
    puts [lindex $comps 0]
}
