proc nofekaset {lo hi} {

#nofekaset 2.8 8.0

#Fit zpo and then zpo+zga to see if line detected

#Save E12.txt on the side

    set nh [exec more nh.txt]

    set out [ open "E12.txt" "w"]
puts $out "$lo $hi"
close $out


set phoIndex 1.9
set norm 1

ignore **-$lo $hi-**
model phabs*powerlaw & $nh & $phoIndex & $norm

}
