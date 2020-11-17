proc msgamout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp MYtorusS
set npar1 [exec more npar1.txt]
set nparPho [expr $npar1+2]
file delete npar1.txt

show
puts "Gamma S $nparPho?"
#set ans [gets stdin]

echo "s" > tgamout.txt
gamout $nparPho $predelta $uponly $doonly

}
