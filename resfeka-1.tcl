proc resfeka {} {

    # Version for Tzanavaris2018 paper
#Residuals and ratio in vicinity of Fe Ka line

set lo 6.3
set hi 6.5
tclout model
if { [string first "sphere" $xspec_tclout] > 0 } {
set type trans
puts "type $type"
} else {
set type myun
}

ploli
ignore *
notice $lo-$hi
xlohi $lo $hi

file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
setplot command log off
plot residuals
setplot delete all
scan [exec /bin/bash -c "yresfeka.bash"] "%f %f" maxre stdevre
echo $maxre $stdevre > resid_$type.txt

file delete provcon.qdp provcon.pco wfile.pco 
exec provcon.sh
setplot command @wfile
setplot command log off
plot ratio
setplot delete all
scan [exec yrafeka.bash] "%f %f" maxra stdevra
echo $maxra $stdevra > ratio_$type.txt

file delete provcon.qdp provcon.pco wfile.pco 

ignore *
scan [exec more band.txt] "%s %s" lo hi
notice $lo-$hi
setplot command lw 5
setplot command lw 5 on 2
set nameobs $::env(name[exec more stub.txt])
setplot command label title $nameobs
setplot command time off
ploli

more resid_$type.txt
more ratio_$type.txt







}
