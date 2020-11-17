proc ufit {} {

#name strings
set objname [exec more stub.txt]
set obs $::env(otex[exec more stub.txt])
set obs [lindex [split $obs ~] 2]



if {[file exists "refreeze.txt"]==1} {
file delete refreeze.txt

}

#my or sph?
tclout model
set modeltype $xspec_tclout


if { [string first "sphere" $modeltype] > 0 } {
set type "sph"

#Identify frozen sometimes-frozen-parameters (sfps)

show all

#sig
findncomp gsmooth

set npar1 [exec more npar1.txt]
set ngsmooth $npar1
file delete npar1.txt

frcheck $ngsmooth
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $ngsmooth sig"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $ngsmooth >> refreeze.txt
}
}

#Γ sph
findncomp trans
set npar1 [exec more npar1.txt]
set nPho [expr $npar1+1]
file delete npar1.txt

frcheck $nPho
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $nPho PhoIndex"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $nPho >> refreeze.txt
}
}

#z
set nz [expr $npar1+4]

frcheck $nz
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $nz z"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $nz >> refreeze.txt
}
}





} else {
set type "myun"

#Identify sfps

#puts $npar
show all

#NH_Z
findncomp MYtorusZ
if {[file exists "npar1.txt"]==1} {
set npar1 [exec more npar1.txt]
set nNHZ $npar1

frcheck $nNHZ
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen $nNHZ NH_Z"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $nNHZ >> refreeze.txt
}
}

} 

#NH_S
findncomp MYtorusS
set npar1 [exec more npar1.txt]
set nNHS $npar1

frcheck $nNHS
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen $nNHS NH_S"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else { 
echo $nNHS >> refreeze.txt
}
}


#Γ_Z
set ngamz [expr $npar1-4]

frcheck $ngamz
set frozen [exec more frcheck.txt]
file delete frcheck.txt

if {$frozen == 1} {
puts "frozen $ngamz Gamma_Z"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $ngamz >> refreeze.txt
}
}




#As
set nconst [expr $npar1-1]

frcheck $nconst
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $nconst A_S"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $nconst >> refreeze.txt
}
}

#Γ_S
set ngams [expr $npar1+2]

frcheck $ngams
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $ngams Gamma_S"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $ngams >> refreeze.txt
}
}

#z
set nz [expr $npar1+3]

frcheck $nz
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $nz z"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $nz >> refreeze.txt
}
}


#sig
findncomp gsmooth

set npar1 [exec more npar1.txt]
set ngsmooth $npar1
file delete npar1.txt

frcheck $ngsmooth
set frozen [exec more frcheck.txt]
file delete npar1.txt

if {$frozen == 1} {
puts "frozen $ngsmooth sig"
set ans [gets stdin]
if {$ans > 0} {
puts "Not unfreezing" 
} else {
echo $ngsmooth >> refreeze.txt
}
}




} 


#Common for both sph and myun:
#Unfreeze
if {[file exists "refreeze.txt"]==1} {
puts unfreezing
chatter 0

set fp [open "refreeze.txt" r]
while {[gets $fp data] >=0} {
puts "thaw $data"
thaw $data
}


}

#fit
puts "fit"
chatter 10
fit

puts "kgood"

kgood
puts "statout"
statout

if {[file exists "refreeze.txt"]==1} {
puts "save unfrozen"

if {[string equal "sph" $type] == 1} {
save all "sph25_2.4_8.0_u.xcm"
#For TY
exec cp sph25_2.4_8.0_u.xcm $objname\_$obs\_sph25\_2.4\_8.0\_u.xcm
exec tablepath $objname\_$obs\_sph25\_2.4\_8.0\_u.xcm
echo $objname\_$obs\_sph25\_2.4\_8.0\_u.xcm > FILES_ufit_$type.txt
} else {
save all "myun25_2.4_8.0_u.xcm"
#For TY
exec cp myun25_2.4_8.0_u.xcm $objname\_$obs\_myun25\_2.4\_8.0\_u.xcm
exec tablepath $objname\_$obs\_myun25\_2.4\_8.0\_u.xcm
echo $objname\_$obs\_myun25\_2.4\_8.0\_u.xcm > FILES_ufit_$type.txt
}

puts refreeze
chatter 0
set fp [open "refreeze.txt" r]
while {[gets $fp data] >=0} {
puts "freeze $data"
freeze $data
}

chatter 10
show

puts "save frozen"
if {[string equal "sph" $type] == 1} {
exec msn s 2.4
puts "FILES"
ls sph25_2.4_8.0_u.xcm sph25_2.4_8.0.xcm
} else {
exec msn m 2.4
puts "FILES"
ls myun25_2.4_8.0_u.xcm myun25_2.4_8.0.xcm
}
sfin

puts "sfps"
exec more refreeze.txt
} else {
#just usual sfin
if {[file exists "FILES_ufit_$type.txt"]==1} {
    file delete "FILES_ufit_$type.txt"}
sfin
}






}






















