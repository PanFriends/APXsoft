proc add5 {lw} {

#add5 5

#setplot add 5 components with lw=$lw

#setplot add for 5 components, so 3 to 7
#PGPLOT line styles are:
# 1=Solid, 2=Dash, 3=Dash-dot, 4=Dot, 5=Dash-dot-dot-dot

#PGPLOT colors are:
#  0=Backg,     1=Foreg,       2=Red,         3=Green,
#  4=Blue,      5=Light blue,  6=Magenta,     7=Yellow,
#  8=Orange,    9=Yel.+Green, 10=Green+Cyan, 11=Blue+Cyan,
# 12=Blue+Mag, 13=Red+Mag,    14=Dark Grey,  15=Light Grey

setplot command co 2 on 2
setplot command co 3 on 3
setplot command co 4 on 4
setplot command co 10 on 5
setplot command co 15 on 6


setplot command ls 2 on 3
setplot command ls 2 on 4
setplot command ls 2 on 5
setplot command ls 2 on 6

setplot command lw $lw on 3
setplot command lw $lw on 4
setplot command lw $lw on 5
setplot command lw $lw on 6

puts "Red TOTAL - 2 - cont"
puts "Green       3 - dashed"
puts "Blue        4 - dashed"
puts "Cyan        5 - dashed"
puts "Grey        6 - dashed"
puts "Grey light  7 - dashed"


plot
}
