proc stepw {par fname} {

#write out parameter stepped in a file fname
#          delstat

#param
tclout steppar $par

foreach datum $xspec_tclout {
    lassign [split $datum =]  v
    lappend parvalues $v\n
}

set fout [ open $fname "w" ]
puts $fout [join $parvalues ]

close $fout

#delstat
tclout steppar delstat

foreach datum $xspec_tclout {
    lassign [split $datum =]  d
    lappend delvalues $d\n
}

set fout [ open "delstat.txt" "w" ]
puts $fout [join $delvalues ]

close $fout

#statistic
tclout steppar statistic

foreach datum $xspec_tclout {
    lassign [split $datum =]  d
    lappend statvalues $d\n
}

set fout [ open "stepstat.txt" "w" ]
puts $fout [join $statvalues ]

close $fout






}
