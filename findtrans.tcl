proc findtrans {} {

#findtrans

#Find trans PhoIndex and norm values
#Set up powerlaw just with these

#NB trans params always are:
#   trans      nH          
#   trans      PhoIndex    
#   trans      Fe abund.   
#   trans      abund.      
#   trans      z           
#   trans      norm        


#Called by sphline.tcl

tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "trans" $xspec_tclout] != -1 } {
#this is trans cpt number
scan $xspec_tclout "%s %i %i" name npar1 npars

#number of first trans param is $npar1; hence
set n_phoIndex [expr $npar1+1]
set n_norm [expr $npar1+5]
puts "phoIndex is par $n_phoIndex"
puts "norm is par $n_norm"
}

}

tclout param $n_phoIndex
scan $xspec_tclout "%f" phoIndex
tclout param $n_norm 
scan $xspec_tclout "%e" norm

model powerlaw & $phoIndex & $norm




}
