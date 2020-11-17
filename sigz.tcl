proc sigz {{nsteps 15} {fac 1.5}} {

#2-D contours σ - z 

#Load fitted model
#Then

# sigz 

    #This was for GXRBs
#    set nameobs $::env(name[exec more stub.txt])
#    puts $nameobs
#    set obs $::env(otex[exec more stub.txt])
#    set obs [lindex [split $obs ~] 2]

    #This works with 2-part stub.txt
    set nameobs [exec more stub.txt]
    
    tclout modcomp
    set n_comp $xspec_tclout


#multiply 90% error by this for plotting limits
#    set fac 1.5
#steps
#    set nsteps 15

#type
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
	set type sph
	set ptype Sphere
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
	set ptype MYtorus
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
    
    set npar1 [exec more /tmp/npar1.txt]
    set ngsmooth $npar1
    file delete /tmp/npar1.txt
    
#Probably don't need to check as gsmooth appears in same order?
#    show
#    puts "gsmooth $ngsmooth?"
#    set ans [gets stdin]


    set i $nsteps
    set j $nsteps

    scan [exec more $zfile] "%e %e %f %e %f" z zlo c zhi c
    scan [exec more $sigfile] "%e %e %f %e %f" s slo c shi c


    set objname [exec more stub.txt]
    file delete provcon.qdp provcon.pco wfile.pco $objname"_"$obs"_"sigz"_"$type"_cont.qdp" $objname"_"$obs"_sigz_"$type"_cont.pco"


#    set z1 [expr $zlo-$fz*$zlo]
#    set z2 [expr $zhi+$fz*$zlo]
#    set s1 [expr $slo-$fs*$slo]
#    set s2 [expr $shi+$fs*$slo]

set dzlo [expr $z-$zlo]
set dzhi [expr $zhi-$z]

puts "$dzlo $dzhi"

if {$dzlo >= $dzhi} {
    set dz $dzlo} else {
	set dz $dzhi}

set dslo [expr $s-$slo]
set dshi [expr $shi-$s]

if {$dslo >= $dshi} {
    set ds $dslo} else {
	set ds $dshi}

#set s1 [expr $slo-$fac*($s-$slo)]
#    set z1 [expr $zlo-$fac*($z-$zlo)]
#    set z2 [expr $zhi+$fac*($zhi-$z)]
#    set s1 [expr $slo-$fac*($s-$slo)]
#    set s2 [expr $shi+$fac*($shi-$s)]

set z1 [expr $zlo-$fac*$dz]
set z2 [expr $zhi+$fac*$dz]
set s1 [expr $slo-$fac*$ds]
set s2 [expr $shi+$fac*$ds]



#steppar
    puts [format "steppar %i   z1   z2  %i    %i sig1 sig2 %i" $par_z  $j   $ngsmooth  $i]
    parallel steppar 4
    steppar $par_z $z1 $z2 $j   $ngsmooth   $s1 $s2 $i
    puts [format "steppar %i   z1   z2  %i    %i sig1 sig2 %i" $par_z  $j   $ngsmooth  $i]
    puts [format "steppar %i %.4e %.4e %i    %i %.4e %.4e %i" $par_z $z1 $z2 $j   $ngsmooth   $s1 $s2 $i]



    #plot, including hardcopy 
    plot contour
    ylohi $s1 $s2
    xlohi $z1 $z2
    setplot command csize 1.3
    setplot command lab T $nameobs $ptype
    setplot command lab x \\fiz\\fr
    setplot command font Ro
    setplot command lab y \\gs\\dL
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
exec mv provcon.pco $objname\_$obs\_sigz\_$type\_cont.pco
exec mv provcon.qdp $objname\_$obs\_sigz\_$type\_cont.qdp
exec mv pgplot.ps   $objname\_$obs\_sigz\_$type\_cont.eps

#Fix first line of new qdp with correct pco name
exec rnamepco $objname\_$obs\_sigz\_$type\_cont.pco $objname\_$obs\_sigz\_$type\_cont.qdp

file delete $objname\_$obs\_sigz\_$type\_cont.xcm
save all $objname\_$obs\_sigz\_$type\_cont.xcm

exec grep "+" $objname\_$obs\_sigz\_$type\_cont.pco

}
