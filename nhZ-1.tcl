proc nhZ { {predelta 0.1} {uponly 0} {doonly 0}} {

    #5/2018: Note that tex output isn't happening
    
#copy of nhz.tcl to distinguish from nhz_spec.tcl

#gamout for trans powerlaw slope

findncomp MYtorusZ
if {[file exists "/tmp/npar1.txt"]==1} {

set npar1 [exec more /tmp/npar1.txt]

set nz $npar1
#file delete npar1.txt
exec echo z > tgamout.txt

#zshow
#puts "NH_Z $nz?"
#set ans [gets stdin]

puts "nhout..."
nhout $predelta $uponly $doonly
} else {
set nz 3
#show
#puts "NH_Z $nz?"
#set ans [gets stdin]

set par $nz
set type "z_myun"

#Check if frozen
frcheck $par
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen"
tclout param $par
scan $xspec_tclout "%f" parval
set cparval [expr $parval/100.]

exec /bin/sh -c "echo $cparval f > NH_$type.txt"
}

if {[file exists "ULm$nz.txt"]==1} {
set doonly 1 
}

if {$frozen == 0} {
puts "not frozen"

if {[file exists "ULm$nz.txt"]==1} {
set doonly 1 
}

errout $par $predelta $uponly $doonly
exec cp errout.txt NH_$type.txt

exec /bin/sh -c  "unitsNHzphabs.sh"
puts " "
exec more NH_$type.txt
}


}

}
