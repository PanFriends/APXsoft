#!/bin/bash

#Establish final name string in an ADD directory e.g. 4u17a_657_3585

ids=`pwd | gawk -F"/" '{print $(NF-1)}' | gawk -F"_" '{print $2"_"$4}'`
name=`more stub.txt`
echo $name"_"$ids
