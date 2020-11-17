proc fekadet {} {

#fekadet 

#Fit zpo and then zpo+zga to see if line detected

#In fact, load nofeka.xcm from previous fit.
#Only add a fixed line, refit, and compare chis.

#Save feka.xcm


@nofeka.xcm
this100m
@nofeka.xcm
set name $::env(name[exec more stub.txt])

#the alias for cd also useful to save
set quickname [exec more stub.txt]

plot ld ra
tclout stat
scan $xspec_tclout "%f" chino

set E 6.4
set sig 8.5e-4
set norm 0.001
addcomp 2 gauss & $E & $sig & $norm
freeze 2-3
plot

#Possibly change norm interactively
set new $norm
 while {$new != 0} {
    puts "norm? ($new, 0 to end)"
    set ans [gets stdin]
    scan $ans "%f" new
newpar 4 $new
plot
    }

fit
plot
tclout stat
scan $xspec_tclout "%f" chiyes
save all feka.xcm

set delchi [expr $chino-$chiyes]
set out [ open "Fe_delchi.txt" "w" ]
puts $out "#name chino chiyes delchi"
puts $out "$name $chino $chiyes $delchi"
close $out

puts "$name No $chino Yes $chiyes Delchi $delchi"

set out [ open "/home/pana/notes/HETXRB/Fe_det.txt" "a" ]
puts $out "$quickname $name $chino $chiyes $delchi"
close $out

puts "/home/pana/notes/HETXRB/Fe_det.txt"
exec more /home/pana/notes/HETXRB/Fe_det.txt

}
