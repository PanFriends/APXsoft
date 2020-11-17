proc fnew {par val} {

#newpar par val
#plot

newpar $par $val
freeze $par

plot
show all
}
