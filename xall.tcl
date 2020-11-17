proc xall {} {

    set lo [exec more TEMP_glob_xlow.txt]
    set hi [exec more TEMP_glob_xhi.txt]

xlohi $lo $hi
plot

}
