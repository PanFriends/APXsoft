proc errprov {par {predelta 0} {uponly 0} {doonly 0} {mynh 0}} {

#predelta is only non-zero if estimates are for emission lines (lineout.tcl)!
#Also kept for backwards compatibility

file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty par2706u.txt par2706l.txt par2706.txt

#Initialization
set delc_do_last 0

# {uponly 0} {doonly 0}
set outfile errout.txt
#set tol 0.005
set tol 0.05

#Best fit value
tclout param $par
scan $xspec_tclout "%f %f %f %f %f %f" value delta min low high max

#STEPPING FROM VALUE and UP
if {$uponly == 0} {
puts "*****************************************"
puts "STEPPING FROM VALUE and UP -- UPPER ERROR"
puts "*****************************************"
set delc_do 3.0 
    if {$predelta > 0 } {
	set offset $predelta} else {
set offset 0.1
	}
set iter 1
set niter 10


while { [file exists par2706u.txt ] == 0 } {
set hi [exec /bin/sh -c "flosplitD $value u $offset"]
puts "****"
puts "$iter"
puts "****"

if {$predelta > 0 && $iter > 1} {
#different strategy just for lines
set hi $lhi
set niter $lniter
}

puts "steppar $par $value $hi $niter"
steppar $par $value $hi $niter


#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Plot
plot contour

#set out [ open "wfile.pco" "w" ]
#puts $out "wenviron provcon"
#puts $out "plot"
#close $out
exec provcon.sh
setplot command @wfile
plot
setplot delete all

#Adjust the min y for plotting
exec ypco_noans.sh





#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do



 #accelerate?

if { $predelta == 0 } {

if { $delc_do <= 1e-3 } {
set offset [expr $offset+0.7]
}
if { $delc_do <= 1e-2 && $delc_do > 1e-3 } {
set offset [expr $offset+0.4]
}
if { $delc_do <= 1e-1 && $delc_do > 1e-2 } {
set offset [expr $offset+0.3]
}
if { $delc_do <= 1 && $delc_do > 1e-1 } {
set offset [expr $offset+0.2]
}
if { $delc_do <= 2.5 && $delc_do > 1 } {
set offset [expr $offset+0.1]
}

#Last changes -- here will also check for 2.706 value
if { $delc_do  > 2.5 && $delc_do <= 20 && $predelta == 0} {
set offset [expr $offset+0.1]
#set niter [expr $niter+3]
}
if { $delc_do > 3.5 && $predelta == 0} {
set offset [expr $offset-0.1]
set niter [expr $niter-5]
}
 

#At this stage, need finer grid for large param best fit values
set svalue $value
if { $mynh == 1 } {
    set svalue [expr $svalue*100.]
}

if {$svalue > 1e-2 && $svalue <= 0.1} {
set niter [expr $niter+10]
}
if {$svalue > 1e-1 && $svalue <= 1} {
set niter [expr $niter+20]
}
if {$svalue > 1 && $svalue <= 5} {
set niter [expr $niter+30]
}
if {$svalue > 5 && $svalue <=10} {
set niter [expr $niter+40]
}
if {$svalue > 10} {
set niter [expr $niter+50]
}

if { $delc_do > 3.0 && $predelta == 0} {
#Just finer grid from here on
set niter [expr $niter+50]
}

if { $delc_do >= 20 && $predelta == 0} {
set offset [expr $offset-0.5]
set niter [expr $niter/3]
}
if { $iter > 100 } {
set iter 40
}



#predelta == 0
}


#But for lines:
if { $predelta > 0 } {
    set lhi [ exec /bin/sh -c "narrohi.awk prov2" ]
    if {$lhi == 0} {
    
	set offset [expr $offset*2]	
        set lhi [exec /bin/sh -c "flosplitD $value u $offset"]
    }

    set lniter [expr $niter+10]
 
#puts "$lhi $lniter"
}
 



exec /bin/sh -c "tbz.awk prov2 $tol"

if {[file exists par2706.txt ] == 1} {
exec cvlc /usr/share/kde4/apps/marble/data/audio/KDE-Sys-List-End.ogg &
exec mv par2706.txt par2706u.txt
set in [ exec more par2706u.txt ]
scan $in "%f %f %f" stat271u dstat271u par271u
set par_hi $par271u
set delstat_hi $dstat271u
puts "iter $iter"
puts "$stat271u $dstat271u $par271u"
puts "continue?"
set ans [gets stdin]
} 

set iter [expr $iter+1]
file delete provcon.qdp provstat.txt provcon.pco wfile.pco ~/.xspec/xspec.hty
#while
}


#if uponly 0
}



#STEPPING from BELOW TO VALUE -- LOWER ERROR
if {$doonly == 0} {
puts "*******************************************"
puts "STEPPING from BELOW TO VALUE -- LOWER ERROR"
puts "*******************************************"
set delc_up 3.0 
    if {$predelta > 0 } {
	set offset $predelta} else {
set offset 0.1
	}
set iter 1
set niter 10

while { [file exists par2706l.txt ] == 0 } {
set lo [exec /bin/sh -c "flosplitD $value d $offset"]
puts "****"
puts "$iter"
puts "****"

if {$predelta > 0 && $iter > 1} {
#different strategy just for lines
set lo $llo
set niter $lniter
}

puts "steppar $par $lo $value $niter"
steppar $par $lo $value $niter
#Write out steps for statistic, delta-statistic, param
stepw $par prov
exec paste stepstat.txt delstat.txt prov > prov2

#Plot
plot contour

#set out [ open "wfile.pco" "w" ]
#puts $out "wenviron provcon"
#puts $out "plot"
#close $out
exec provcon.sh
setplot command @wfile
plot
setplot delete all

#Adjust the min y for plotting
exec ypco_noans.sh





#Do the test:
exec /bin/sh -c "tb271.awk prov2"
set in [ exec more tb271.txt ]
scan $in "%f %f %f %f %f %f" c_up delc_up par_up   c_do delc_do par_do

#Of interest here is the first (top) line of prov2, i.e delc_up:
#if $delc_up <= 3.0
 #expand
#set niter [expr $niter+5]

 #accelerate?
if { $predelta == 0 } {

if { $delc_up <= 1e-3 } {
set offset [expr $offset+0.7]
}
if { $delc_up <= 1e-2 && $delc_up > 1e-3 } {
set offset [expr $offset+0.4]
}
if { $delc_up <= 1e-1 && $delc_up > 1e-2 } {
set offset [expr $offset+0.3]
}
if { $delc_up <= 1 && $delc_up > 1e-1 } {
set offset [expr $offset+0.2]
}
if { $delc_up <= 2.5 && $delc_up > 1 } {
set offset [expr $offset+0.1]
}

#Last changes -- here will also check for 2.706 value
if { $delc_up  > 2.5 } {
set offset [expr $offset+0.1]
#set niter [expr $niter+3]

if { $delc_up > 3.5 } {
set offset [expr $offset-0.1]
set niter [expr $niter-15]
}
 
if { $iter > 100 } {
set iter 40
}




#At this stage, need finer grid for large param best fit values
set svalue $value
if { $mynh == 1 } {
    set svalue [expr $svalue*100.]
}

if {$svalue > 1e-2 && $svalue <= 0.1} {
set niter [expr $niter+10]
}
if {$svalue > 1e-1 && $svalue <= 1} {
set niter [expr $niter+20]
}
if {$svalue > 1 && $svalue <= 5} {
set niter [expr $niter+30]
}
if {$svalue > 5 && $svalue <=10} {
set niter [expr $niter+40]
}
if {$svalue > 10} {
set niter [expr $niter+50]
}
}
if { $delc_up > 3.0 } {
#Just finer grid from here one
    set niter [expr $niter+50]
}




#predelta == 0
}


#But for lines:
if { $predelta > 0 } {
    set llo [ exec /bin/sh -c "narrolo.awk prov2" ]
    if {$llo == 0} {
    
	set offset [expr $offset*2]	
        set llo [exec /bin/sh -c "flosplitD $value d $offset"]
    }

    set lniter [expr $niter+10]
 
#puts "$llo $lniter"
}
 

exec /bin/sh -c "tbz.awk prov2 $tol"

if {[file exists par2706.txt ] == 1} {
exec cvlc /usr/share/kde4/apps/marble/data/audio/KDE-Sys-List-End.ogg &
exec mv par2706.txt par2706l.txt
set in [ exec more par2706l.txt ]
scan $in "%f %f %f" stat271l dstat271l par271l
set par_lo $par271l
set delstat_lo $dstat271l
puts "iter $iter"
puts "$stat271l $dstat271l $par271l"
#puts "continue?"
#set ans [gets stdin]
} 

set iter [expr $iter+1]
file delete provcon.qdp provstat.txt provcon.pco wfile.pco ~/.xspec/xspec.hty
#while
}


#if doonly 0
}

#WRITE OUT
set out [open "errout.txt" "w"]
if {$uponly == 0 && $doonly == 0} {
puts $out [format "%.4e %.4e %.4f %.4e %.4f " $value $par_lo $delstat_lo $par_hi $delstat_hi]
}
if {$doonly !=0} {
puts $out [format "%.4e  0   0    %.4e %.4f " $value  $par_hi $delstat_hi]
}
if {$uponly !=0} {
puts $out [format "%.4e %.4e %.4f    0   0  " $value $par_lo $delstat_lo ]
}

close $out

#Cleanup
file delete prov prov2 tb271.txt partop1.txt partop2.txt parbot1.txt parbot2.txt sp271.txt zm271.txt zmpar.txt par2706u.txt par2706l.txt stepstat.txt delstat.txt 





#proc
}
