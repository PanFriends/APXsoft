proc errpng {text} {


#errout produces u.png l.png
#Rename accordingly

    if {[file exists u.png]==1} {
	exec mv u.png $text\_u.png
    }
    if {[file exists l.png]==1} {
	exec mv l.png $text\_l.png
    }










}
