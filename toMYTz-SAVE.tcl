proc toMYTz {} {

    #Convert zphabs to MYTorusZ, using same NH and z values

    #For more than one data group there will be extra xnorm
    #component in front!
    tclout datagrp
    scan $xspec_tclout "%i" ngroup


    findmyt
    
    set par nhz
    set npar_nhz [exec more /home/pana/.xspec/$par.var | gawk {{print $2}}]
    set ncomp_nhz [exec more /home/pana/.xspec/$par.var | gawk {{print $3}}]
    tclout param $npar_nhz
    scan $xspec_tclout "%f" nhval1
    set nhval2 [expr $nhval1/100.]
   
    set par z
    set npar_z [exec more /home/pana/.xspec/$par.var | gawk {{print $2}}]
    set ncomp_z [exec more /home/pana/.xspec/$par.var | gawk {{print $3}}]
    tclout param $npar_z
    scan $xspec_tclout "%f %f %f %f %f %f" zval1 zval2 zval3 zval4 zval5 zval6 
    
    #Add a 3-parameter dummy zpowerlw to get parameter numbering right
    set ncomp_dummy $ncomp_nhz
    delcomp $ncomp_nhz
    addcomp $ncomp_dummy zpowerlw & 1 & 1 & 1

    #Replace dummy with mytz
    sprov
 
    exec /bin/bash -c " sed 's/phabs(zpowerlw/phabs(etable\\{\\/home\\/pana\\/\.xspec\\/myModels\\/mytorus_Ezero_v00.fits\\}/' prov.xcm > prov2.xcm "
    exec /bin/bash -c " sed 's/mytorus_Ezero_v00.fits\\} + zpowerlw/mytorus_Ezero_v00.fits\\}\*zpowerlw/' prov2.xcm > prov2A.xcm "

    set model_line [exec /bin/bash -c " gawk '{if(\$1~\"model\") {print NR}}' prov2A.xcm "]
    if { $ngroup == 1 } {
	set nhz_line [expr $model_line+2]
        set incang_line [expr $model_line+3]
	set z_line [expr $model_line+4]
    }
    if { $ngroup == 2 } {
	set nhz_line [expr $model_line+3]
        set incang_line [expr $model_line+4]
	set z_line [expr $model_line+5]
    }
    
    exec /bin/bash -c " gawk '{if(NR==l) {print \"              \"nh\"       0.01         -3         -2          9         10\"} else {print}}' l=$nhz_line nh=$nhval2 prov2A.xcm > prov3.xcm"
    exec /bin/bash -c " gawk '{if(NR==l) {print \"             90         -1          0       18.2       87.1         90\"} else {print}}' l=$incang_line prov3.xcm > prov4.xcm"
    exec /bin/bash -c " gawk '{if(NR==l) {print \"       \"z1\"       \"z2\"     \"z3\"     \"z4\"         \"z5\"         \"z6} else {print}}' z1=$zval1 z2=$zval2 z3=$zval3 z4=$zval4 z5=$zval5 z6=$zval6 l=$z_line prov4.xcm > prov5.xcm"


    
    @prov5.xcm
    



}
