#!/bin/sh

par=$1

lim=2.71

#All values in prov3 have Dchi < lim
#gawk '{if ($2 < lim) {print $1}}' lim=$lim prov2 > prov3

#Remove blank lines
gawk '{if($0~/[0-9]/) {print}}' first > temp
mv temp first
#gawk '{if($0~/[0-9]/) {print}}' prov3 > temp
#mv temp prov3


#prov3 from findlo.sh
#The bottom (highest) value with Dchi < lim
num=`wc -l prov3 | gawk '{print $1}'`

hiprov3=`gawk '{if(NR==num) {print}}' num=$num prov3`

#These HIGH values have Dchi >= lim
gawk '{if ($1>=hiprov3) {print}}' hiprov3=$hiprov3 first > bot
num=`wc -l bot | gawk '{print $1}'`

lonh2=`gawk '{if (NR==1) {print $1}}' bot`
hinh2=`gawk '{if (NR==2) {print $1}}' bot`


#Must step through these HIGH values
echo HIGH END
echo steppar $par $lonh1 $hinh1 100

echo $hinh2 > hinhi2.txt
echo $lonh2 > lonhi2.txt
