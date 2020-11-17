proc pplot {} {

set name [exec more stub.txt]
fadd 7
setplot add
setplot command lw 5
setplot command lw 5 on 2
setplot command label title $name
setplot command time off
plot
}
