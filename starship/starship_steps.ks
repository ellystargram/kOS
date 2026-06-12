FUNCTION step_void_setT0 {
    PRINT "SET T0" AT (0, 0).
    SET standard_timeStamp_terminalCount0Time TO TIME + 5.
    PRINT "T 0 will be at: " + standard_timeStamp_terminalCount0Time:FULL AT (0, 1).
    SET standard_scalar_step TO FALSE.
}

FUNCTION step_void_countDown {
    PRINT "COUNTDOWN" AT (0, 0).
    PRINT "T 0 will be at: " + standard_timeStamp_terminalCount0Time:FULL AT (0, 1).
    
    LOCAL timeStamp_terminalCountTMinus TO standard_timeStamp_terminalCount0Time - TIME.
    PRINT "T-" + timeStamp_terminalCountTMinus:SECONDS AT (0, 2).
    PRINT "Stage 1 engine mode: " + standard_string_stageEngineMode AT (0, 3).
    PRINT "Throttle: " + THROTTLE AT (0, 4).
    IF (timeStamp_terminalCountTMinus:SECONDS <= standard_scalar_SpoolTimeMargin + standard_scalar_merlin1DEngineSpoolTime AND standard_scalar_stage1AvailableThrust() = 0) {
        standard_void_setStage1EngineMode("1").
        SET standard_scalar_targetThrottle TO 0.01.
    }
    
    IF (TIME:SECONDS >= standard_timeStamp_terminalCount0Time:SECONDS) {
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION step_void_liftOff {
    PRINT "LIFT OFF" AT (0, 0).
    SET standard_scalar_targetThrottle TO 1.0.

    LOCAL scalar_vehicleWeight TO SHIP:MASS * standard_scalar_gAcceleration.
    PRINT "Vehicle weight: " + scalar_vehicleWeight AT (0, 1).
    LOCAL scalar_currentThrust TO standard_scalar_stage1CurrentThrust().
    PRINT "Current thrust: " + scalar_currentThrust AT (0, 2).
    LOCAL scalar_twr TO scalar_currentThrust / scalar_vehicleWeight.
    PRINT "TWR: " + scalar_twr AT (0, 3).
    IF (scalar_twr > 1.0) {
        PRINT "We have lift off!" AT (0, 4).
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION step_void_hop {
    PRINT "HOP" AT (0, 0).

    LOCAL scalar_targetAltitude TO 270.
    PRINT "Target altitude: " + scalar_targetAltitude AT (0, 1).
    LOCAL scalar_radarAltitude TO ALT:RADAR.
    PRINT "Radar altitude: " + scalar_radarAltitude AT (0, 2).

    SET standard_scalar_targetThrottle TO 1.0.

    IF (scalar_radarAltitude >= scalar_targetAltitude) {
        PRINT "Target altitude reached!" AT (0, 3).
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION step_void_coast {
    PRINT "COAST" AT (0, 0).

    SET standard_scalar_targetThrottle TO 0.01.
    PRINT "THROTLE: " + THROTTLE AT (0, 1).
    LOCAL scalar_verticalSpeed TO SHIP:VERTICALSPEED.
    PRINT "Vertical speed: " + scalar_verticalSpeed AT (0, 2).
    IF (scalar_verticalSpeed <= 0) {
        PRINT "Apogee reached, starting descent!" AT (0, 3).
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION step_void_landing {
    PRINT "LANDING" AT (0, 0).

    LOCAL scalar_verticalSpeed TO SHIP:VERTICALSPEED.
    PRINT "Vertical speed: " + scalar_verticalSpeed AT (0, 1).
    if (scalar_verticalSpeed < -2) {
        SET standard_scalar_targetThrottle TO 1.0.
    } ELSE {
        SET standard_scalar_targetThrottle TO 0.01.
    }
    PRINT "THROTTLE: " + THROTTLE AT (0, 2).
    LOCAL scalar_radarAltitude TO ALT:RADAR.
    PRINT "Radar altitude: " + scalar_radarAltitude AT (0, 3).
    IF (scalar_verticalSpeed >= 0) {
        PRINT "Landed!" AT (0, 4).
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION step_void_vehicleSafing {
    standard_void_setStage1EngineMode("OFF").
    SET standard_scalar_targetThrottle TO 0.0.
    SET standard_scalar_step TO FALSE.
}