proc setplotclean {} {

    set logfile "/tmp/[expr { round(1000.*rand()) }]XSPEC.log"
    chatter 0
    log $logfile
    setplot list
    log none
    set ndel [exec /bin/bash -c "grep wdata $logfile | gawk '{print \$2}' | gawk -F\: '{print \$1}'"]
    setplot delete $ndel
    chatter 10
    plot

}
