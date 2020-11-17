proc sphauto {} {

    #pilot automatic BN11 fitting
    #Suzaku XIS

    #Limit probability for significance of extra additive component
    set limprob 5e-4
    #Upper limit for fractional power law
    set fracf 0.5
    
    #findsph has run
    findsph
    
    #sig narrow
    vn sig 8.5e-4
    freezee sig

    tclout modpar
    scan $xspec_tclout "%i" npartot
    freeze 1-$npartot

    tclout modcomp
    scan $xspec_tclout "%i" nmodtot
    
    #1. The nh sensitive region 
    #XIS specific has form: **-0.50 1.5-2.3 10.00-**
    scan [ exec more ErangeXIS.txt | gawk -F- {{print $3}} ] "%f %f" low high
    notice all
    ignore **-$low $high-**

    #norm
    thaww norm
    exfit

    #nh
    thaww nh
    exfit

    #g
    thaww g
    exfit
    
    #fe
    thaww fe
    exfit

    
    #2. Full region
    notice all
    set reg [ exec more ErangeXIS.txt ]
    ignore $reg
    svall before-full.xcm

    #################
    #Δχ² for extra PL
    #a. No PL  - Small model
    vn f 0
    freezee f
    exfit
    tclout stat
    scan $xspec_tclout "%f" chiSf
    tclout dof
    scan $xspec_tclout "%f" dofSf
    svall noPL.xcm
    
    #b. With PL - Large model
    @before-full.xcm
    
    thaww f
    #Limit below 1:
    scan [ exec more /home/pana/.xspec/f.var ] "%s %i %i" dum fpar fmod
    tclout param $fpar
    scan $xspec_tclout "%f" fval   
    chasolim $fpar $fval $fracf 1e-7
    exfit
    tclout stat
    scan $xspec_tclout "%f" chiLf
    tclout dof
    scan $xspec_tclout "%f" dofLf
    svall withPL.xcm

    #Compare
    set dchif [expr $chiSf-$chiLf]
    scan [expr $dofSf-$dofLf] "%i" ddf
    scan [exec chiprob.bash $dchif $ddf] "%f %f" probf chimatchf

    #Keep if low prob /not keep if high prob
    if { $probf >= $limprob } {
	@noPL.xcm
    } else {
	@withPL.xcm
    }
    #Else, already with PL!

    
    #################
    #Δχ² for extra apec
    #a. With - Large model
    scan [exec more /home/pana/.xspec/z.var] "%s %i" dum zpar
    addcomp [expr $nmodtot+1] apec & 0.9 & 1 & =$zpar & 1e-5
    set nmodtot [expr $nmodtot+1]
    fixparen
    exfit
    
    tclout stat
    scan $xspec_tclout "%f" chiLa
    tclout dof
    scan $xspec_tclout "%f" dofLa
    svall withapec.xcm
    
    #b. Without  - Small model
    delcomp $nmodtot
    exfit
    tclout stat
    scan $xspec_tclout "%f" chiSa
    tclout dof
    scan $xspec_tclout "%f" dofSa
    svall withnoapec.xcm

    #Compare
    set dchia [expr $chiSa-$chiLa]
    scan [expr $dofSa-$dofLa] "%i" ddf
    scan [exec chiprob.bash $dchia $ddf] "%f %f" probapec chimatchapec

    #Keep/not keep
    if { $probapec >= $limprob } {
	@withnoapec.xcm
    } else {
	@withapec.xcm
    }
    #Else, already not kept!
    

    plot
    fadd
    
    if { $probf >= $limprob } {
	puts "Not kept extra PL"
    } else {
	puts "kept extra PL"
    }
    puts [format "f:Δχ² %.2e-%.2e = %.2e" $chiSf $chiLf $dchif]
    puts [format "f:Δχ² PROB/MATCH %.2e %.2e and limit is %.2e" $probf $chimatchf $limprob]

    if { $probapec >= $limprob } {
	puts "Not kept APEC"
    } else {
	puts "kept APEC"
    }
    puts [format "apec:Δχ² %.2e-%.2e = %.2e" $chiSa $chiLa $dchia]  
    puts [format "apec:Δχ² PROB/MATCH %.2e %.2e and limit is %.2e" $probapec $chimatchapec $limprob]

    
    svall sphauto.xcm
    
}
