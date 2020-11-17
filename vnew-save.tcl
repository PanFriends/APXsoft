proc vnew {npar val} {

    #vnew nh 5

    if {[file exists /home/pana/.xspec/$npar.var]==1} {
	set par [exec more /home/pana/.xspec/$npar.var | gawk {{print $2}}]
	puts $par
    } else {
	puts "No $name.var"
	exit
    }

    #Rest is as in pnew.tcl
    set name [exec more stub.txt]
    fadd 7
    setplot add
    setplot command lw 5
    setplot command lw 5 on 2
    setplot command label title $name
    setplot command time off

    if {[string first "=" $val] != -1} {
        #Replace = with 
        regsub {^([=])*} $val {} val
        #puts "VAL $val"
        newpar $par = $val
    } else {
        newpar $par $val
    }
    plot
    fadd
    show all

}
