proc addrel {} {

    #Add relxill to mytorus

    #lmod relxill 
    load /home/pana/.xspec/myModels/RELXILL/librelxill.so

    findmyt
    #Replace main zpowerlw with relxill
    #NB: the component number will not change
    set nmodpl [ getnmod g ]

    #Γ from mytorus
    set gmyt [getparval g]
    set zmyt [getparval z]
    set npar_zmyt [getnpar z]
    
    #Default relxill and replace
    addcomp $nmodpl relxill & /*
    delcomp [expr $nmodpl+1]

    findrelx
    #Use Γ from before and tie MYTS to that
    set npar_grel [getnpar grel]
    newpar $npar_grel $gmyt
    
    #puts $nmodpl
    #puts $gmyt

    #Now, g and norm are BOGUS!
    findmyt
    #Find Γ mytS
    set npar_nhs [getnpar nhs]
    set npar_gmyts [expr $npar_nhs+2]
    #Tie
    newpar $npar_gmyts = $npar_grel

    #Afe=1
    set npar_afe [getnpar afe]
    freeze $npar_afe 1

    #Ecut=500
    set npar_ecut [getnpar ecut]
    newpar $npar_ecut 500.0
    freeze $npar_ecut
    
    #Tie z - frozen
    set npar_zrel [getnpar zrel]
    newpar $npar_zrel $zmyt
    freeze $npar_zmyt 

    #Freeze stuff!
    #mytorusZ, spin, 
    set npar_zL [expr [getnpar sig]+5]
    freeze $npar_zL
    set npar_zS [expr $npar_nhs+3]
    freeze $npar_zS

    set npar_f [getnpar f]
    if {$npar_f > 0} {
	freeze $npar_f-[expr $npar_f+2]
    }


    set npar_normL [expr $npar_zL+1]
    set npar_normS [expr $npar_zS+1]
    
    newpar $npar_normL = $npar_normS
    if {$npar_f > 0} {
	newpar [expr $npar_f+3] = $npar_normS
    }
	








}
