proc xcmrate {xcmfile} {

    #Rate for data 1 and data 2

    @$xcmfile
    tclout rate 1
    #puts $xspec_tclout
    scan $xspec_tclout "%f %f %f %f" crate err mo percent









}
