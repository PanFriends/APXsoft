proc malout { {predelta 0.1} {uponly 0} {doonly 0}} {

#gamout for trans powerlaw slope

findncomp MYTorusL
set npar1 [exec more npar1.txt]
set nconst [expr $npar1-3]
file delete npar1.txt

show
puts "$nconst?"
set ans [gets stdin]

untie $nconst
thaw $nconst

alout $nconst $predelta $uponly $doonly

}
