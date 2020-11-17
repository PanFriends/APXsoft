proc mfscout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp powerlaw
if {[file exists "npar1.txt"]==1} {
set npar1 [exec more npar1.txt]
set nconst [expr $npar1-1]
file delete npar1.txt

show
puts "const $nconst?"
#set ans [gets stdin]

if {[file exists "ULm$nconst.txt"]==1} {
set doonly 1 
}

fscout $nconst $predelta $uponly $doonly

}
}
