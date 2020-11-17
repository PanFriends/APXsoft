proc tnoerr {} {

#sph Fe Ab = 10 → NO ERRORS ON ANY PARAMETERS (eg Cyg X-1)

#Will always do:
feout
tsig
zlout
nhout
tgamout
tnormout

#Might not need to do:
tfscout
ogamout

#All gaussians?
tclout modcomp
set n_comp $xspec_tclout

for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
scan $xspec_tclout "%s %i %i" name npar1 npars
if { [string equal "gaussian" $name] == 1 } {
    set npar2 [expr $npar1+1]
    set npar3 [expr $npar1+2]
lineout $npar1
siglineout $npar2
normlineout $npar3
}
}

}
