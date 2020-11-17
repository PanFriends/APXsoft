proc 2wa {} {

#Switch plot to wave converting limits as well

set keVtoA 12.4075

tclout notice
scan $xspec_tclout "%i-%i" locha hicha

tclout filename 1
scan $xspec_tclout "%s" data

set loen [exec /bin/sh -c "cha2en $locha $data"]
set hien [exec /bin/sh -c "cha2en $hicha $data"]

set lowa [expr $keVtoA/$hien]
set hiwa [expr $keVtoA/$loen]



setplot wave
setplot command rescale x $lowa $hiwa
setplot command re y 1e-20 1e-17


plot
      }
