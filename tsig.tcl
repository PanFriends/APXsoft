proc tsig { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans sigma

findncomp gsmooth

set npar1 [exec more npar1.txt]
set ngsmooth $npar1
file delete npar1.txt

show
puts "gsmooth $ngsmooth?"
#set ans [gets stdin]

if {[file exists "ULs$ngsmooth.txt"]==1} {
set doonly 1 
}


sigout_step $ngsmooth $predelta $uponly $doonly

}
