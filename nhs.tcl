proc nhs { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp MYtorusS

set npar1 [exec more /tmp/npar1.txt]
set ns $npar1
file delete npar1.txt
echo "s" > tgamout.txt

show
puts "$ns?"
#set ans [gets stdin]

if {[file exists "ULm$ns.txt"]==1} {
set doonly 1 
}
if {[file exists "LLm$ns.txt"]==1} {
set uponly 1 
}

nhout $predelta $uponly $doonly

}
