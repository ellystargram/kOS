global lock LDConfirmKey to AG10.
global clockRollingEnabled to false.
global lock LDDenyKey to AG9.

global targetOrbitAP to 2600000.
global targetOrbitPE to 2000000.
global targetOrbitAttachment to 2600000.
global targetOrbitINC to 0.

global lock CURRENTBODY to ship:body.
global lock CURRENTBODYDISTANCE to CURRENTBODY:radius + ship:altitude.
global lock CURRENTBODYG to CURRENTBODY:mu / (CURRENTBODYDISTANCE ^ 2).

on LDConfirmKey {
    set clockRollingEnabled to true.
}

on LDDenyKey {
    reboot.
}

clearScreen.
print "FALCON 1 ORBITING SOFTWARE V1".
print "AP: " + targetOrbitAP + "m".
print "PE: " + targetOrbitPE + "m".
print "AT: " + targetOrbitAttachment + "m".
print "INC: " + targetOrbitINC + "°".
print "PRESS LD Confirm Key to Start".

until clockRollingEnabled {
    wait(0.1).
}

if clockRollingEnabled {
    runpath("0:/falcon1/prelaunch.ks").
}