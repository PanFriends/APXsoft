proc ogamout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp powerlaw
if {[file exists "npar1.txt"]==1} {
set npar1 [exec more npar1.txt]
set nparPho [expr $npar1]
file delete npar1.txt

show
puts "G o $nparPho?"
#set ans [gets stdin]
puts "trans PhoIndex $nparPho"
echo "o" > tgamout.txt

if {[file exists "ULm$nparPho.txt"]==1} {
set doonly 1 
}
if {[file exists "ULs$nparPho.txt"]==1} {
set doonly 1 
}
if {[file exists "LLm$nparPho.txt"]==1} {
set uponly 1 
}
if {[file exists "LLs$nparPho.txt"]==1} {
set uponly 1 
}
gamout $nparPho $predelta $uponly $doonly
}
}
