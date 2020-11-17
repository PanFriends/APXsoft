proc linterp {xl xh yl yh x} {

#Linear interpolation gives y = yl + (yh - yl) * (x - xl) / (xh - xl)

    set y [expr $yl + ($yh - $yl) * ($x - $xl) / ($xh - $xl)]
#    puts [format "%.8e" $y]
    return $y


}


