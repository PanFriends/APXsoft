proc sy {} {

#from TEMP_ylow.txt, TEMP_yhi.txt  to  sy.txt

scan [exec more TEMP_ylow.txt] "%s" lo 
scan [exec more TEMP_yhi.txt] "%s" hi
echo $lo $hi > sy.txt

exec more sy.txt

}

