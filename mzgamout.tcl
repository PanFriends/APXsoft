proc mzgamout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp zpowerlw 
set npar1 [exec more npar1.txt]
set nparPho [expr $npar1]
file delete npar1.txt

show
puts "Gamma z $nparPho?"
#set ans [gets stdin]

echo "z" > tgamout.txt
if {[file exists "LLm$nparPho.txt"]==1} {
set uponly 1 
}
gamout $nparPho $predelta $uponly $doonly



}
