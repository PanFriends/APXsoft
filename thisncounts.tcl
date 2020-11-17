proc thisncounts {datafile {elow 0.5} {ehi 10.0}} {

    #Just plot normalized counts data only

    if {[ file exists "stub.txt" ] == 1} {
	set name [exec more stub.txt]
    } else {
	set name $datafile
    }

    set lw 5
    data $datafile
    setplot rebin 1 1
    setplot energy
    cpd /xs
    ignore **-$elow $ehi-**
    setplot command time off
    setplot command label title $name
    setplot command lw $lw 

    plot data
    exec echo $name > /tmp/logname.log

}
    
