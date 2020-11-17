proc ra {la} {

#ra 5

#Slide right by 5A

file delete slide.pco slide.qdp
set out [open "wfile.pco" "w"]
puts $out  "wdata slide"
close $out

setplot command @wfile

setplotdelete


plot











}
