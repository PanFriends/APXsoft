proc xlohi {args} {


if {[llength $args] == 0} {

#back to full extent
tclout noticed energy
set out [open "noticed.txt" "w"]
puts $out $xspec_tclout
close $out
exec noticed_energy.sh noticed.txt
set lo [exec more TEMP_noticed_lo.txt]
set hi [exec more TEMP_noticed_hi.txt]

file delete noticed.txt TEMP_noticed_lo.txt TEMP_noticed_hi.txt
} else { 
set lo [lindex $args 0]
set hi [lindex $args 1]
}

setplot command window 1
setplot command re x $lo $hi
plot

#Write out
set out [open "TEMP_xlow.txt" "w"]
puts $out [format "%f" $lo]
close $out
set out [open "TEMP_xhi.txt" "w"]
puts $out [format "%f" $hi]
close $out


}
