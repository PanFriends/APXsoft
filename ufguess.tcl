proc ufguess {} {

#Given existing plot with data, plot ufspec to guess
#continua

model powerlaw
/*
newpar 1 1.9
freeze 1
setplot command time off
ignore **-2.
plot ufspec
}
