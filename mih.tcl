proc mih {} {

#For Mihoko and Antara, Wed Sep 2 2015

    set num 10
    for {set i 6} {$i <= $num} {incr i} {

    set spec "0.3-2.0_1000ct_$i.fak"
    set grp  "0.3-2.0_1000ct_$i.fak.1.grp"
exec grppha  $spec $grp comm = "group min 1 & exit"


data $grp
ignore **-0.3 2.0-**
statistic cstat
@fit_OIII.xcm
fit
fit
error 1.0 1 2 7 17 18 19 20
save all $i.OIII_fit.xcm

# Open the file to put the results in.



set fileid [open OIII.fits.$i.txt w]
tclout param 1
  puts $fileid "1p [lindex $xspec_tclout ]"
tclout param 2
  puts $fileid "2p [lindex $xspec_tclout ]"
tclout param 7
  puts $fileid "7p [lindex $xspec_tclout ]"
tclout param 17
  puts $fileid "17p [lindex $xspec_tclout ]"
tclout param 18
  puts $fileid "18p [lindex $xspec_tclout ]"
tclout param 19
  puts $fileid "19p [lindex $xspec_tclout ]"
tclout param 20
  puts $fileid "20p [lindex $xspec_tclout ]"
tclout error 1
  puts $fileid "1e [lindex $xspec_tclout ]"
tclout error 2
  puts $fileid "2e [lindex $xspec_tclout ]"
tclout error 7
  puts $fileid "7e [lindex $xspec_tclout ]"
tclout error 17
  puts $fileid "17e [lindex $xspec_tclout ]"
tclout error 18
  puts $fileid "18e [lindex $xspec_tclout ]"
tclout error 19
  puts $fileid "19e [lindex $xspec_tclout ]"
tclout error 20
  puts $fileid "20e [lindex $xspec_tclout ]"

tclout stat
  puts $fileid "stat [lindex $xspec_tclout ]"
tclout dof
  puts $fileid "dof [lindex $xspec_tclout ]"
tclout rate 1
  puts $fileid "rate [lindex $xspec_tclout ]"
tclout expos
  puts $fileid "exp [lindex $xspec_tclout ]"
# Close the file.
close $fileid

puts "done $i"

}

}
