proc lodata {datafile} {

    #Just load

    if {[ file exists "stub.txt" ] == 1} {
	set name [exec more stub.txt]
    } else {
	set name $xcmfile
    }
    set lw 7
    
    data $datafile
    setplot rebin 1 1
    setplot energy
    setplot command lw $lw 
    setplot command label title $name
    setplot command time off
    
    cpd /xs
    setplot add
    plot ldata

    


    exec echo ld  > ~/.xspec/lastXY.log
    exec echo $name > /tmp/logname.log

}
