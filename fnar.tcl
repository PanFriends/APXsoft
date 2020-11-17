proc fnar {comp} {

#Freeze to 8.5e-4 the gaussian sig of the component
tclout compinfo $comp
scan $xspec_tclout "%s %i %i" name firstpar npars

#Need firstpar+1
set par $firstpar
newpar $par 8.5e-4
freeze $par
show
plot
}
