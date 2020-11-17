proc getnmod {stub} {

    #Get the $stub.par model number from ~/.xspec
    scan [ exec more /home/pana/.xspec/$stub.var ] "%s %i %i" dum par mod

    return $mod

}
