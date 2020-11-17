#!/bin/sh

#5/2018: Now explicit energy bounds because issues when 2 data groups
#with qdp file written

#average cont calculation just straddline line 

elow=$1
ehi=$2

file=wline.qdp

#strip header
gawk '{if (NF >= 5) {print}}' $file > temp
#num=`wc -l temp | gawk '{print $1}'`
#locont=`gawk '{if(NR==1) {print $5}}' temp`
#hicont=`gawk '{if(NR==n) {print $5}}' n=$num temp`
#avcont=`echo $locont $hicont | gawk '{print ($1+$2)/2.}'`
avcont=$( gawk '{if($1>=l && $1 <=h) {printf"%.7e\n",$5}}' l=$elow h=$ehi temp | gawk '{sum+=$1;count++} END {printf"%.7e\n", sum/count}' )

echo $avcont

/bin/rm temp
