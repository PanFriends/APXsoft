proc qls {par delta {niter 5}} {

#Run qs.tcl FROM last best fit value up to...
#range variable

tclout param $par
scan $xspec_tclout "%f" parval

set lo [exec /bin/sh -c "flosplit2 $parval d $delta"]
qs $par $parval $lo $niter

}
