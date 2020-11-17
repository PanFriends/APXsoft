proc wwout {args} {

    #wwout w.xcm wout.xcm
    
    #Δχ² for two models w.xcm wout.xcm
    #w.xcm has more additive components ("L" model)

    set thresh 1e-3
    set log "~/.xspec/wwout.log"
    
    if {[llength $args] != 2} {
	set w "with.xcm"
	set wout "without.xcm"
    }
    
    @$w
    chatter 0
    fadd
    chatter 0
    exfit
    chatter 0
    tclout stat
    scan $xspec_tclout "%f" chiL
    tclout dof
    scan $xspec_tclout "%f" dofL
    

    @$wout
    fadd
    chatter 0
    exfit
    chatter 0
    tclout stat
    scan $xspec_tclout "%f" chiS
    tclout dof
    scan $xspec_tclout "%f" dofS

    #Compare
    set dchi [expr $chiS-$chiL]
    scan [expr $dofS-$dofL] "%i" ddf
    scan [exec chiprob.bash $dchi $ddf] "%f %f" prob chimatch
    
    puts [format "Δχ² (S-L) = %.2e-%.2e = %.2e" $chiS $chiL $dchi]
    puts [format "Δ(dof) (S-L) = %.0f-%.0f = %i" $dofS $dofL $ddf]
    puts [format "PROB/MATCH %.2e %.2e" $prob $chimatch]    

    #Save
    exec /bin/sh -c "echo $chiS $chiL $dchi $ddf $prob $chimatch > $log"

    
    chatter 10
    if {$prob <= $thresh} {
	puts "PROB <= $thresh → with?"
    } else {
	puts "PROB  > $thresh → without?"
    }
	
}
