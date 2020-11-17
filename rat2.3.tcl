proc rat2.3 {} {

    #Measure ratio of counts at ~6 vs. the min (if any) at lower energies.
    #Used to classify spectrum as useful or not for C-thin paper.

    #Here "lower" is 2.3-5.0 keV
    
    #xcm or data file must be loaded

    set allresults $::env(HOME)/notes/ADAP17/CTHIN/reject2.3.txt
    set results reject.txt
    set dir $::env(HOME)/notes/ADAP17/CTHIN/REJECT2.3png
    
    #Redshift
    set z [exec more z.txt]
    set stub [exec more stub.txt]
    
    #Low range
    #set e1 [expr 0.6/(1+$z)]
    set e1 2.3
    #set e2 [expr 5.79/(1+$z)]
    set e2 5.0
    
    #Red side of line
    set e3 5.8
    set e4 6.0

    #Write out data
    set full "/tmp/[expr { round(1000.*rand()) }]wdata"
    set wfull "/tmp/[expr { round(1000.*rand()) }]wfull"
    setplot command wdata $full
    plot data
    exec cp $full.qdp $wfull

    set we1e2 "/tmp/[expr { round(1000.*rand()) }]we1e2"
    set we3e4 "/tmp/[expr { round(1000.*rand()) }]we3e4"
    #Select regions
    exec /bin/bash -c "gawk '{if (NR>3 && \$1 >= xl && \$1<= xh && \$0\!~\"NO\") {print}}' xl=$e1 xh=$e2  $wfull >  $we1e2"
    exec /bin/bash -c "gawk '{if (NR>3 && \$1 >= xl && \$1<= xh && \$0\!~\"NO\") {print}}' xl=$e3 xh=$e4  $wfull >  $we3e4"

    setplotclean
    plot ldata
    xlohi
    
    #Identify min in region we1e2
    scan [exec /bin/bash -c "sort -gk 3,3 $we1e2 | gawk '{if (NR==1) {print \$3-\$4, \$1}}'"] "%f %f" min12 xmin12
    
    #Identify max in region we3e4
    scan [exec /bin/bash -c "sort -rgk 3,3 $we3e4 | gawk '{if (NR==1) {print \$3+\$4, \$1}}'"] "%f %f" max34 xmax34


    #Plot vertical lines for limits
    #setplot command label 10 position $e1 1e-10
    #setplot command label 10 color 1 lstyle 2 lwidth 5 line 90 10000
    #
    #setplot command label 20 position $e2 1e-10
    #setplot command label 20 color 1 lstyle 2 lwidth 5 line 90 10000
    #
    #setplot command label 30 position $e3 1e-10
    #setplot command label 30 color 2 lstyle 2 lwidth 5 line 90 10000
    #
    #setplot command label 40 position $e4 1e-10
    #setplot command label 40 color 2 lstyle 2 lwidth 5 line 90 10000

    #Plot vertical lines for min/max
    setplot command label 10 position $xmin12 1e-10
    setplot command label 10 color 1 lstyle 2 lwidth 5 line 90 10000
    setplot command label 20 position $xmax34 1e-10
    setplot command label 20 color 2 lstyle 2 lwidth 5 line 90 10000

    
    plot
    setplotclean

    set ratio [expr $max34/$min12]
    puts [format "%.2f-%.2f MIN %.2e at %.2f keV" $e1 $e2 $min12 $xmin12]
    puts [format "%.2f-%.2f MAX %.2e at %.2f keV" $e3 $e4 $max34 $xmax34]
    puts [format "RATIO high/low = %.2e" $ratio]
    if {$min12 < $max34} {
	puts [format "MIN %.2e < MAX %.2e → SELECT" $min12 $max34]
	set reject 1
    } else {
	puts [format "MIN %.2e ≥ MAX %.2e → REJECT" $min12 $max34]
	set reject 0
    }

    set out [open $allresults a]
    puts $out [format "%-30s %.2f-%.2f %.2f-%.2f  %.2e %.2f %.2e %.2f    %.2e %i" $stub $e1 $e2 $e3 $e4 $min12 $xmin12 $max34 $xmax34 $ratio $reject]
    close $out
    
    set out [open $results w]
    puts $out [format "%-30s %.2f-%.2f %.2f-%.2f  %.2e %.2f %.2e %.2f    %.2e %i" $stub $e1 $e2 $e3 $e4 $min12 $xmin12 $max34 $xmax34 $ratio $reject]
    close $out

    #Screenshot
    exec import -window "PGPLOT Window 1" $dir/$stub.png
    exec $::env(HOME)/bin/s2u $dir/$stub.png
}
