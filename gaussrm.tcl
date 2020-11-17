proc gaussrm {} {

#gaussrm

#Find and delete up to FOUR gaussian components

#Called by sphline.tcl


#Find number of gaussian comp
#Note this will only find up to 4 gaussians

set n_g 0

#1
tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "gaussian" $xspec_tclout] != -1 } {
#this is gaussian component number
set n_g $i
puts "gaussian is comp $n_g"
}
}
if {$n_g > 0} {
puts "delcomp $n_g"
delcomp $n_g
set n_g 0
}

#2
tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "gaussian" $xspec_tclout] != -1 } {
#this is gaussian component number
set n_g $i
puts "gaussian is comp $n_g"
}
}
if {$n_g > 0} {
puts "delcomp $n_g"
delcomp $n_g
set n_g 0
}

#3
tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "gaussian" $xspec_tclout] != -1 } {
#this is gaussian component number
set n_g $i
puts "gaussian is comp $n_g"
}
}
if {$n_g > 0} {
puts "delcomp $n_g"
delcomp $n_g
set n_g 0
}

#4
tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
if { [string first "gaussian" $xspec_tclout] != -1 } {
#this is gaussian component number
set n_g $i
puts "gaussian is comp $n_g"
}
}
if {$n_g > 0} {
puts "delcomp $n_g"
delcomp $n_g
set n_g 0
}




}
