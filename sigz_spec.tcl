proc sigz_spec {{nsteps 15} {x1 -888} {x2 -888} {y1 -888} {y2 -888}} {

#2-D contours σ - z 

#Load fitted model
#Then

# sigz <with specific values>


set nameobs $::env(name[exec more stub.txt])
puts $nameobs
    set obs $::env(otex[exec more stub.txt])
    set obs [lindex [split $obs ~] 2]

    set objname [exec more stub.txt]
    set let [string index $objname end]
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
	set ptype Spherical
	puts "type $type"

	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first trans $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+4}]
	puts "z par is $par_z"

	#Read par value from loaded model
	tclout param $par_z
	scan $xspec_tclout "%f" z

	
	}

    }
	#Previous values
	if {[file exists "sigz_spec_sph_Call.txt"]==1 && $x1==$x2} {
	scan [exec readcont "sigz_spec_sph_Call.txt"] "%s %s %i %f %f %f %f" xcm call nsteps x1 x2 y1 y2
	puts "$nsteps $x1 $x2 $y1 $y2"
	@$xcm
	    }
    }
        


    if { [string first "mytorus" $xspec_tclout] > 0 } {
	set type myun
	set ptype MYtorus
	puts "type $type"

	for {set i 1} {$i <= $n_comp} {incr i} {
	tclout compinfo $i
	if { [string first MYtorusS $xspec_tclout] != -1 } {    
	scan $xspec_tclout "%s %i %i" name par npars
	#This is the param number for trans z
	set par_z [expr {$par+3}]
	puts "z par is $par_z"

	#Read par value from loaded model
	tclout param $par_z
	scan $xspec_tclout "%f" z
	}
	}

	#Previous values
	if {[file exists "sigz_spec_myun_Call.txt"]==1 && $x1==$x2} {
	scan [exec readcont "sigz_spec_myun_Call.txt"] "%s %s %i %f %f %f %f" xcm call nsteps x1 x2 y1 y2
	puts "$nsteps $x1 $x2 $y1 $y2"
	@$xcm

	    }
    }
    findncomp gsmooth
    
    set npar1 [exec more npar1.txt]
    set ngsmooth $npar1
    file delete npar1.txt
    tclout param $ngsmooth
    scan $xspec_tclout "%f" s
     
#Probably don't need to check as gsmooth appears in same order?
#    show
#    puts "gsmooth $ngsmooth?"
#    set ans [gets stdin]


    set i $nsteps
    set j $nsteps

set zlo $x1
set zhi $x2
set slo $y1
set shi $y2

    file delete provcon.qdp provcon.pco wfile.pco $objname"_"$obs"_"sigz"_"$type"_cont.qdp" $objname"_"$obs"_sigz_"$type"_cont.pco"


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

set z1 [expr $x1]
set z2 [expr $x2]
set s1 [expr $y1]
set s2 [expr $y2]

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
    setplot command lab y \\gs\\dL\\u (keV)
    setplot command lwidth 5
    setplot command cont 1 lwid 2 2 2
    setplot command cont 1 color 1 2 4
    setplot command cont 1 lstyle 1 1 1
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
    set out [open "sigz\_spec\_$type\_Call.txt" "w"]
    puts $out "@$objname\_$obs\_sigz\_$type\_cont.xcm"
    puts $out [format "sigz\_spec %i %.4e %.4e %.4e %.4e" $nsteps $x1 $x2 $y1 $y2] 
    close $out

#Save
exec mv provcon.pco $objname\_$obs\_sigz\_$type\_cont.pco
exec mv provcon.qdp $objname\_$obs\_sigz\_$type\_cont.qdp
exec mv pgplot.ps   $objname\_$obs\_sigz\_$type\_cont.eps

#Fix first line of new qdp with correct pco name
exec rnamepco $objname\_$obs\_sigz\_$type\_cont.pco $objname\_$obs\_sigz\_$type\_cont.qdp

#Ensure "+" is in pco file
exec fixcross $objname\_$obs\_sigz\_$type\_cont.pco $z $s

#No Levels etc text in plot; Letter designation upper left
exec nolevelcont $objname\_$obs\_sigz\_$type\_cont.pco $let

#Final ps
exec qitps $objname\_$obs\_sigz\_$type\_cont


file delete $objname\_$obs\_sigz\_$type\_cont.xcm
save all $objname\_$obs\_sigz\_$type\_cont.xcm

#Final plot
setplot command @$objname\_$obs\_sigz\_$type\_cont
plot contour
setplot delete all

exec okular $objname\_$obs\_sigz\_$type\_cont.eps > /dev/null 2>&1 &
exec grep "+" $objname\_$obs\_sigz\_$type\_cont.pco

echo $objname\_$obs\_sigz\_$type\_cont.pco > /tmp/sigfiles.txt
echo $objname\_$obs\_sigz\_$type\_cont.qdp >> /tmp/sigfiles.txt
echo $objname\_$obs\_sigz\_$type\_cont.eps >> /tmp/sigfiles.txt
echo $objname\_$obs\_sigz\_$type\_cont.xcm >> /tmp/sigfiles.txt

mv /tmp/sigfiles.txt FILES_sigz_$type.txt
more FILES_sigz_$type.txt

}
