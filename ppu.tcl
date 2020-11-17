proc ppu {co pa {niter 5}} {

#Like qu
#Run qs.tcl FROM last best fit value up to...

#Find param number
fpar $co $pa
set par [exec more npar.txt]
tclout param $par
scan $xspec_tclout "%f" parval

set hi [exec /bin/sh -c "flosplit $parval u"]
qs $par $parval $hi $niter

file delete npar.txt

}
