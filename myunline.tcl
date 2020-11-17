proc myunline {} {

#myunline 

#Switch off all components except for mytorusL for
#estimateing flux / lumin

#Calculate continuum 2-10 keV by
#(1) switching off any Gaussian lines
#(2) subtracting MytorusL from total

    if {[file exists "myun25_2.4_8.0_u.xcm"]==1} {
    set infile myun25_2.4_8.0_u.xcm
} else {
    set infile myun25_2.4_8.0.xcm
}

    scan [exec more Line_lo_hi.txt] "%f %f" lowE highE
    puts "lowE highE $lowE $highE"
    #exec /bin/rm wline*
puts "FILE $infile"

@$infile
#this100 for COMB
this25m
@$infile
plot

set name [exec more stub.txt]
set kpc double(3.08568025e21) 
set pi double(3.1415926535897931)
#set dist [expr $::env(d$name)*$kpc] for COMB
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

#######################
#AV CONT "AT" LINE PEAK
#######################
#ignore **-$lowE $highE-**
ignore *
notice $lowE-$highE
file delete wline.pco wline.qdp
set out [open "wfile.pco" "w"]
puts $out  "wdata wline"
close $out

setplot command @wfile
plot ufspec
exec /bin/cp wline.qdp myun.qdp
exec /bin/cp wfile.pco myun.pco
setplot delete all

#Average continuum in ph/cm-2/s-1/keV-1 around line:
set avcont [exec avwline.sh]
#This is the continuum to divide by for EW as well.
puts "avcont $avcont"
puts " "
#puts "OK?  - 88 to end -- 99 to replot"
#    set ans [gets stdin]

##############
#MYTL COMPONENT ISOLATE
##############
@$infile
this25m
@$infile

#y-limits for plotting this
setplot command re x $lowE $highE
setplot command log off
plot ufspec
file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
setplot command log off
plot ufspec
setplot delete all
scan [exec ysphline.bash] "%f %f" ylo yhi
setplot command log off
setplot command re y $ylo  $yhi



tclout modcomp
set n_comp $xspec_tclout

#Find number of MYTorusL comp
for {set i 1} {$i <= $n_comp} {incr i} {

tclout compinfo $i
if { [string first "MYTorusL" $xspec_tclout] != -1 } {
#this is MYTorusL component number
set n_my $i 
}
}


#Find greatest "gsmooth" comp number < $n_my
for {set i 1} {$i <= $n_comp} {incr i} {

tclout compinfo $i
if { [string first "gsmooth" $xspec_tclout] != -1 && $i < $n_my } {
#list of comp numbers for "gsmooth"
#the one closest, and < n_my, needs to be deleted

#after loop this will hold desired value
set n_gsmooth $i
}}


#delcomp AFTER $n_my
set n_after [ expr $n_comp - $n_my ]
set j [ expr $n_my+1 ]

for {set i 1}  {$i <= $n_after} {incr i} {
delcomp $j
}

#delcomp BEFORE AND UP TO $n_gsmooth


###############################################################
#This will only keep MYTorusL
#set n_before [ expr $n_gsmooth ]
#
#for {set i 1}  {$i <= $n_before} {incr i} {
#delcomp 1
#}
###############################################################

###############################################################
#This will keep the A_L constant  and gsmooth  
set n_before [ expr $n_gsmooth-2 ]

for {set i 1}  {$i <= $n_before} {incr i} {
delcomp 1
}
###############################################################

###############################################################
#This will keep the A_L constant but not gsmooth    
#set n_before [ expr $n_gsmooth-2 ]
#delcomp $n_gsmooth
#
#for {set i 1}  {$i <= $n_before} {incr i} {
#delcomp 1
#}
###############################################################

show 


###############################################################
#Include for testing:
#puts "n_gsmooth $n_gsmooth"
#puts "OK?  - 88 to end -- 99 to replot"
#    set ans [gets stdin]
###############################################################

##############
#LINE 
##############
flux $lowE $highE err 100
tclout flux 1
scan $xspec_tclout "%f %f %f %f %f %f" fxline fxloline fxhiline phline phloline phhiline 
set lxline [expr 4.0*$pi*$fxline*$dist*$dist]

set out [open "FxLx_line_myun.txt" "w"]
puts $out  "#phline fxline lxline    fxloline fxhiline" 
puts $out [format "%.3e %.3e %.3e     %.3e %.3e " $phline $fxline $lxline $fxloline $fxhiline ]
close $out


puts "++++++++++++++++++++++++++++++++++++"
puts " "
puts "MYTorusL component $n_my"
puts " "
puts "delcomp all other components"
puts "$n_after components after MYTorusL"
puts "gsmooth is component $n_gsmooth"
puts "$n_before components before MYTorusL"
puts " "
puts "FxLx_line_myun.txt"
puts [format "Fx line %.3e ph/cm2/s %.3e erg/cm2/s" $phline $fxline ]
puts [format "Lx line %.3e" $lxline ]

 #set ans [gets stdin]

#####################
#EW - no errors
#####################
set out [open "EW_myun.txt" "w"]
#EW in eV
set ew [expr 1e3*$phline/$avcont]
puts $out [format "%.1f" $ew ]
close $out


#####################
#CONT 2-10 keV
#####################
set fx210 [expr $fxtot-$fxline]
set lx210 [expr $lxtot-$lxline]

set out [open "FxLx_2-10_myun.txt" "w"]
puts $out  "#fx210 lx210 "
puts $out [format "%.3e %.3e    " $fx210 $lx210 ]
close $out

puts " "
puts "flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_myun.txt"
puts [format "%.3e %.3e" $fx210 $lx210 ]

#####################
#UNABSORBED CONT 2-10 keV
#####################
#Find first zpowerlw PhoIndex and norm (z=0)
@$infile

puts " "
puts "unabsorbed continuum 2-10 keV"
findzpo

flux 2 10 err 100
tclout flux 1
scan $xspec_tclout "%f %f %f %f %f %f" ufx210 ufx210lotot ufx210hitot uph210tot uph210lotot uph210hitot
set ulx210 [expr 4.0*$pi*$ufx210*$dist*$dist]

set out [open "FxLx_2-10_myun_un.txt" "w"]
puts $out  "#ufx210 ulx210 "
puts $out [format "%.3e %.3e    " $ufx210 $ulx210 ]
close $out

#ALL TOGETHER ON SCREEN

puts "FxLx_line_myun.txt"
puts [format "Fx line %.3e ph/cm2/s %.3e erg/cm2/s" $phline $fxline ]
puts [format "Lx line %.3e" $lxline ]

puts " "
puts "flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_myun.txt"
puts [format "%.3e %.3e" $fx210 $lx210 ]


puts " "
puts "unabsorbed flux - lumin for cont 2-10 keV"
puts "FxLx_2-10_myun_un.txt"
puts [format "%.3e %.3e" $ufx210 $ulx210 ]

puts " "
puts "avcont"
puts "$avcont"

puts " "
puts "EW (eV)"
puts [format "%.1f" $ew ]

#puts "flux $lowE $highE"

file delete wline.pco wline.qdp










}
