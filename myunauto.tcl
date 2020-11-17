proc myunauto {} {

    #pilot automatic mytorus uncoupled fitting
    #Suzaku XIS

    #Limit probability for significance of extra additive component
    set limprob 5e-4
    #Upper limit for fractional power law
    set fracf 0.5
    set log "/home/pana/.xspec/wwout.log"

    snew swith
    snew swithout
    
    #Although has run
    findmyt
    
    #sig narrow
    vn sig 8.5e-4
    freezee sig

    #limits for Γ
    scan [ exec more /home/pana/.xspec/g.var ] "%s %i %i" dum gpar gmod
    hasolim $gpar  1.4 1.4  2.6 2.6 
    
    tclout modpar
    scan $xspec_tclout "%i" npartot
    freeze 1-$npartot

    tclout modcomp
    scan $xspec_tclout "%i" nmodtot
    
    #1. The nhz sensitive region
    #XIS specific has form: **-0.50 1.5-2.3 10.00-**
    scan [ exec more ErangeXIS.txt | gawk -F- {{print $3}} ] "%f %f" low high
    notice all
    ignore **-$low $high-**

    #norm
    thaww norm
    exfit

    #nhz
    thaww nhz
    exfit

    #g
    thaww g
    exfit
    
    #nhs
    thaww nhs
    exfit

    #2. Full region
    notice all
    set reg [ exec more ErangeXIS.txt ]
    ignore $reg

    svall before-full.xcm


    #################
    #Δχ² for extra PL
    vn f 0
    freezee f
    exfit
    swithout

    thaww f
    #Limit below 1:
    scan [ exec more /home/pana/.xspec/f.var ] "%s %i %i" dum fpar fmod
    tclout param $fpar
    scan $xspec_tclout "%f" fval   
    chasolim $fpar $fval $fracf 1e-7
    exfit
    swith

    wwout
    #results:
    scan [exec more $log] "%f %f %f %f %f %f" chiSf chiLf dchif ddf probf chimatchf
    #Keep if low prob /not keep if high prob
    if { $probf >= $limprob } {
	exec cp without.xcm noPL.xcm
	@noPL.xcm
    } else {
	exec cp with.xcm withPL.xcm
	@withPL.xcm
    }
   
    #################
    #Δχ² for extra apec
    scan [exec more /home/pana/.xspec/z.var] "%s %i" dum zpar
    addcomp [expr $nmodtot+1] apec & 0.9 & 1 & =$zpar & 1e-5
    fixparen
        
    set nmodtot [expr $nmodtot+1]
    swith

    delcomp $nmodtot
    swithout

    wwout
    #results:
    scan [exec more $log] "%f %f %f %f %f %f" chiSa chiLa dchia ddf probapec chimatchapec
    #Keep if low prob /not keep if high prob
    if { $probapec >= $limprob } {
	exec cp without.xcm withnoapec.xcm
	@withnoapec.xcm
    } else {
	exec cp with.xcm withapec.xcm
	@withapec.xcm
    }
    
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
    
    svall myunauto.xcm

}
