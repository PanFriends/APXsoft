proc xlogoff {} {

setplot command window 1
setplot command log x off 
#setplot command log y
setplot command window 2
setplot command log x off 
#setplot command log y

setplot command window 1
exec echo 0 > ~/.xspec/xlog.plot
exec echo 1 > ~/.xspec/ylog.plot

plot

}
