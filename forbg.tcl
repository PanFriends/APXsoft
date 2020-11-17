proc forbg {pha} {
    #Prepare file forbg.qdp for bg estimates

    data $pha
    setplot energy
    cpd /xs
    file delete wline.pco wline.qdp forbg.qdp forbg.pco
    exec echo wdata forbg > wfile.pco
    setplot command @wfile.pco
    plot counts
    setplot delete all
    file delete wfile.pco
    
}
