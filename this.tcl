proc this {xcmfile} {

#Just plot this xcm file


    @$xcmfile
    if {[ file exists "stub.txt" ] == 1} {
	set name [exec more stub.txt]
    } else {
	set name $xcmfile
    }
    #puts $name
    
    setplot rebin 1 1
    setplot energy
    cpd /xs
    setplot add
#    setplot command lw 5
#    setplot command lw 5 on 2
#    setplot command label title $name
#    setplot command time off
    plot ld ratio
    exec echo ld ratio > ~/.xspec/lastXY.log
    exec echo $name > /tmp/logname.log
    exec echo $xcmfile >> /tmp/logname.log
    exec echo $xcmfile > /tmp/xcmname.log
    fadd
   
}
