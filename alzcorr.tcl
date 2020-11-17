proc alzcorr {} {


#Make sure A_S unfrozen
#Make sure PL z is free and other are tied to IT.

#Find number of A_S component
#It's one down from MYtorusS   NH   
#
#Also:
#Find number of zpowerlw Redshift  param
#It's one up from *FIRST INSTANCE* of zpowerlw  cpt
#
#Find number of MYtorusS Redshift  param
#It's +3 from first
#Find number of MYtorusL Redshift  param
#It's +3 from first
#Find number of MYtorusZ Redshift  param
#It's +2 from first

tclout modcomp
set n_comp $xspec_tclout

for {set i 1} {$i <= $n_comp} {incr i} {

tclout compinfo $i
if { [string first "MYtorusS" $xspec_tclout] != -1 } {

#this is the A_S parameter number
scan $xspec_tclout "%s %i %i" name par npa
set n_A_S [expr $par-1] 
#this is the MYtorusS z par number
set n_myS_z [expr $par+3]
}

if { [string first "zpowerlw" $xspec_tclout] != -1 && [info exists n_zpl_z] == 0} {

#this is zpowerlw z parameter number
scan $xspec_tclout "%s %i %i" name par npa
set n_zpl_z [expr $par+1] 
}

if { [string first "MYTorusL" $xspec_tclout] != -1 } {

#this is MYtorusL z parameter number
scan $xspec_tclout "%s %i %i" name par npa
set n_myL_z [expr $par+3] 
}

#this is MYtorusZ z parameter number
if { [string first "MYtorusZ" $xspec_tclout] != -1 } {

#this is MYtorusL z parameter number
scan $xspec_tclout "%s %i %i" name par npa
set n_myZ_z [expr $par+2] 
}
}
puts "A_S is par $n_A_S"
puts "PL z  is par $n_zpl_z"
puts "MYZ z is par $n_myZ_z"
puts "MYS z is par $n_myS_z"
puts "MYL z is par $n_myL_z"

thaw $n_A_S
newpar $n_zpl_z 0
thaw $n_zpl_z
newpar $n_myZ_z = $n_zpl_z
newpar $n_myS_z = $n_zpl_z
newpar $n_myL_z = $n_myS_z

show all

puts "!!!!!!!!!!!!!!!!! FIT *AND* SAVE !!!!!!!!!!!!!!!!!!!!!!!!!"


















}
