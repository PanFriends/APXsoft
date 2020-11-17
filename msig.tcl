proc msig { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for myun sigma

findncomp gsmooth

set npar1 [exec more npar1.txt]
set ngsmooth $npar1
file delete npar1.txt
echo "s" > tgamout.txt

show
puts "gsmooth $ngsmooth?"
#set ans [gets stdin]

if {[file exists "ULm$ngsmooth.txt"]==1} {
set doonly 1 
}


sigout_step $ngsmooth $predelta $uponly $doonly

}
