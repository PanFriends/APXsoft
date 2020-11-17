proc statout {} {

#output statistics for a fit

    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type sph
    }
    if { [string first "mytorus" $xspec_tclout] > 0 } {
    set type myun
    }



tclout stat
#scan $xspec_tclout "%f" cash
#tclout stat test
scan $xspec_tclout "%f" cash

tclout dof
scan $xspec_tclout "%i" dof

#tclout nullhyp
#scan $xspec_tclout "%f" prob




set out [ open "stat_$type.txt" "w" ]
#puts $out "#cash dof prob"
#puts $out "$cash $dof $prob"
puts $out "#cash dof "
puts $out "$cash $dof "

close $out
exec /bin/sh -c "more stat_$type.txt"
}
