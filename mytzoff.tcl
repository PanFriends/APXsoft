proc mytzoff {} {

    #In loaded model replace MYtorusZ with zphabs and tie redshift correctly, assuming zpowerlw for Z component comes right after MYtorusZ.


    findmyt
    scan [ exec more /home/pana/.xspec/nhz.var ] "%s %i %i" dum nhzpar nhzmod
    scan [ exec more /home/pana/.xspec/norm.var ] "%s %i %i" dum normpar normmod
    set old_zpoz [expr $normpar-1]
    set new_zpoz [expr $old_zpoz-1]
    scan [ exec more /home/pana/.xspec/z.var ] "%s %i %i" dum zpar zmod
    tclout param $zpar
    scan $xspec_tclout "%f" zval
    
    delcomp $nhzmod
    set zphabsmod $nhzmod
    addcomp $zphabsmod zphabs & 1 & $zval

    newpar $new_zpoz=3
    show
}
