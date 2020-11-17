proc wfinal {model} {

#Write final qdp and pco files for data, ratio, ufspec

#wfinal sph100


    set namestub [exec setfinalname.bash]

    
plot data
setplot command whead $namestub\_$model\_data
setplot command wdata $namestub\_$model\_data
plot


plot ratio
setplot command whead $namestub\_$model\_ratio
setplot command wdata $namestub\_$model\_ratio
plot

plot ufspec
setplot command whead $namestub\_$model\_ufspec
setplot command wdata $namestub\_$model\_ufspec
plot


}
