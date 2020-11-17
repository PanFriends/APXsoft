#!/bin/sh

#Called by limout.tcl

#Modification of findhi.sh just for upper limit case

par=$1

lim=2.71

#Remove blank lines
gawk '{if($0~/[0-9]/) {print}}' first > temp
mv temp first

#Start where delchi is 2
gawk '{if ($2>=2) {print}}' first > bot
num=`wc -l bot | gawk '{print $1}'`

lonh2=`gawk '{if (NR==1) {print $1}}' bot`
hinh2=`gawk '{if (NR==num) {print $1}}' num=$num bot`

#Must step through these HIGH values
echo HIGH END
echo steppar $par $lonh1 $hinh1 10

echo $hinh2 > hinhi2.txt
echo $lonh2 > lonhi2.txt

#A del estimate for later zooming from two consecutive entries in first
lower=`gawk '{if (NR==1) {print $1}}' bot`
higher=`gawk '{if (NR==2) {print $1}}' bot`
echo $higher $lower | gawk '{print ($1-$2)/10.}' > del.txt
