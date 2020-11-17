proc tnormout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp trans 
set npar1 [exec more npar1.txt]
set nparnorm [expr $npar1+5]
file delete npar1.txt

show
puts "trans norm $nparnorm"
normout $nparnorm $predelta $uponly $doonly

}
