proc intro {args} {

#arguments can be xcm file and ylow

    switch -exact [llength $args] {
        0 {@[lindex $args 0]}
        1 {@[lindex $args 0]}
    }

#always an xcm file
    set infile [lindex $args 0]
if {[llength $args] == 2} {
set ylo [lindex $args 1]
}

@$infile
if {[llength $args] == 2} {
this100 $infile $ylo
} else {
this100 $infile
}
@$infile
plot
}



