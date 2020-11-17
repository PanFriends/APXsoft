proc pnew {par val} {

    #pnew 3 2.33
    #pnew 3 =2
    #newpar par val
    #newpar par =val
    #plot


set name [exec more stub.txt]

if {[string first "=" $val] != -1} {
    #Replace = with 
    regsub {^([=])*} $val {} val
    #puts "VAL $val"
    newpar $par = $val
} else {
    newpar $par $val
}
#fadd 7
setplot add
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $name
setplot command time off
#plot
fadd
show all
}
