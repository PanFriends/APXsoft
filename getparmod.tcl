proc getparmod {stub} {

    #Get the $stub.var parameter and model numbers from ~/.xspec

    scan [ exec more /home/pana/.xspec/$stub.var ] "%s %i %i" dum par mod
    
    return [list $par $mod]
    #puts $par $mod
}
