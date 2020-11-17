proc fadd {{lw 7}} {

#fadd 5

#In color:
#3/4 bit https://en.wikipedia.org/wiki/ANSI_escape_code#Escape_sequences
#\033 is escape key
    #
    #256-bit: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done

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
    #puts "comps $v"
    #puts [lindex $comps $v]
}

#Divide by number of data groups
tclout datagrp
scan $xspec_tclout "%i" ngroup
set numplus [expr $numplus/$ngroup]
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
set dline [expr $nadd+2]

puts "$iter curves/data to mark"
puts "$nadd additive components"
puts "$dline curve plot offset"

#Eg for 3 additive "components",
#nadd=3
#dline=3+2=5
#curve ids would be:
#1 = data for grp 1
#2 = total
#3 = "comp" 1
#4 = "comp" 2
#5 = "comp" 3

#6 = data for grp 2
#7 = total
#8 = "comp" 1
#9 = "comp" 2
#10 = "comp" 3


setplot command co 2 on 2
setplot command lw $lw on 2
if {$ngroup > 1} {
    setplot command co 2 on [expr 2+$dline]
    setplot command lw $lw on [expr 2+$dline]
}
puts "\033\[1;31mRed TOTAL - 2 - cont"


if {$iter > 1 } {
#2
setplot command co 3 on 3
setplot command ls 2 on 3
setplot command lw $lw on 3
if {$ngroup > 1} {
    setplot command co 3 on [expr 3+$dline]
    setplot command ls 2 on [expr 3+$dline]
    setplot command lw $lw on [expr 3+$dline]
}
puts "\033\[0;92mGreen       3 - dashed"
puts [lindex $comps 0]
puts "\033\[0;30m"
plot
}

if {$iter > 2 } {
#3
setplot command co 4 on 4
setplot command ls 2 on 4
setplot command lw $lw on 4

if {$ngroup > 1} {
    setplot command co 4 on [expr 4+$dline]
    setplot command ls 2 on [expr 4+$dline]
    setplot command lw $lw on [expr 4+$dline]
}
puts "\033\[38\;5;33mBlue        5 - dotted"
puts [lindex $comps 2]
puts "\033\[0;30m"
plot
}

if {$iter > 3 } {
#4
setplot command co 8 on 5
setplot command ls 4 on 5
setplot command lw $lw on 5
if {$ngroup > 1} {
    setplot command co 8 on [expr 5+$dline]
    setplot command ls 4 on [expr 5+$dline]
    setplot command lw $lw on [expr 5+$dline]
} 
puts "\033\[38\;5;208mOrange        5 - dotted"
puts [lindex $comps 4]
puts "\033\[0;30m"
plot
}

if {$iter > 4 } {
#5
setplot command co 15 on 6
setplot command ls 2 on 6
setplot command lw $lw on 6
if {$ngroup > 1} {
    setplot command co 8 on [expr 6+$dline]
    setplot command ls 4 on [expr 6+$dline]
    setplot command lw $lw on [expr 6+$dline]
} 
puts "\033\[38\;5;246mGrey        5 - dotted"
puts [lindex $comps 6]
puts "\033\[0;30m"
plot
}

if {$iter > 5 } {
#6
setplot command window 1 co 14 on 7
setplot command ls 2 on 7
setplot command lw $lw on 7
if {$ngroup > 1} {
    setplot command co 8 on [expr 7+$dline]
    setplot command ls 4 on [expr 7+$dline]
    setplot command lw $lw on [expr 7+$dline]
} 
puts "\033\[38\;5;237mDark Grey        5 - dotted"
puts [lindex $comps 8]
puts "\033\[0;30m"
plot
}

if {$iter > 6 } {
#7
setplot command co 6 on 8
setplot command ls 5 on 8
setplot command lw $lw on 8
if {$ngroup > 1} {
    setplot command co 5 on [expr 8+$dline]
    setplot command ls 4 on [expr 8+$dline]
    setplot command lw $lw on [expr 8+$dline]
} 
puts "\033\[38\;5;201mMagenta 8 - dash-dot-dot-dot"
puts [lindex $comps 10]
puts "\033\[0;30m"
plot
}

if {$iter > 7 } {
#8
setplot command co 8 on 9
setplot command ls 5 on 9
setplot command lw $lw on 9
if {$ngroup > 1} {
    setplot command co 8 on [expr 9+$dline]
    setplot command ls 4 on [expr 9+$dline]
    setplot command lw $lw on [expr 9+$dline]
} 
puts "Orange 9 - dash-dot-dot-dot"
puts [lindex $comps 12]
puts "\033\[0;30m"
plot
}

