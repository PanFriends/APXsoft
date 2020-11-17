proc ffrac {a b} {

    if {$a == 0} {
	return 0.0
    } else {
	return [expr ($b-$a)/$a]
    }
}
