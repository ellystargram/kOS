local countDownClock to 10.

local s1MaxThrustSL to 335.6. //kn
local rocketWeight to ship:mass * CURRENTBODYG.

clearScreen.
print "STATUS: COUNTDOWN" at (0, 0).

until countDownClock = 0 {
    
    print "T-" + countDownClock + "  " at (0, 1).

    if countDownClock <= 3 {
        print("Ignition").
        lock throttle to 1.
    }

    if countDownClock = 3 {
        stage.
    }

    wait(1).
    set countDownClock to countDownClock - 1.
}

if ship:availablethrustat(1) < rocketWeight {
    clearScreen.
    print "STATUS: TWR LOW" at (0, 0).
    lock throttle to 0.
    set clockRollingEnabled to false.
}