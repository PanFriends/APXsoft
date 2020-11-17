proc is {name par} {

    #is nh 5

    #Call par 5 "nh" and use this

    exec echo $name $par > ~/.xspec/$name.var
    tclout param $par
    scan $xspec_tclout "%f" val
    if {$val < 1e-2} {
	puts [format "%s %i %.5e" $name $par $val]
    } else {
	puts [format "%s %i %.5f" $name $par $val]
    }

}
