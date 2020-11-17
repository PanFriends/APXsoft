proc svall {xcmfile} {
    #5/2018: Also modify /tmp/logname.log
    #12/2019: screenshot fit.xcm.png for fit.xcm

    if {[ string first ".xcm" $xcmfile ] == -1 } {
	set xcmfile $xcmfile.xcm
    }

    file delete $xcmfile
    save all $xcmfile

    set lfile "/tmp/logname.log"
    set profile "/tmp/prosvallfile"
    exec gawk { {if(NR==2) {print x} else {print}} } x=$xcmfile $lfile > $profile
    exec mv $profile $lfile

    #Screenshot:
    exec /bin/bash -c "id=\$(wmctrl -l | grep PGPLOT | grep Window | gawk '{printf \" \"\$1\" \"}' | gawk '{print \$NF}') ; wmctrl  -i -a \$id; sleep 0.5; gnome-screenshot  -w -B -f $xcmfile.png
"
    #Paremeters in neat format as on screen:
    exec sparam $xcmfile
}
