proc getparval {parname} {

    #findmyt or findsph must have run
    #Find parameter number from database and then its value

    #getparval nhz
    
    set npar [getnpar $parname]
    tclout param $npar
    scan $xspec_tclout "%e" val

    return $val
}

    
