proc maout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp MYtorusS
set npar1 [exec more /tmp/npar1.txt]
set nconst [expr $npar1-1]
file delete npar1.txt

show
#puts "A const $nconst?"
#set ans [gets stdin]

if {[file exists "ULm$nconst.txt"]==1} {
set doonly 1 
}
aout $nconst $predelta $uponly $doonly

}
