proc fadd {{lw 7}} {

#fadd 5

#THIS IS fadd_2.tcl

#find number of added components
#setplot add them with lw=$lw

# so 3 to (number of components found + 2)
#PGPLOT line styles are:
# 1=Solid, 2=Dash, 3=Dash-dot, 4=Dot, 5=Dash-dot-dot-dot

#PGPLOT colors are:
#  0=Backg,     1=Foreg,       2=Red,         3=Green,
#  4=Blue,      5=Light blue,  6=Magenta,     7=Yellow,
#  8=Orange,    9=Yel.+Green, 10=Green+Cyan, 11=Blue+Cyan,
# 12=Blue+Mag, 13=Red+Mag,    14=Dark Grey,  15=Light Grey

# These are for renewing the look which can be "forgotten"
set name [exec more stub.txt]
setplot command window 1
setplot command lw $lw 
setplot command lw $lw on 2
setplot command label title $name
setplot command time off
##########################################################

tclout model 
#How many +'s in model expression
set numplus [regexp -all {\+} $xspec_tclout]

#Store components
foreach datum $xspec_tclout {
    lassign [split $datum "+"] v
    lappend comps $v
}
#This has numplus+numadditives elements, so we want
#just the odd-numbered ones (because of spaces assigned to elements)


#NO +s: plot only total
if { $numplus == 0 } {
set iter 1
} else {
#ELSE
#There $numplus+2 additive curves to plot; including total
set iter [expr {$numplus+2}]
}

#There $numplus+1 additive components
set nadd [expr {$numplus+1}]

puts "$iter curves/data to mark"
puts "$nadd additive components"

#1
setplot command co 2 on 2
puts "Red TOTAL - 2 - cont"



if {$iter > 1 } {
#2
setplot command co 3 on 3

setplot command ls 2 on 3

setplot command lw $lw on 3

puts "Green       3 - dashed"
puts [lindex $comps 0]
plot
}

if {$iter > 2 } {
#3
setplot command co 4 on 4
setplot command ls 2 on 4
setplot command lw $lw on 4

puts "Blue        4 - dashed"
puts [lindex $comps 2]
plot
}

if {$iter > 3 } {
#4
setplot command co 8 on 5
setplot command ls 4 on 5
setplot command lw $lw on 5

puts "Orange        5 - dotted"
puts [lindex $comps 4]
plot
}

if {$iter > 4 } {
#5
setplot command co 15 on 6
setplot command ls 2 on 6
setplot command lw $lw on 6

puts "Grey        6 - dashed"
puts [lindex $comps 6]
}

if {$iter > 5 } {
#6
setplot command window 1 co 14 on 7
setplot command ls 2 on 7
setplot command lw $lw on 7

puts "Dark Grey   7 - dashed"
puts [lindex $comps 8]
}

if {$iter > 6 } {
#7
setplot command window 1 co 11 on 8
setplot command ls 5 on 8
setplot command lw $lw on 8

puts "Blue+Cyan 8 - dash-dot-dot-dot"
puts [lindex $comps 10]
}

if {$iter > 7 } {
#8
setplot command window 1 co 8 on 9
setplot command ls 5 on 9
setplot command lw $lw on 9

puts "Orange 9 - dash-dot-dot-dot"
puts [lindex $comps 12]
}

}
