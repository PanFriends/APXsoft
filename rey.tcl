proc rey {type} {

#rey [ufspec]

#Intelligent y re-scale

#As only noticed range can be used, must:
# switch noticed to that from TEMP_xlow.txt TEMP_xhi.txt
# When done, revert



tclout noticed energy
scan $xspec_tclout "%f-%f" nlo nhi

set temp_lo [exec more TEMP_xlow.txt]
set temp_hi [exec more TEMP_xhi.txt]

rig $temp_lo $temp_hi

tclout plot $type y
set out [ open "prov.txt" "w" ]
puts $out "$xspec_tclout"
close $out

tclout plot $type yerr
set out [ open "provyerr.txt" "w" ]
puts $out "$xspec_tclout"
close $out


#This finds the min and max for y, given the x-range,
#and the corresponding errors.
scan [ exec /bin/bash -c "min2string.bash prov.txt provyerr.txt" ] "%f %f" a b
set bot [expr $a-2.*$b]
scan [ exec /bin/bash -c "max2string.bash prov.txt provyerr.txt" ] "%f %f" a b
set top [expr $a+2.*$b]

puts [format "bot %.6f" $bot]
puts [format "top %.6f" $top]

#Plot ymin (-its error)   to     ymax (+its error)
ylohi $bot $top

#Revert to original noticed
rig $nlo $nhi

file delete prov.txt provyerr.txt

}
