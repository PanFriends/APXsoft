proc xlohi {args} {

    #If no arguments, read range from active xcm file, plot, and store:
    if {[llength $args] == 0 && [file exists "/tmp/logname.log"]==1} {
	set xcm [exec /bin/bash -c "more /tmp/logname.log | gawk '{if(NR==2) {print}}'" ]
	set igstring [exec /bin/bash -c "grep ignore $xcm | sed 's/ignore//'" ]
	
        ignore $igstring
	#Plots this extent
	setplot command re x
	plot

	#Write it out
	set default "[expr { round(1000.*rand()) }]def"
	setplot command wdata $default
	plot


	#is there NO?
#set lineno [exec /bin/bash -c "gawk '{if (\$1\~\"NO\") {print NR}}' ${default}.qdp"]
#if {[regexp {[0-9]} $lineno ] == 1} {
#    exec /bin/bash -c "gawk '{if (NR>3 && NR<l) {print}}' l=$lineno $default.qdp >  wshort"
#    set hi [exec /bin/bash -c "sort -rgk 1,1 wshort | gawk 'NR==1 {print \$1}'"]
#    set lo [exec /bin/bash -c "sort -gk 1,1 wshort | gawk 'NR==1 {print \$1}'"]
#}
#
	#$1 on last line
	set lineno [exec /bin/bash -c "wc -l $default.qdp | gawk '{print \$1}'"]
	set hi [exec /bin/bash -c "gawk '{if (NR==l) {print \$1}' l=$lineno $default.qdp"] 
	#$1 on first line
	set lo [exec /bin/bash -c "gawk '{if (NR==4) {print \$1}' $default.qdp"] 

	file delete $default* 
      
    } else { 
	set lo [lindex $args 0]
	set hi [lindex $args 1]
    }

#Special treatment for case with Suzaku PIN
#tclout datagrp
#scan $xspec_tclout "%i" ngroup
#if {[llength $args] == 0 && $ngroup == 2} {
#    set igthe [exec /bin/bash -c "paste ErangeXIS.txt ErangePIN.txt | gawk -F- '{print \"**-\"\$2\" \"\$3\"-\"\$5\"-**\"}' | gawk '{print \$1\" \"\$2\"-\"\$3\" \"\$4\" \"\$5}'"]
#    ignore $igthe
#
#    set lo [exec /bin/bash -c "echo $igthe | gawk -F- '{print \$2}' | gawk '{print \$1}'"]
#    set hi [exec /bin/bash -c "echo $igthe | gawk -F- '{print \$(NF-1)}' | gawk '{print \$NF}'"]
#    
#}
#	#

   
	setplotclean


	setplot command window 1
	setplot command re x $lo $hi
	plot
	
	#Write out
	set out [open "TEMP_xlow.txt" "w"]
	puts $out [format "%f" $lo]
	close $out
	set out [open "TEMP_xhi.txt" "w"]
	puts $out [format "%f" $hi]
	close $out
	
    #auto y-extent
    ##############
    file delete wfile.pco wdata.pco wdata.txt wfull.qdp  wshort

    set xlo $lo
    set xhi $hi

    set full "[expr { round(1000.*rand()) }]wdata"
    setplot command wdata $full
    plot

    exec cp $full.qdp wfull

    #Select only relevant x-region
    exec /bin/bash -c "gawk '{if (NR>3 && \$1 >= xl && \$1<= xh && \$0\!~\"NO\") {print}}' xl=$xlo xh=$xhi  wfull >  wshort"

    #Identify max/min data value in column 3
    set yhi [exec /bin/bash -c "sort -rgk 3,3 wshort | gawk '{if (NR==1) {print \$3+\$4}}'"]
    set ylo [exec /bin/bash -c "sort -gk 3,3 wshort | gawk '{if (NR==1) {print \$3-\$4}}'"]
	
    setplotclean
	
    setplot command window 1
    setplot command re y $ylo $yhi
    plot
	
    file delete wfile.pco wdata.pco wdata.txt $full.qdp  wfull.qdp wfull.pco wshort 
	
}
