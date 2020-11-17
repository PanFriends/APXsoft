proc chasolim {par val uperr loerr} {

    #chasolim 2 .025 .037  .011
    #            val uperr loerr
    #Calculate and set hard and soft lower/upper limits for fitting
    #hard/soft limits set to be equal
    #
    #Value within these limits must also be given, and will be set.

    set solo [ expr $val-$loerr ]
    set halo $solo
    set sohi [ expr $val+$uperr ]
    set hahi $sohi

    puts [format "Range set: %.4f %.4f %.4f %.4f"  $solo $halo $sohi $hahi]
    newpar $par $val ,, $halo $solo $sohi $hahi

}

    
