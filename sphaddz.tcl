proc sphaddz {lw} {


#colors and styles for spherical components

#1 data
#2 tot cont  solid 1 RED 2
#3 trans     dot   4 DARK GREY 14
#4 const*pow  (check!) solid 1 BLUE 4

#The first additive in the model is number 1, which must be made a 3.
#The list assigns to that a 0, so must add 3.

tclout model 

set ntrans -1
set nconstpo -1

set comps [split $xspec_tclout "+"]

file delete "/tmp/erroffD"
#If only one additive, then it's just total model.
if {[llength $comps] > 1} {

for {set i 0} {$i <= 10} {incr i} {

#    puts [lindex $comps $i]

    if {[string first "atable" [lindex $comps $i]] >0} {
    set ntrans [expr $i+3]
    puts "$ntrans [lindex $comps $i]"
    #setplot command lw 1 on $ntrans
    #setplot command ls 1 on $ntrans
    #setplot command co 4 on $ntrans
    setplot command co off $ntrans
    }
    if {[string first "constant*powerlaw" [lindex $comps $i]] >0} {
    set nconstpo [expr $i+3]
    puts "$nconstpo [lindex $comps $i]"
    #setplot command lw 1  on $nconstpo
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
}

setplot command line on 2
setplot command err off 2
setplot command co 2 on 2



#For later fix of pco
echo err off 2 >> /tmp/erroffD
}
