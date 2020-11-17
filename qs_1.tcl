proc qs {par lo hi} {

#Quick steppar with memory
#Ends when $lo=0

set i 10
    while {$lo != 0} {
	steppar $par $lo $hi $i
	plot contour
	puts [format "more? (%.3e %.3e %i -- 0 ends)" $lo $hi $i]
	set ans [gets stdin]
	scan $ans "%f %f %i" lo hi i
    }












}
