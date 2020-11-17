#!/bin/sh

outfile=$1

lim=2.71
#tol=0.005
tol=0.01

#found.txt must exist
echo -n > found.txt

#Check if we've found 2.71 close enough in prov2
gawk '{if( ($2 >= lim && $2 - lim <= tol) || ($2<= lim && lim - $2 <= tol)) {print}}' lim=$lim tol=$tol prov2 > found.txt


num=`wc -l found.txt | gawk '{print $1}'`

if [ $num -ge 1 ]
then
#Done.
echo 0 > flag.txt
#Now choose: sort on delchi value
sort -gk 2,2 found.txt | gawk '{if(NR==1) {print $1,$2}}' > $outfile

else
echo 1 > flag.txt
fi

