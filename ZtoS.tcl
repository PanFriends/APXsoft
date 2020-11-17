proc ZtoS {} {

#ZtoS

#Find ratio of NH_Z to NH_S



tclout modcomp
set n_comp $xspec_tclout
for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i

if { [string first "MYtorusZ" $xspec_tclout] != -1 } {
scan $xspec_tclout "%s %i %i" name par npar
tclout param $par
scan $xspec_tclout "%e" nhz
puts "$par NH_Z $nhz"
} 
if { [string first "MYtorusS" $xspec_tclout] != -1 } {
scan $xspec_tclout "%s %i %i" name par npar
tclout param $par
scan $xspec_tclout "%e" nhs
puts "$par NH_S $nhs"
} 

}

set nhzTOnhs [ expr $nhz/$nhs ]
set nhsTOnhz [ expr $nhs/$nhz ]
puts [format "NH_z to NH_s %.4f %.4e" $nhzTOnhs $nhzTOnhs]
puts [format "NH_s to NH_z %.4f %.4e" $nhsTOnhz $nhsTOnhz]

set out [open "ZtoS.txt" "w"]
puts $out [format "%.4e" $nhzTOnhs ]
close $out
set out [open "StoZ.txt" "w"]
puts $out [format "%.4e" $nhsTOnhz ]
close $out
}

