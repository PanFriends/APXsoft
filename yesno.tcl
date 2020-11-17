proc yesno {model comp} {

#yesno with.xcm 4

#Test delchi with/without a component

@$model
fit
plot
tclout stat
scan $xspec_tclout "%f" chiwith

#Info on component for printing
tclout compinfo $comp
scan $xspec_tclout "%s %i" name param1
tclout param $param1
scan $xspec_tclout "%f" valparam1




delcomp $comp
plot
fit
plot
tclout stat
scan $xspec_tclout "%f" chiwithout

set diff [expr $chiwithout-$chiwith]
puts "With    $chiwith"
puts "Without $chiwithout"
puts [format  "Delchi2 with-without %.2f" $diff]

puts [format  "%s %.2f" $name $valparam1]

if {$diff > 6.63} {
puts "KEEP"
@$model
plot
} else { puts "DISCARD" }













}
