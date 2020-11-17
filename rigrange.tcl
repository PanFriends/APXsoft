proc rigrange {file} {

    #ignore from ErangeXIS.txt style file which has proper *IGNORE* syntax
    notice all
    set blurb [ exec more $file ]
    ignore $blurb
}
