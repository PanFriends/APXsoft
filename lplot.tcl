proc lplot {} {

    #Plot last x-y plot version

    if {[file exists ~/.xspec/lastXY.log]==1} {
	set fxy [open ~/.xspec/lastXY.log r]
	set input [read $fxy]
	set todo $input
	plot $todo
    }
}
 
