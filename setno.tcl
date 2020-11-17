proc setno {lo hi} {


   set nh $::env(nh[exec more ../../COMB/stub.txt])
   set out [ open "nh.txt" "w"]
puts $out "$nh"
close $out

set phoIndex 1.9
set norm 1
set data [exec /bin/sh -c "ls *heg_m1p1_b0100.pha" ]

data $data
ignore **-$lo $hi-**
model phabs*powerlaw & $nh & $phoIndex & $norm

save all forset.xcm

@forset.xcm
this100m
@forset.xcm
plot


wpnew 3 .01 20 100
wpnew 1 .01 30 200
query no
fit
plot 
hardcopy fenofe.ps
save all nofeka.xcm
fekadet

}
