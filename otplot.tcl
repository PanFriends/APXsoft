proc otplot {args} {

    set num [llength $args]
    set dir "/home/pana/.xspec"
    set ot "/tmp/otplot"

    set Pg ""
    set Pnhs ""
    set Pnhz ""
    set Pf ""
    set Pfe ""
   
    for {set i 0} {$i < $num} {incr i} {
	set this [lindex $args $i]
	
	if {[string equal "g" $this]==1} {
	    scan [exec more $dir/g.var] "%s %i %i" dum npar dum
	    tclout param $npar
	    scan $xspec_tclout "%f" val
	    set o [open $ot "w"]
	    puts $o [format "%.2f" $val ]
	    close $o
	    set Pg [exec more $ot ]
	    set pre "\\gG\\fn="
	    set Pg $pre$Pg
	    
	}
	if {[string equal "nhs" $this]==1} {
	    scan [exec more $dir/nhs.var] "%s %i %i" dum npar dum
	    tclout param $npar
	    scan $xspec_tclout "%e" val
	    set o [open $ot "w"]
	    puts $o [format "%.2e" $val ]
	    close $o
	    set Pnhs [exec more $ot ]
	    set pre "\\fiN\\fn\\dH,S\\u="
	    set Pnhs $pre$Pnhs
	}
	if {[string equal "f" $this]==1} {
	    scan [exec more $dir/f.var] "%s %i %i" dum npar dum
	    tclout param $npar
	    scan $xspec_tclout "%e" val
	    set o [open $ot "w"]
	    puts $o [format "%.2e" $val ]
	    close $o
	    set Pf [exec more $ot ]
	    set pre "\\fif\\fn="
	    set Pf $pre$Pf
	}
	if {[string equal "nhz" $this]==1} {
	    scan [exec more $dir/nhz.var] "%s %i %i" dum npar dum
	    tclout param $npar
	    scan $xspec_tclout "%e" val
	    set o [open $ot "w"]
	    puts $o [format "%.2e" $val ]
	    close $o
	    set Pnhz [exec more $ot ]
	    set pre "\\fiN\\fn\\dH,Z\\u="
	    set Pnhz $pre$Pnhz
	}

	#BN11
	if {[string equal "fe" $this]==1} {
	    scan [exec more $dir/fe.var] "%s %i %i" dum npar dum
	    tclout param $npar
	    scan $xspec_tclout "%e" val
	    set o [open $ot "w"]
	    puts $o [format "%.2e" $val ]
	    close $o
	    set Pf [exec more $ot ]
	    set pre "\\fiA\\fr\\dFe,sph\\u="
	    set Pfe $pre$Pfe
	}
	
    }

    set text "$Pg $Pnhs $Pnhz $Pf $Pfe"

    setplot command label OT $text
    plot

    
}
