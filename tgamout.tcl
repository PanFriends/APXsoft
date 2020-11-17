proc tgamout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp trans 
set npar1 [exec more npar1.txt]
set nparPho [expr $npar1+1]
file delete npar1.txt

puts "trans PhoIndex $nparPho"
echo "s" > tgamout.txt

if {[file exists "ULs$nparPho.txt"]==1} {
set doonly 1 
}
if {[file exists "LLs$nparPho.txt"]==1} {
set uponly 1 
}
gamout $nparPho $predelta $uponly $doonly

}
