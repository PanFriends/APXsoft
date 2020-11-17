proc findncompW {cname} {

#find number of given component "cname"
#write in terminal only



tclout modcomp
set n_comp $xspec_tclout

for {set i 1} {$i <= $n_comp} {incr i} {
tclout compinfo $i
scan $xspec_tclout "%s %i %i" name npar1 npars
if { [string equal $cname $name] == 1 } {

puts "$npar1"
#puts "$npar1 $npars"
#echo $cname > cname.txt
#echo $npar1 > npar1.txt
#echo $npars
}

}





}
