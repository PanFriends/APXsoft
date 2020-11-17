proc missout {} {

    
    #Suzaku or NuSTAR

    #Naming:
    set fin  "/tmp/logname.log"
    set name [exec gawk {{if(NR==1) {print $1}}} $fin]
    set obs  [exec gawk {{if(NR==1) {print $2}}} $fin]
    
    set xcm  [exec gawk -F.xcm {{if(NR==2) {print $1}}} $fin]

    set suffix ${name}_${obs}_${xcm}

    exec pwd > pwd.txt
#    set mission [exec gawk {{if($0~"SUZ") {print "& \\suzaku\\ "}}} pwd.txt]
    set mission [exec gawk {{if($0~"SUZ") {print "& \\suzaku\\ "} else if($0~"STAR") {print "& \\nustar\\ "}}} pwd.txt]


    set outtex [open "r01_$suffix.tex" "w"]
    puts $outtex $mission
    close $outtex
    exec more r01_$suffix.tex
    

}
