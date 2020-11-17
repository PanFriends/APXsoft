proc adcopo {conum normnum} {

#Add constant*powerlaw with norm = other norm

addcomp $conum powerlaw & 1. & =$normnum
addcomp $conum constant & 1.

}
