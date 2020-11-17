proc mnormout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp zpowerlw
set npar1 [exec more npar1.txt]
set nparnorm [expr $npar1+2]
file delete npar1.txt

show
puts "Norm $nparnorm?"
#set ans [gets stdin]

normout $nparnorm $predelta $uponly $doonly

}
