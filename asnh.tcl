proc asnh {nh1 nh2 i as1 as2 j} {

#2-D contours As vs. NH for mytorus

    set objname [exec gawk {{if (NF>1) {print $2} else {print}}} stub.txt ]
file delete provcon.qdp provcon.pco wfile.pco $objname"_As_NH_cont.qdp" $objname"_As_NH_cont.pco"

    tclout modcomp
    set n_comp $xspec_tclout
    #Which is the last param number?
#    tclout compinfo $n_comp

#Find NH(S) param
    for {set k 1} {$k <= $n_comp} {incr k} {
	tclout compinfo $k
	if { [string first MYtorusS $xspec_tclout] != -1 } {
	puts "MYtorusS is comp $k"
	scan $xspec_tclout "%s %i %i" name par npars
	#This is param number for MYtorusS NH

        set n_nhs $par
	    #1 less is As
	    set n_as  [expr $par-1]
	puts "MYtorusS NH is param $n_nhs"
	puts "As const  is param $n_as"

	}
    }

#steppar
thaw $n_nhs $n_as
puts "steppar $n_nhs $nh1 $nh2 $i        $n_as $as1 $as2 $j"
steppar $n_nhs $nh1 $nh2 $i        $n_as $as1 $as2 $j

puts "steppar $n_nhs $nh1 $nh2 $i        $n_as $as1 $as2 $j"

#plot
plot contour
exec provcon.sh
setplot command @wfile
plot
setplot delete all

set two "_As_NH_cont.pco"
set twotwo "_As_NH_cont.qdp"
#exec mv provcon.pco $objname$two
#exec mv provcon.qdp $objname$twotwo
exec mv provcon.pco $objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.pco
exec mv provcon.qdp $objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.qdp
exec rnamepco $objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.pco $objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.qdp
exec rlabelpco $objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.pco 

#Link to special dir
#set thisdir [exec pwd]

#set ldir /home/pana/notes/HETXRB/Dec_2015_Tahir_contour_plots/contours_dec2015/ADDITIONAL_PT
#exec ln -s -f $thisdir/$objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.pco $ldir/.
#exec ln -s -f $thisdir/$objname\_As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.qdp $ldir/.
#exec more stub.txt

#save configuration
puts "save all As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.xcm"
save all As_NH_$nh1\_$nh2\_$i\_$as1\_$as2\_$j\.xcm

	     
}
