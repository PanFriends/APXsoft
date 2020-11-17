#!/bin/sh

#zoomcen.sh parfile

#Use the three files from stepw.tcl together to identify
#which par value is minimum "zooming into central min"

parfile=$1

statfile=stepstat.txt
delstatfile=delstat.txt

paste $statfile $delstatfile $parfile > pre
gawk '{if($0~/[0-9]/) {print}}' pre > pre2




gawk '{if($0~/[0-9]/) {print}}' stepstat.txt > prov

#Data lines number:
num=`wc -l prov | gawk '{print $1}'`
#Min stat is?
minstat=`meancol prov 1 | grep MIN | gawk '{print $2}'`
#Which line?
minstatline=`grep -n $minstat prov | gawk -F: '{print $1}'`

if [$minstatline -lt $num && $minstatline -gt 1]
then
echo Min at $minstatline
else
echo Min at $minstatline EDGE
fi
