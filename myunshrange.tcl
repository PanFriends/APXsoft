proc myunshrange {{dcomp 1}} {

    #Limit uncoupled MYTORUS modeling to a shorter energy range
    #Compare key parameters between extended and short range

    #XIS only

    #Start with extended range model loaded
    
    #Send key par/mod numbers to database
    chatter 0
    findmyt

    #In the simple cases, anything after the extra partial power law
    #of fraction "f" is dominant in the softer region (eg APEC).

    #Keep up to constant*zpo
    set nmax [expr [getnmod f]+$dcomp]
    #ie +1 after f for constant*zpo -- default
    #+2 after f for constant*zphabs*zpo
    
    set nstart [expr $nmax+1]

    
    #Save long.xcm
    if { [file exists "long.xcm" ] == 1 } {
	exec rm long.xcm
    }
    svall long

    #Get values of key parameters:
    set nhz_L [getparval nhz]
    set z_L [getparval z]
    set g_L [getparval g]
    set norm_L [getparval norm]
    set nhs_L [getparval nhs]
    set as_L [getparval as]
    set sig_L [getparval sig]
    set f_L [getparval f]
    
    #1. The nhz sensitive region (is the higher energy we want)
    #XIS specific has form: **-0.50 1.5-2.3 10.00-** - this keeps 2.3-10.0:
    scan [ exec more ErangeXIS.txt | gawk -F- {{print $3}} ] "%f %f" low high
    notice all
    ignore **-$low $high-**

    #2. Remove components after $nf - if any
    tclout modcomp
    scan $xspec_tclout "%i" nmodtot
    while {$nmodtot > $nmax} {
	#delcomp $nmodtot
	delcomp $nstart
	tclout modcomp
	scan $xspec_tclout "%i" nmodtot
    }
    
    chatter 10

    #3. Fit
    #Just in case, limit Γ for mytorus
    set gpar [getnpar g]
    hasolim $gpar  1.4 1.4  2.6 2.6 
    
    lfit
    #Save short.xcm
    if { [file exists "short.xcm" ] == 1 } {
	exec rm short.xcm
    }
    svall short

    #4. Get new key parameters:
    set nhz_S [getparval nhz]
    set z_S [getparval z]
    set g_S [getparval g]
    set norm_S [getparval norm]
    set nhs_S [getparval nhs]
    set as_S [getparval as]
    set sig_S [getparval sig]
    set f_S [getparval f]

    #5. Fractional changes:
    set outfile "frac_S-L.txt"
    set out [ open $outfile w ]
    set dnhz  [ffrac $nhz_S $nhz_L]
    set dz    [ffrac $z_S $z_L]
    set dg    [ffrac $g_S $g_L]
    set dnorm [ffrac $norm_S $norm_L]
    set dnhs  [ffrac $nhs_S $nhs_L]
    set das   [ffrac $as_S $as_L]
    set dsig  [ffrac $sig_S $sig_L]
    set df    [ffrac $f_S $f_L]
  
    puts $out [format "nhz  %.3e" $dnhz ]
    puts $out [format "z    %.3e" $dz   ]
    puts $out [format "g    %.3e" $dg   ]
    puts $out [format "norm %.3e" $dnorm]
    puts $out [format "nhs  %.3e" $dnhs ]
    puts $out [format "as   %.3e" $das  ]
    puts $out [format "sig  %.3e" $dsig ]
    puts $out [format "f    %.3e" $df   ]
    close $out

    #Global results file:
    set allresults "/home/pana/notes/ADAP17/CTHIN/All-frac_S-L.txt"
    if { [file exists $allresults] == 0 } {
	set out [open $allresults w]
	puts $out "   Name       obs      dnhz        dz         dg         dnorm      dnhs        das        dsig        df"
    } else {
	set out [open $allresults a]
    }

    set stub [exec more stub.txt]
    puts $out [format "%25s %.3e  %.3e  %.3e  %.3e  %.3e  %.3e  %.3e  %.3e" $stub $dnhz $dz $dg $dnorm $dnhs $das $dsig $df ]
    close $out

    exec more $outfile

}

 
