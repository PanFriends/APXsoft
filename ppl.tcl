proc ppl {co pa {niter 5}} {

#Like ql
#Run qs.tcl from lower val TO last best fit 

#Find param number
fpar $co $pa
set par [exec more npar.txt]
tclout param $par
scan $xspec_tclout "%f" parval

set lo [exec /bin/sh -c "flosplit $parval d"]
qs $par $lo $parval $niter

file delete npar.txt

}
