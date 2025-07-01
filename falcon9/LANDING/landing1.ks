print "V0.0.1 TARGETED LANDING SOFTWARE".

global abortReason to "NOT ABORTED YET".
global aborted to false.
global tClockSeconds to 0.
set defaultRadarAltitudeOffset to alt:radar.
lock radarAltitude to alt:radar - defaultRadarAltitudeOffset.

lock CURRENTBODY to ship:body.
lock CURRENTBODYDISTANCE to CURRENTBODY:radius + ship:altitude.
lock CURRENTBODYG to CURRENTBODY:mu / (CURRENTBODYDISTANCE ^ 2).

set aborted to false.
set abortReason to "NOT ABORTED".
set abortAction to 0.
// 0. NOT ABORTED
// 1. DO NOT LIFTOFF
// 2. PAD AVOID CRASH.
// 3. OFFSHORE DIVERT.

lock stageMaxThrustSL to 673.2.
lock stageMinThrustSL to 263.
lock stageEngineIgnitionTime to 2.6.

function map {
    parameter fromValue.
    parameter fromMin.
    parameter fromMax.
    parameter toMin.
    parameter toMax.

    return (fromValue - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin.
}

function liftoffBeforeAbortCheck {
    lock liftoffMass to ship:mass.
    lock liftoffWeight to liftoffMass * CURRENTBODYG.
    lock dryMass to ship:drymass.
    lock dryWeight to dryMass * CURRENTBODYG.

    if liftoffWeight <= stageMinThrustSL {
        set aborted to true.
        set abortReason to "Liftoff weight is lower than minimum thrust. So we can't land.".
    } else if liftoffWeight >= stageMaxThrustSL {
        set aborted to true.
        set abortReason to "Liftoff weight is greater than maximum thrust. So we can't liftoff.".
    } else if dryWeight >= stageMaxThrustSL {
        set aborted to true.
        set abortReason to "Dry weight is greater than maximum thrust. So we can't liftoff.".
    } 

    if aborted {
        set abortAction to 1.
        return.
    }
}

function liftoffCountdown {
    clearScreen.
    until tClockSeconds >= 0 or aborted {
        print "STATUS: COUNTDOWN" at (0, 0).
        print "T " + tClockSeconds at (0, 1).
        liftoffBeforeAbortCheck().

        if tClockSeconds = (0 - round(stageEngineIgnitionTime)) {
            //go for enginestart
            print "GO FOR ENGINE START" at (0, 2).
            stage.
            lock throttle to 0.01.
        }
        wait 1.
        set tClockSeconds to tClockSeconds + 1.
    }

    // FINAL LIFTOFF CHECK
    if ship:thrust = 0 and not aborted {
        set aborted to true.
        set abortReason to "ENGINE IGNITION FAIL".
        set abortAction to 1.
    }
}

function padClear {
    clearScreen.
    set gear to false.
    set accentAccelationLimit to CURRENTBODYG * 1.5. //1.5g
    lock accentEndRadarAltitude to 15000.
    // local liftoffRoll to ship:direction:roll.
    // local liftoffHeading to ship:heading.

    lock vesselMass to ship:mass.
    lock vesselWeight to vesselMass * CURRENTBODYG.

    until radarAltitude >= accentEndRadarAltitude or aborted {
        print "STATUS: PAD_CLEARING" at (0, 0).
        // throttle control part
        
        set vesselMaxAccelation to stageMaxThrustSL / vesselMass.
        set accentThrottle to 1.
        set requiredThrust to stageMaxThrustSL.
        
        if vesselMaxAccelation > accentAccelationLimit {
            set requiredThrust to vesselWeight * accentAccelationLimit.
            set accentThrottle to map(requiredThrust, stageMinThrustSL, stageMaxThrustSL, 0.01, 1.0).
        }
        lock throttle to accentThrottle.
        print "THROTTLE: " + (accentThrottle*100) + "%" at (0, 1). 
        print "TWR: " + (requiredThrust / vesselWeight) at (0, 2).

        // direction control part
        local liftoffPitch to up.
        local accentDirection to HEADING(90, 90, 0).
        lock steering to accentDirection.

        if ship:deltav:current <= 300 {
            set aborted to true.
            set abortReason to "NOT ENOUGH DELTAV".
            set abortAction to 2.
        }

        print "RADAR ALTITUDE: " + radarAltitude at (0, 3).
    }
}

function hovering {
    clearScreen.
    lock vesselWeight to ship:mass * CURRENTBODYG.
    lock requiredThrust to vesselWeight * 0.6.
    lock requiredThrottle to map(requiredThrust, stageMinThrustSL, stageMaxThrustSL, 0.01, 1.0).
    lock throttle to requiredThrottle.
    lock steering to up.
    
    until ship:verticalSpeed <=0 {
        print "STATUS: HOVERING" at (0, 0).
        print "THROTTLE: " + (throttle*100) + "%" at (0, 1). 
        print "TWR: " + (requiredThrust / vesselWeight) at (0, 2).
        print "VW: " + vesselWeight + "kn" at (0, 3).
        print "RT: " + requiredThrust + "kn" at (0, 4).
    }
}

from {local i to 0.} until i>10 step {set i to i + 1.} do {
    print i.
}

function accent {
    padClear().
    hovering().
}

function landingGuide {
    //TODO LATER
    //wait(2).
}

function descending {
    clearScreen.
    print "STATUS: DESCENDING" at (0, 0).
    set brakes to true.
    local gridfins to SHIP:partstagged("S1_GRIDFIN").
    for gridfin in gridfins {
        .
    }   
    set STEERINGMANAGER:pitchtorquefactor to 5.
    set STEERINGMANAGER:yawtorquefactor to 5.
    set STEERINGMANAGER:rolltorquefactor to 5.
    set STEERINGMANAGER:MAXSTOPPINGTIME to 1.
    set steeringManager:pitchts to 5.
    set steeringManager:yawts to 5.
    set steeringManager:rollts to 5.

    lock vesselWeight to ship:mass * CURRENTBODYG.
    lock vesselEngineAccelationMax to (ship:maxThrust * 0.8 - vesselWeight) / ship:mass.
    lock finalDecelSpeed to 2.
    lock decelCompleteRadarAltitude to 10.
    lock decelDistance to ((ship:velocity:surface:mag ^ 2) - (finalDecelSpeed ^ 2)) / (2 * vesselEngineAccelationMax). 
    lock engineStartTimeMove to stageEngineIgnitionTime * ship:velocity:surface:mag.
    lock throttle to 0.
    until radarAltitude <= decelCompleteRadarAltitude + decelDistance + engineStartTimeMove {
        print "ALT: " + radarAltitude at (0, 1).
        print "DECELSTARTAT: " + (decelCompleteRadarAltitude + decelDistance) at (0, 2).
        if ship:velocity:surface:mag > 20 {
            lock steering to srfRetrograde.
        } else {
            lock steering to up.
        }
    }
    set gear to true.

    set STEERINGMANAGER:pitchtorquefactor to 1.
    set STEERINGMANAGER:yawtorquefactor to 1.
    set STEERINGMANAGER:rolltorquefactor to 1.
    set STEERINGMANAGER:MAXSTOPPINGTIME to 2.
    set steeringManager:pitchts to 2.
    set steeringManager:yawts to 2.
    set steeringManager:rollts to 2.


    until ship:velocity:surface:mag <= finalDecelSpeed {
        print "ALT: " + radarAltitude at (0, 1).
        // s = (v^2 - u^2) / 2a
        // 2as = v^2 - u^2
        // a = (v^2 - u^2) / 2s
        // f = ma

        set leftDistance to radarAltitude - decelCompleteRadarAltitude.
        set requiredAccelation to ((ship:velocity:surface:mag ^ 2) - (finalDecelSpeed ^ 2)) / (2 * leftDistance).
        set requiredUpwardThrust to ship:mass * requiredAccelation.
        set rocketWeight to ship:mass * CURRENTBODYG.
        set requiredEngineThrust to rocketWeight + requiredUpwardThrust.
        local requiredEngineThrottle to map(requiredEngineThrust, stageMinThrustSL, stageMaxThrustSL, 0.01, 1.0).

        if requiredEngineThrottle > 1.0 {
            print "MAXIMUM PERFORMACE!!!!!" at (0, 5).
        } else if requiredEngineThrottle <= 0 {
            set requiredEngineThrottle to 0.01.
        }
        lock throttle to requiredEngineThrottle.
        
        print "THROTTLE: " + (requiredEngineThrottle*100) + "%" at (0, 2).
        print "Landing Burn Thrust: " + requiredEngineThrust + "kn" at (0, 3).

        if ship:velocity:surface:mag > 20 {
            lock steering to srfRetrograde.
        } else {
            lock steering to up.
        }
    }
}

function finalTouchdown {
    clearScreen.
    lock targetTouchdownVSpeed to -1.
    lock targetTouchdownVSpeedAccept to 0.5.
    lock targetTouchdownHSpeed to 0.5.
    until ship:verticalSpeed >= 0 or radarAltitude <= 0 or aborted {
        print "STATUS: FINAL_TOUCHDOWN" at (0, 0).
        if targetTouchdownHSpeed < ship:groundspeed {
            set aborted to true.
            set abortReason to "TO MUCH HORIZONTAL SPEED for Final Touchdown.".
            set abortAction to 2.
        }
        lock steering to up.

        local vesselMass to ship:mass.
        local vesselWeight to vesselMass * CURRENTBODYG.

        local landingThrottle to 1.
        lock hoverThrottle to map(vesselWeight, stageMinThrustSL, stageMaxThrustSL, 0.0, 1.0).
        if ship:verticalSpeed < targetTouchdownVSpeed - targetTouchdownVSpeedAccept {
            set landingThrottle to 1.
        } else if ship:verticalspeed >= targetTouchdownVSpeed - targetTouchdownVSpeedAccept and ship:verticalspeed <= targetTouchdownVSpeed + targetTouchdownVSpeedAccept {
            set landingThrottle to hoverThrottle.
        } else {
            set landingThrottle to 0.01.
        }

        lock throttle to landingThrottle.
    }
    lock throttle to 0.
    set brakes to false.
}

function landing {
    // landingGuide().
    descending().
    finalTouchdown().
}

function inFlight {
    if aborted {return.}
    accent().
    landing().
}

set tClockSeconds to -10.

liftoffCountdown().

clearScreen.

inFlight().

if aborted {
    clearScreen.
    print "ABORTED: " + abortReason.
    if abortAction = 1 {
        print "ABORTACTION: DO NOT LIFTOFF.".
        lock throttle to 0.
    } else if abortAction = 2 {
        print "ABORTACTION: PAD AVOID CRASH.".
        local vesselWeight to ship:mass * CURRENTBODYG.
        local vesselMaxTWR to  stageMaxThrustSL / vesselWeight.
        local padAvoidAngleRadian to arcSin(1/vesselMaxTWR).
        local padAvoidAngleDegree to padAvoidAngleRadian * constant:radtodeg.
        local avoidDirection to heading(90, padAvoidAngleDegree, 0).
        lock steering to avoidDirection.
        lock throttle to 1.
        until false.
    }
}
