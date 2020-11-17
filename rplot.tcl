proc rplot {args} {

#rplot ufspec

#Combination of rey.tcl and standard plot with ratio

#In order plot type is:
#-command line
#-if no command line, what in $lastfile
#-if none of the above, ufspec



set lastfile "RPLOT_last.txt" 

if {[llength $args] == 0 && [file exists $lastfile] == 0} {
set type "ufspec"
exec echo $type > $lastfile
}

if {[llength $args] == 0 && [file exists $lastfile] == 1} {
    set type [exec more $lastfile]
}



if {[llength $args] == 1} {
set type [lindex $args 0]
exec echo $type > $lastfile
}

rey $type
plot $type ra








}
