proc pargauss {} {

#When gaussian added at end of model, the phabs does not include it.
#This just does this mundane operation.

svall /tmp/provgauss.xcm
exec pargauss.sh
@/tmp/provgauss.xcm
show all
plot

}
