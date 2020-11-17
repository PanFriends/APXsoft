proc sigzps {} {

#2-D contours σ - z 

#Load fitted model
#Then

# sigz 1.1 3

#EPS ONLY

set nameobs $::env(name[exec more stub.txt])
puts $nameobs

    tclout modcomp
    set n_comp $xspec_tclout


#multiply 90% error by this for plotting limits
    set fac 1.5
#steps
    set nsteps 5

#type
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type sph
	puts "type $type"
	set zfile zl_trans.txt
	set sigfile sig_trans.txt

	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+4}]
	puts "z par is $par_z"
	}
	}

    }


    if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
	puts "type $type"
	set zfile zl_myun.txt
	set sigfile sig_s_myun.txt

	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first MYtorusS $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+3}]
	puts "z par is $par_z"

	}
	}

    }
    findncomp gsmooth
    
    set npar1 [exec more npar1.txt]
    set ngsmooth $npar1
    file delete npar1.txt
    
#Probably don't need to check as gsmooth appears in same order?
#    show
#    puts "gsmooth $ngsmooth?"
#    set ans [gets stdin]


    set i $nsteps
    set j $nsteps

    scan [exec more $zfile] "%e %e %f %e %f" z zlo c zhi c
    scan [exec more $sigfile] "%e %e %f %e %f" s slo c shi c

    set objname [exec more stub.txt]
    file delete provcon.qdp provcon.pco wfile.pco $objname"_"$type"_sig_z_cont.qdp" $objname"_"$type"_sig_z_cont.pco"

#    set z1 [expr $zlo-$fz*$zlo]
#    set z2 [expr $zhi+$fz*$zlo]
#    set s1 [expr $slo-$fs*$slo]
#    set s2 [expr $shi+$fs*$slo]
    set z1 [expr $zlo-$fac*($z-$zlo)]
    set z2 [expr $zhi+$fac*($zhi-$z)]
    set s1 [expr $slo-$fac*($s-$slo)]
    set s2 [expr $shi+$fac*($shi-$s)]

#steppar
    puts [format "steppar %i   z1   z2  %i    %i sig1 sig2 %i" $par_z  $j   $ngsmooth  $i]
    steppar $par_z $z1 $z2 $j   $ngsmooth   $s1 $s2 $i
    puts [format "steppar %i   z1   z2  %i    %i sig1 sig2 %i" $par_z  $j   $ngsmooth  $i]
    puts [format "steppar %i %.4e %.4e %i    %i %.4e %.4e %i" $par_z $z1 $z2 $j   $ngsmooth   $s1 $s2 $i]



    #plot eps
    plot contour
    setplot command lab T $nameobs $type
    setplot command lwidth 5
    setplot command cont 1 lwid 5 5 5
    setplot command time off
    setplot command hardcopy /cps
    exec provcon.sh
    setplot command @wfile

    plot
    setplot delete all


#Record
#    echo sigz $fs $fz > sigz_$type"_"Call.txt
    set out [open "sigz\_$type\_Call.txt" "w"]
    puts $out [format "steppar %i %.4e %.4e %i    %i %.4e %.4e %i" $par_z $z1 $z2 $j   $ngsmooth   $s1 $s2 $i] 
    close $out

#Save
exec mv provcon.pco $objname\_sigz\.pco
exec mv provcon.qdp $objname\_sigz\.qdp

}
