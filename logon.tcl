proc logon {} {

setplot command window 1
setplot command log on
setplot command window 2
setplot command log off
setplot command log x
setplot command re y 0.7 1.3
plot
setplot command window 1

plot
ylohi
#fadd
}
