proc kgood {} {

    chatter 1
    tclout model
    if { [string first "sphere" $xspec_tclout] > 0 } {
    set type sph
    }
    if { [string first "mytorus" $xspec_tclout] > 0 } {
    set type myun
    }

    fit
    chatter 10
    statistic test pchi

#K. Arnaud Sep 26 2016
######################
#The reason for not having cstat available as a test statistic is that
#the statisticians tell me that the same statistic should not be used
#for both fitting and testing (although some statisticians argue that
#tests don't mean anything anyhow). The correct test statistic for
#Poisson data is pchi although that is only strictly correct for the
#case of no background.

    goodness 2000
    tclout goodness
    scan $xspec_tclout "%f" good

    set out [ open "good_$type.txt" "w" ]
    puts $out [ format "%.1f" $good ]
    close $out



}
