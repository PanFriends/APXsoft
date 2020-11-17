#!/bin/sh

#This is more advanced than zoomlo.sh but not fully implemented for all
#error finding
#Default still zoomlo_1.sh

outfile=$1

#Number of iterations for steppar to be dynamically increased
niter=$2

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
#Double number of iterations for steppar
echo $niter | gawk '{print 2*$1}' > niter.txt
#Set lo param limit (hi Δχ) for steppar 
gawk '{if($2 <=10.) {print $1}}' prov2 | gawk '{if(NR==1) {print $1}}' > lo.txt
#Set hi param limit (=low Δχ) for steppar 
#gawk '{if($2 >=0.) {print $1}}' prov2 | tail -1 > hi.txt



fi

