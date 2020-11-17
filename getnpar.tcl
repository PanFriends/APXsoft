proc getnpar {stub} {

    #Get the $stub.par parameter number from ~/.xspec
    scan [ exec more /home/pana/.xspec/$stub.var ] "%s %i %i" dum par mod

    return $par

}
