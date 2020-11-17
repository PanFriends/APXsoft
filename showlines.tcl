proc showlines {} {
    #Show list of emission lines

    set list "/home/pana/.xspec/emlines.txt"
    set z [exec more z.txt]
    exec gawk {NR>1 {printf"%14s %f %.2f\n", $1,$2, $2/(1.+z)}} z=$z $list







}
