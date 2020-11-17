proc myunaddz {lw} {

#colors and styles for myun components

#Switch off MYTorusL

#1 data
#2 tot cont  solid 1 RED 2
#3 trans     dot   4 DARK GREY 14
#4 const*pow  (check!) solid 1 BLUE 4

#The first additive in the model is number 1, which must be made a 3.
#The list assigns to that a 0, so must add 3.

#PGPLOT line styles are:
# 1=Solid, 2=Dash, 3=Dash-dot, 4=Dot, 5=Dash-dot-dot-dot

#PGPLOT colors are:
#  0=Backg,     1=Foreg,       2=Red,         3=Green,
#  4=Blue,      5=Light blue,  6=Magenta,     7=Yellow,
#  8=Orange,    9=Yel.+Green, 10=Green+Cyan, 11=Blue+Cyan,
# 12=Blue+Mag, 13=Red+Mag,    14=Dark Grey,  15=Light Grey

tclout model 

set nzero -1
set nscat -1
set nline -1
set nconstpo -1

set comps [split $xspec_tclout "+"]
for {set i 0} {$i <= 10} {incr i} {

#    puts [lindex $comps $i]

    if {[string first "mytorus_Ezero" [lindex $comps $i]] >0 || \
	    [string first "zpowerlw" [lindex $comps $i]] >0 } {
	set nzero [expr $i+3]
	puts "$nzero [lindex $comps $i]"
    #Zero Blue
    #setplot command ls 1 on $nzero
    #setplot command lw 1 on $nzero
    #setplot command co 4 on $nzero
    setplot command co off $nzero
        }

    if {[string first "mytorus_scattered" [lindex $comps $i]] >0} {
	set nscat [expr $i+3]
	puts "$nscat [lindex $comps $i]"
    #Scat Magenta
    #setplot command ls 1 on $nscat
    #setplot command lw 1 on $nscat
    #setplot command co 6 on $nscat      
    setplot command co off $nscat
    
    }
 
    if {[string first "mytl" [lindex $comps $i]] >0} {
	set nline [expr $i+3]
	puts "$nline [lindex $comps $i]"
    setplot command co off $nline
    }

    if {[string first "constant*zpowerlw" [lindex $comps $i]] >0} {
	set nconstpo [expr $i+3]
	puts "$nconstpo [lindex $comps $i]"
    #PL soft Orange
    #setplot command lw 1 on $nconstpo
    #setplot command ls 1 on $nconstpo 
    #setplot command co 8 on $nconstpo
    setplot command co off $nconstpo
    }

    if {[string first "constant*powerlaw" [lindex $comps $i]] >0} {
	set nconstpo [expr $i+3]
	puts "$nconstpo [lindex $comps $i]"
    #PL soft Orange
    #setplot command lw 1 on $nconstpo
    #setplot command ls 1 on $nconstpo 
    #setplot command co 8 on $nconstpo
    setplot command co off $nconstpo
    }



    if {[string first "gauss" [lindex $comps $i]] >0} {
    set ngauss [expr $i+3]
    puts "$ngauss [lindex $comps $i]"
    setplot command co off $ngauss
    }


}

#Total red
setplot command line on 2
setplot command error off 2
setplot command co 2 on 2




#For later fix of pco
echo err off 2 >> /tmp/erroffD
}
