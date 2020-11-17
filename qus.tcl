proc qus {par delta {niter 5}} {

#Run qs.tcl FROM last best fit value up to...
#range variable

tclout param $par
scan $xspec_tclout "%f" parval

set hi [exec /bin/sh -c "flosplit2 $parval u $delta"]
qs $par $parval $hi $niter

}
