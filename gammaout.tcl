proc gammaout {num} {

tclout param $num
scan $xspec_tclout "%f" G
error $num
tclout error $num
scan $xspec_tclout "%f %f %s" G_lo G_hi text

set out [ open "gamOUT.txt" "w" ]
puts $out "#Gamma lo hi"
puts $out "$G $G_lo $G_hi $text"

close $out
exec more gamOUT.txt

}
