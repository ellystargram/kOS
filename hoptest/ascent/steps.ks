FUNCTION ascent_step_setLiftOffThrottle {
    PRINT "Setting lift-off throttle...".
    SET standard_scalar_throttle TO 1.0.
    SET standard_scalar_step TO FALSE.
}

FUNCTION ascent_step_releaseClamp {
    PRINT "Releasing clamps...".
    LOCAL parts_clamp TO SHIP:PARTSTAGGED("S0TE").
    IF (parts_clamp:LENGTH <> 0) {
        LOCAL part_clamp TO parts_clamp[0].
        LOCAL modules_clampActions TO part_clamp:GETMODULE("LaunchClamp").
        modules_clampActions:DOEVENT("release clamp").
    } ELSE {
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION ascent_step_towerClear {
    LOCAL scalar_ascent_altitude TO SHIP:ALTITUDE - ascent_scalar_liftOffStartAltitude.
    IF (scalar_ascent_altitude > ascent_scalar_towerHeight) {
        PRINT "Tower cleared.".
        SET standard_scalar_step TO FALSE.
        SET ascent_scalar_maxAscentSpeed TO SHIP:VERTICALSPEED.
    }
}

FUNCTION ascent_step_gotoAltitude {
    PRINT "Ascending to target altitude...".
    LOCAL scalar_altitudeError TO ascent_scalar_targetAltitude - ALT:RADAR.
    SET ascent_pidloop_ascentSpeedControl:SETPOINT TO ascent_scalar_targetAltitude.
    SET standard_scalar_throttle TO standard_scalar_valueRangeSafety(ascent_pidloop_ascentSpeedControl:UPDATE(TIME:SECONDS, ALT:RADAR), 0.01, 1.0).
    IF (ABS(scalar_altitudeError) < 0.5 AND ABS(SHIP:VERTICALSPEED) < 0.5) {
        SET standard_scalar_step TO FALSE.
        PRINT "Reached target altitude.".
    }
}