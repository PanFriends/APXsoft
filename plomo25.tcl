proc plomo25 {xcmfile} {

#For MULTIPLE observations, run in single obs*/ADD dir

#Just plot this model

@$xcmfile
this25m
@$xcmfile
plot
fadd 7
ylow 1e-3

#Write out low and high limit from xcmfile name
exec /bin/sh -c "getlim.bash $xcmfile"

}
