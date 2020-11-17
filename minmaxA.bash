#!/bin/bash

#minmaxA file.qdp

#Find min and max in A from column 1 in file

file=$1

#Just the first set of numbers

gawk '{if ($1~/[0-9]/ && $0!~"NO") {print $1}}' $file
