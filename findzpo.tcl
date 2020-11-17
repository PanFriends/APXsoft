proc findzpo {} {

#findzpo

#Find (first) zpowerlw PhoIndex and norm values
#Set up powerlaw just with these

#Uses fact that the opt. thin zpowerlw is put last to discard
#In this setting, there are at most 2 - but do for 3 and log them.

set npar1_1 0

tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "zpowerlw" $xspec_tclout] != -1 } {
#hold par1 number for first zpowerlw only
    if { $npar1_1 == 0 } {
scan $xspec_tclout "%s %i %i" name npar1_1 npars
    }
}
}
set n_phoIndex [expr $npar1_1]
set n_norm [expr $npar1_1+2]
puts "phoIndex is par $n_phoIndex"
puts "norm is par $n_norm"

tclout param $n_phoIndex
scan $xspec_tclout "%f" phoIndex
tclout param $n_norm 
scan $xspec_tclout "%e" norm

model powerlaw & $phoIndex & $norm

}
