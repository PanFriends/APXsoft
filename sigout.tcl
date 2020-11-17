proc sigout {par} {

#assumes frozen

#type is used for final filename
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type trans
    puts "type $type"
    } else {
    set type myun
    puts "type $type"
    }




tclout param $par
scan $xspec_tclout "%f" sig

set out [ open "sig_$type.txt" "w" ]
puts $out "$sig f"
close $out

}
