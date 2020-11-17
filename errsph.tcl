proc errsph {} {

#exec ~/bin/htembl ~/.xspec/errsph.tcl &

@sph25_2.4_8.0.xcm

if {[file exists *u.png]==1} {
    exec rm *u.png}
if {[file exists *l.png]==1} {
    exec rm *l.png}

#All errors for spherical
feout
 #errpng fe
tsig
 #errpng sigsph
zlout
 #errpng zsph
nhout
 #errpng nhsph
tgamout
 #errpng gamsph
tnormout
 #errpng normsph

#optional
ogamout
 #errpng ogamsph
mfscout

 #errpng fscsph
#NHgal
 #errpng NHgalsph

#exec convert *.png png_sph.pdf

}
