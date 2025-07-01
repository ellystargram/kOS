clearScreen.
set xValocity to 0.0.
set yValocity to 0.0.

//countdown
set countDown to 5.
lock throttle to 0.
until countDown = 0 {
    clearScreen.
    print("Countdown: " + countDown).
    if countDown <= 3 {
        print("Ignition").
        lock throttle to 1.
    }
    if countDown = 3 {
        stage.
    }
    set countDown to countDown - 1.
    wait(1).
}
//check twr
set twr to maxThrust / (mass * 9.81).
if twr < 1.5 {
    print("TWR is too low").
    lock throttle to 0.
}
else {
    print("TWR is good").
    print("Launch").
    stage.
    flightProfile.
}

function flightProfile{
    towerClear.
    gravityTurn(0, 100000, 100000).
}

function towerClear{
    set pointing to heading(90, 90).
    lock steering to pointing.

    set isClearedTower to false.
    until isClearedTower {
        if alt:radar > 100 {
            set isClearedTower to true.
        }
        wait(0.1).
    }
}

function gravityTurn{
    declare parameter INC.
    declare parameter AP.
    declare parameter PE.

    set targetApoapsis to AP.
    set targetPeriapsis to PE.
    set targetInclination to INC.

    until alt:apoapsis > targetApoapsis {
        set pitch to 90 - 90 * (alt:radar / targetApoapsis).
        set heading to targetInclination.
        set pointing to heading(heading, pitch).
        lock steering to pointing.
        wait(0.1).
    }
}