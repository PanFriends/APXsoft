#!/bin/bash

#getlim.bash sph_2.3-8.0.xcm

#File looks like sph_2.3-8.0.xcm
#Get 2.3 and 8.0

lowlim=`echo $1 | gawk -F.xcm '{print $1}' | gawk -F[_-] '{print $2}'`
hilim=`echo $1 | gawk -F.xcm '{print $1}' | gawk -F[_-] '{print $3}'`

echo $lowlim > TEMP_glob_xlow.txt
echo $hilim  > TEMP_glob_xhi.txt
echo $lowlim > TEMP_xlow.txt
echo $hilim  > TEMP_xhi.txt
