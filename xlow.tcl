proc xlow {lo} {

setplot command re x $lo
plot

#Write out
set out [open "TEMP_xlow.txt" "w"]
puts $out [format "%f" $lo]

}
