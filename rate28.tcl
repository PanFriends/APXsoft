proc rate28 {} {

#count rate 2-8 keV for b0025 m1p1

#in ADD directory

scan [exec more band.txt] "%s %s" lo hi
set file sph25\_$lo\_$hi.xcm
chatter 0
@$file
rig 2.0 8.0
tclout rate 1
scan $xspec_tclout "%f %f %f" crate err mo
echo $crate > crate.prov
echo $err > craterr.prov
chatter 10









}
