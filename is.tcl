proc is {name par comp} {

    #is nh 5 4

    #Call par 5 "nh" and use this; save par and comp numbers

    exec echo $name $par $comp > ~/.xspec/$name.var
    tclout param $par
    scan $xspec_tclout "%f" val
    if {$val < 1e-2} {
	puts [format "%s %i %.5e    comp %i" $name $par $val $comp]
    } else {
	puts [format "%s %i %.5f    comp %i" $name $par $val $comp]
    }

}
