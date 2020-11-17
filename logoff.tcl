proc logoff {} {

setplot command window 1
setplot command log off
setplot command window 2
setplot command log off
setplot command window 1

plot
exec echo 0 > ~/.xspec/xlog.plot
exec echo 0 > ~/.xspec/ylog.plot
}
