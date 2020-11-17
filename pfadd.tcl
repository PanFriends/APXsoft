proc pfadd {lw} {

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



tclout model 
#How many +'s in model expression
set numplus [regexp -all {\+} $xspec_tclout]

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
setplot command co 4 on 3

setplot command ls 4 on 3

setplot command lw $lw on 3

puts "Blue       3 - dotted"
plot
}

if {$iter > 2 } {
#3
setplot command co 4 on 4
setplot command ls 4 on 4
setplot command lw $lw on 4

puts "Blue        4 - dotted"
plot
}

if {$iter > 3 } {
#4
setplot command co 4 on 5
setplot command ls 4 on 5
setplot command lw $lw on 5

puts "Blue        5 - dotted"
plot
}

if {$iter > 4 } {
#5
setplot command co 4 on 6
setplot command ls 4 on 6
setplot command lw $lw on 6

puts "Blue        6 - dotted"
}


}