proc tfscout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

#if powerlaw cpt exists, continue
findncomp powerlaw
if {[file exists "npar1.txt"]==1} {
file delete npar1.txt

findncomp trans 
set npar1 [exec more npar1.txt]
set nconst [expr $npar1+6]
file delete npar1.txt

show
puts "Fs const $nconst?"
set ans [gets stdin]

fscout $nconst $predelta $uponly $doonly
}
}
