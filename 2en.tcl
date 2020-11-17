proc 2en {} {

#Switch plot to energy converting limits as well

tclout notice
scan $xspec_tclout "%i-%i" locha hicha

tclout filename 1
scan $xspec_tclout "%s" data

#set data [exec /bin/sh -c "ls *heg_m1p1_b0100.pha" ]
set loen [exec /bin/sh -c "cha2en $locha $data"]
set hien [exec /bin/sh -c "cha2en $hicha $data"]

setplot energy
setplot command rescale x $loen $hien
setplot command re y 1e-3 5

plot
      }
