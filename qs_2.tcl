proc qs {par lo hi {niter 5}} {

#Quick steppar with memory
#Ends when $lo=0

file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty

set slo "a"
set i $niter
while { [string first "o" $slo] == -1 } {
        setplot delete all
	steppar $par $lo $hi $i

        #Write out steps for statistic, delta-statistic, param
        stepw $par prov
        exec paste stepstat.txt delstat.txt prov > prov2
	exec /bin/sh -c "zoomcen.sh prov2"
	#Get the value at the minimum
	set value [exec more zoomcenval.txt]

	#Plot
	plot contour
        exec provcon.sh
        setplot command @wfile
        plot
        setplot delete all

	#Adjust the min y for plotting
	exec ypco.sh
#        exec /bin/bash -c "rokular idl_par_stat &"
#        exec /bin/bash "okular idl_par_stat.pdf > /dev/null 2>&1"
#        exec /bin/sh -c "/usr/local/bin/pdfxcview idl_par_stat.pdf &"

        set this [exec pwd]
        puts "okular $this/idl_par_stat.pdf &"
        set pinfo [exec more provstat.txt]
        puts " "
        puts $pinfo

	puts "newpar $par $value"
	puts [format "more? (%.3e %.3e %i -- o ends)" $lo $hi $i]
	set ans [gets stdin]
	scan $ans "%f %f %i" lo hi i
        scan $ans "%s %s %s" slo shi si
	file delete provcon.qdp provstat.txt provcon.pco wfile.pco ~/.xspec/xspec.hty
  
  }


show









}
