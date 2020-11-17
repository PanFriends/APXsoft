#!/bin/sh

par=$1

lim=2.71

#read [ans]

#Remove blank lines
gawk '{if($0~/[0-9]/) {print}}' first > temp
mv temp first

#All values in prov3 have Dchi < lim
gawk '{if ($2 < lim) {print $1}}' lim=$lim first > prov3

gawk '{if($0~/[0-9]/) {print}}' prov3 > temp
mv temp prov3



#The second smallest value with Dchi < lim (i.e. go a bit deeper!)
#loprov3=`gawk '{if(NR==1) {print}}' prov3`
loprov3=`gawk '{if(NR==2) {print}}' prov3`

#These SMALL values have Dchi >= lim
gawk '{if ($1<=loprov3) {print}}' loprov3=$loprov3 first > top
num=`wc -l top | gawk '{print $1}'`

hinh1=`gawk '{if (NR==last) {print $1}}' last=$num top`

#lonh1=`gawk '{if (NR==(last-1)) {print $1}}' last=$num top`
#Stepping is more likely to find 2.7 closest if you start
#from least, i.e. line 1, in top
lonh1=`gawk '{if (NR==1) {print $1}}' last=$num top`


#Must step through these SMALL values
echo LOW END
echo steppar $par $lonh1 $hinh1 `more niter.txt`

echo $hinh1 > hinhi1.txt
echo $lonh1 > lonhi1.txt
