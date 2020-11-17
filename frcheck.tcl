proc frcheck {par} {

#frcheck 18

#Check if this parameter is frozen

file delete frcheck.xcm
save all frcheck.xcm
exec /bin/sh -c "frcheck.sh $par"
file delete frcheck.xcm

}
