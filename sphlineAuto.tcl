proc sphlineAuto {} {

#FULLY WORKING

#sphline 

#Transform best fit B&N spherical model to something without the line
#for flux / lumin estimate and subtract flux/lumin from total model

#NB The energy bounds close to the line here are changed interactively
    # and used to estimate average continuum by the line; hence total line flux

#Model must be loaded and plotted

#Calculate continuum 2-10 keV by
#(1) switching off any Gaussian lines
#(2) subtracting trans line estimate from total

#It will use the last loaded *xcm file as infile looking into
#xspec.hty

    #exec /bin/rm wline.qdp
#    set infile [exec /bin/sh -c "findlastload.sh"]
    if {[file exists "Line_lo_hi.txt"]==1} {
	scan [exec more Line_lo_hi.txt] "%f %f" lo hi
    } else {
    set lo 6.3
    set hi 6.5
    }
#    puts $infile

#@$infile
#this100   for COMB
#this100m
#@$infile
plot


set name [exec more stub.txt]
set nameobs $::env(name[exec more stub.txt])
set kpc double(3.08568025e21) 
set pi double(3.1415926535897931)
#set dist [expr $::env(d$name)*$kpc]  for COMB
set namebase [exec /bin/sh -c "findbasename.sh"]
set dist [expr $::env(d$namebase)*$kpc] 

#fit

##############
#Find and remove any Gaussian line components first
gaussrm

##############
#TOTAL 2-10 keV  (for cont 2-10 after line flux done)
##############
flux 2 10 err 100
tclout flux 1
scan $xspec_tclout "%f %f %f %f %f %f" fxtot fxlotot fxhitot phtot phlotot phhitot
set lxtot [expr 4.0*$pi*$fxtot*$dist*$dist]


########################
#TOTAL MODEL AROUND LINE
########################
setplot command re x $lo $hi
setplot command log off
plot ufspec
#y-limits
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
setplot command log off
plot ufspec
setplot delete all
scan [exec ysphline.bash] "%f %f" ylo yhi
setplot command log off
setplot command re y $ylo  $yhi

#lob and hib are buffer variables for lo/hi
set lob $lo
set hib $hi

#while {$lob != 88} {

setplot command re x $lob $hib
setplot command log off
setplot command re y $ylo  $yhi
setplot add
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $nameobs
setplot command time off

plot ufspec
fadd 7

#puts "OK? ($lo $hi) lo hi - 88 to end -- 99 to replot"
#    set ans [gets stdin]
#    scan $ans "%f %f" lob hib 
#if {$lob != 88 && $lob != 99} {
#    set lo $lob
#    set hi $hib
#    puts "low $lo high $hi"
#
#    }

#if {$lob == 99} {
#puts "ylohi "
#    set repl [gets stdin]
#    scan $repl "%f %f" loy hiy
#    ylohi $loy $hiy
#}
#}

set elo $lo
set ehi $hi

#Save for ref 
set out [open "Line_lo_hi.txt" "w"]
puts $out [format "%.3f %.3f " $elo $ehi]
close $out



flux $elo $ehi err 100
tclout flux 1
scan $xspec_tclout "%f %f %f %f %f %f" fxall fxloall fxhiall phall phloall phhiall
set lxall [expr 4.0*$pi*$fxall*$dist*$dist]


#Average energy per photon in ergs
#-smt like 6.4 * 1.6d-9 erg, since 1 keV = 1.6s10^-9 erg
set avengy [expr double(1.6e-9*($hi+$lo)/2.)]

#####################
#CONT AROUND LINE
#####################
ignore *
notice $lo-$hi
file delete wline.pco wline.qdp
set out [open "wfile.pco" "w"]
puts $out  "wdata wline"
close $out

setplot command @wfile
plot ufspec
exec /bin/cp wline.qdp sph.qdp
exec /bin/cp wfile.pco sph.pco
setplot delete all

#Average continuum in ph/cm-2/s-1/keV-1 around line:
set avcont [exec avwline.sh]
#This is the continuum to divide by for EW as well.

#Continuum in ph/cm-2/s-1 around line:
set phcont [expr {$avcont*($hi-$lo)}]

#Continuum in erg/cm-2/s-1 around line:
set fxcont [expr $phcont*$avengy]

#####################
# LINE
#####################
puts "phall $phall"
puts "phcont $phcont"

set phline [expr $phall-$phcont]
set fxline [expr $phline*$avengy]
set lxline [expr 4.0*$pi*$fxline*$dist*$dist]


set out [open "FxLx_line_trans.txt" "w"]
puts $out  "#phline fxline lxline fxall fxloall fxhiall lxall avcont fxcont " 
puts $out [format "%.3e %.3e %.3e    %.3e %.3e %.3e %.3e %.3e %.3e " $phline $fxline $lxline $fxall $fxloall $fxhiall $lxall $avcont $fxcont ]
close $out

puts " "
puts "flux - lumin for line $elo $ehi"
puts "FxLx_line_trans.txt"
puts [format "%.3e ph/cm2/s %.3e erg/cm2/s %.3e erg/s" $phline $fxline $lxline ]

#####################
#EW - no errors
#####################
set out [open "EW_sph.txt" "w"]
#EW in eV
set ew [expr 1e3*$phline/$avcont]
puts $out [format "%.1f" $ew ]
close $out


#####################
#CONT 2-10 keV
#####################
set fx210 [expr $fxtot-$fxline]
set lx210 [expr $lxtot-$lxline]

set out [open "FxLx_2-10_trans.txt" "w"]
puts $out  "#fx210 lx210 "
puts $out [format "%.3e %.3e    " $fx210 $lx210 ]
close $out

puts " "
puts "flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_trans.txt"
puts [ format "%.3e %.3e" $fx210 $lx210 ]

#####################
#UNABSORBED CONT 2-10 keV
#####################
#Find trans PhoIndex and norm

puts " "
puts "unabsorbed continuum 2-10 keV"
findtrans

flux 2 10 err 100
tclout flux 1
scan $xspec_tclout "%f %f %f %f %f %f" ufx210 ufx210lotot ufx210hitot uph210tot uph210lotot uph210hitot
set ulx210 [expr 4.0*$pi*$ufx210*$dist*$dist]

set out [open "FxLx_2-10_trans_un.txt" "w"]
puts $out  "#ufx210 ulx210 "
puts $out [format "%.3e %.3e    " $ufx210 $ulx210 ]
close $out


#ALL on screen:
puts " "
puts "flux - lumin for line $elo $ehi"
puts "FxLx_line_trans.txt"
puts [format "%.3e ph/cm2/s %.3e erg/cm2/s %.3e erg/s" $phline $fxline $lxline ]

puts " "
puts "flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_trans.txt"
puts [format "%.3e %.3e" $fx210 $lx210 ]


puts " "
puts "unabsorbed flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_trans_un.txt"
puts [format "%.3e %.3e" $ufx210 $ulx210 ]

puts " "
puts "avcont"
puts "$avcont"

puts " "
puts "EW (eV)"
puts [format "%.1f" $ew ]

#puts "flux $elo $ehi err 100"

file delete wline.pco wline.qdp

}
