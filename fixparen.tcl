proc fixparen {} {

    #Mainly call to fixparen.bash
    
    #for model type
    #model phabs(stuff ) + apec
    #convert to
    #model phabs( stuff + apec )
    #
    #Finds the last ")" and moves it to the very end.

    #After addcomp statement, where the new component is placed
    #AT THE END:
    sprov
    exec /bin/bash -c "fixparen.bash prov.xcm"
    @prov.xcm

}
