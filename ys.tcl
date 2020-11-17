proc ys {center} {

#determine optimal y-scale limits

#file delete wrange.pco yrange.pco yrange.qdp

#set out [ open "wrange.pco" "w" ]
#puts $out "wenviron yrange"
#close $out

#setplot command @wrange

###################
# Fast ~good range

set fac 2.
 	set del [expr {$fac*$center}]

 #   if { $center > 1e-10} 
#x is likely energy
	set top [expr {$center+$del}]
        set bot [expr {$center-$del}]

ylohi $bot $top

plot

}
