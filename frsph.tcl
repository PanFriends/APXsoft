proc frsph {} {

#Freeze only the default frozen in sph model

chatter 1


tclout modcomp
set n_comp $xspec_tclout
#Which is the last param number?
tclout compinfo $n_comp
scan $xspec_tclout "%s %i %i" name par npars
set parmax [expr {$par+$npars-1}]

#To begin, thaw all:
puts "thaw 1-$parmax"
thaw 1-$parmax

#Iterate to find components to freeze:
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
scan $xspec_tclout "%s %i %i" name par npars
    if { [string first phabs $xspec_tclout] != -1 } {
	puts "freeze phabs"
	freeze $par
    }
    if { [string first gsmooth $xspec_tclout] != -1 } {
	puts "freeze gsmooth Index"
	freeze [expr {$par+1}]
    }
    if { [string first trans $xspec_tclout] != -1 } {
	puts "freeze trans abundance"
	freeze [expr {$par+3}]
    }

}

chatter 10

}
