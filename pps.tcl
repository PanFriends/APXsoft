proc pps {co pa lo hi {niter 5}} {

#Like qs
#Run qs.tcl from lower val TO last best fit 

#Find param number
fpar $co $pa
set par [exec more npar.txt]

qs $par $lo $hi $niter

file delete npar.txt

}
