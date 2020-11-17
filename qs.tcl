proc qs {par lo hi {niter 5}} {


parallel steppar 4


#Quick steppar with memory
#Ends when $lo=0

file delete provcon.qdp provcon.pco wfile.pco ~/.xspec/xspec.hty

set slo "a"
set i $niter
while { [string equal -nocase "o" $slo] == 0 && [string equal -nocase "l" $slo] == 0 && [string equal -nocase "u" $slo] == 0 && [string equal -nocase "mp" $slo] == 0 && [string equal -nocase "mm" $slo] == 0 } {
        setplot delete all
        thaw $par
	steppar $par $lo $hi $i

        #Write out steps for statistic, delta-statistic, param
        stepw $par prov
        exec paste stepstat.txt delstat.txt prov > prov2
	exec /bin/sh -c "zoomcen.sh prov2"
	#Get the value at the minimum
	set value [exec more zoomcenval.txt]
        set stat  [exec more zoomcenstat.txt]

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

        puts " "


        if {[file exists prevstat.txt]==1} {
	    set prevstat [exec more prevstat.txt]} else {
		set prevstat " "}

        puts "min at stat=$stat ($prevstat)"
        if {[file exists prevval.txt]==1} {
	    set prevval [exec more prevval.txt]} else {
		set prevval " "}

         
        #write out - this will be read at next call and displayed
        set out [open "prevstat.txt" "w"]
        puts $out [format "%.2f" $stat]
        close $out
        #write out - this will be read at next call and displayed
        set out [open "prevval.txt" "w"]
        puts $out [format "%.7f" $value]
        close $out

	puts "newpar $par $value"
        puts "($prevval)"
	puts [format "more? (%.3e %.3e %i -- o end -- l low -- u up -- i niter -- go newpar -- micro mp/mm)" $lo $hi $i]
	set ans [gets stdin]
	scan $ans "%f %f %i" lo hi i
        scan $ans "%s %s %s" slo shi si
	file delete provcon.qdp provstat.txt provcon.pco wfile.pco ~/.xspec/xspec.hty
 

#Just change number of iterations
        if {[string equal -nocase "i" $slo] == 1} {
      
        set i $shi
        }

#Update with suggested parameter value and continue
        if {[string equal -nocase "go" $slo] == 1} {
	newpar $par $value
        }

#while 
}

if {[string  equal -nocase "l" $slo] == 1} {

ql $par
}

if {[string first "u" $slo] == 0} {

qu $par
}

#zoom in about value - and up (positive)
if {[string equal -nocase "mp" $slo] == 1} {

puts "qus $par $shi"
qus $par $shi
}

#zoom in about value - and down (negative)
if {[string equal -nocase "mm" $slo] == 1} {

puts "qus $par $shi"
qls $par $shi
}




if {[string equal -nocase "o" $slo] == 1} {

file delete prevstat.txt prevval.txt
show
}






}
