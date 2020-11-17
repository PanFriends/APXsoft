proc rpoint {} {
package require Tk 


    bind 1 <1> {
    puts "hi from (%x,%y)"
    set hi %x
    }


#lassign [winfo pointerxy .] x y
#puts -nonewline "Mouse pointer at ($x,$y) which is "
#set win [winfo containing $x $y]
#if {$win eq ""} {
#    puts "over no window"
#} else {
#    puts "over $win"
#}
#
}
