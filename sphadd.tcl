proc sphadd {lw} {



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

set ntrans -1
set nconstpo -1

set comps [split $xspec_tclout "+"]

file delete "/tmp/erroffU"
#If only one additive, then it's just total model.
if {[llength $comps] > 1} {

for {set i 0} {$i <= 10} {incr i} {

#    puts [lindex $comps $i]

    if {[string first "atable" [lindex $comps $i]] >0} {
    set ntrans [expr $i+3]
    puts "$ntrans [lindex $comps $i]"
    setplot command line on   $ntrans
    setplot command err off $ntrans
    setplot command lw 1 on $ntrans
    setplot command ls 1 on $ntrans
    setplot command co 4 on $ntrans
    echo err off $ntrans >> /tmp/erroffU
    
    }
    if {[string first "constant*powerlaw" [lindex $comps $i]] >0} {
	set nconstpo [expr $i+3]
	puts "$nconstpo [lindex $comps $i]"
        setplot command line on   $nconstpo
        setplot command err off $nconstpo
        setplot command lw 1  on $nconstpo
        setplot command ls 1 on $nconstpo 
        setplot command co 8 on $nconstpo
        echo err off $nconstpo >> /tmp/erroffU
    }
    if {[string first "gauss" [lindex $comps $i]] >0} {
	set ngauss [expr $i+3]
	puts "$ngauss [lindex $comps $i]"
        setplot command line on   $ngauss
        setplot command err off $ngauss
        setplot command lw 1  on $ngauss
        setplot command ls 1  on $ngauss 
        setplot command co 6 on $ngauss
        echo err off $ngauss >> /tmp/erroffU
    }





}

}
setplot command line on  2
setplot command err off 2
setplot command co 2 on 2

#For later fix of pco
echo err off 2 >> /tmp/erroffU

}
