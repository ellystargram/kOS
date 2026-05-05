RUNONCEPATH("0:/grasshopper/grasshopper_lib.ks").
RUNONCEPATH("0:/grasshopper/landing/landing_lib.ks").

FUNCTION landingStep_void_guideDescent {
    PRINT "GUIDE DESCENT" AT (0, 0).

    LOCAL scalar_verticalSpeed TO SHIP:VERTICALSPEED.
    PRINT "Vertical speed: " + scalar_verticalSpeed AT (0, 1).
    
    SET landing_pidloop_verticalSpeed:SETPOINT TO 35.
    LOCAL scalar_currentRadarAltitude TO ALT:RADAR.
    PRINT "Current radar altitude: " + scalar_currentRadarAltitude AT (0, 2).
    LOCAL scalar_targetVerticalSpeed TO landing_pidloop_verticalSpeed:UPDATE(TIME:SECONDS, scalar_currentRadarAltitude).
    PRINT "Target vertical speed: " + scalar_targetVerticalSpeed AT (0, 3).
    SET landing_pidloop_throttle:SETPOINT TO scalar_targetVerticalSpeed.
    LOCAL scalar_targetThrottle TO landing_pidloop_throttle:UPDATE(TIME:SECONDS, scalar_verticalSpeed).
    PRINT "Target throttle: " + scalar_targetThrottle AT (0, 4).
    SET standard_scalar_targetThrottle TO scalar_targetThrottle.

    LOCAL scalar_currentLatitude TO SHIP:LATITUDE.
    LOCAL scalar_currentLongitude TO SHIP:LONGITUDE.
    PRINT "Current latitude: " + scalar_currentLatitude AT (0, 5).
    PRINT "TARGET latitude: " + landing_scalar_LZ_R_Latitude AT (0, 6).
    PRINT "Current longitude: " + scalar_currentLongitude AT (0, 7).
    PRINT "TARGET longitude: " + landing_scalar_LZ_R_Longitude AT (0, 8).
    LOCAL scalar_xError TO landing_scalar_getDistanceByAngle(BODY, scalar_currentLongitude, landing_scalar_LZ_R_Longitude).
    LOCAL scalar_yError TO landing_scalar_getDistanceByAngle(BODY, scalar_currentLatitude, landing_scalar_LZ_R_Latitude).
    PRINT "Longitude error (m): " + scalar_xError AT (0, 9).
    PRINT "Latitude error (m): " + scalar_yError AT (0, 10).

    LOCAL vector_currentVelocity TO landing_vector_divideVector().

    SET landing_pidloop_xSpeed:SETPOINT TO 0.
    LOCAL scalar_targetXSpeed TO landing_pidloop_xSpeed:UPDATE(TIME:SECONDS, scalar_xError).
    PRINT "Target longitude speed: " + scalar_targetXSpeed AT (0, 11).
    SET landing_pidloop_xPitch:SETPOINT TO scalar_targetXSpeed.
    LOCAL scalar_currentXSpeed TO vector_currentVelocity:X.
    PRINT "Current longitude speed: " + scalar_currentXSpeed AT (0, 12).
    SET landing_pidloop_xPitch:SETPOINT TO scalar_targetXSpeed.
    LOCAL scalar_targetXPitch TO landing_pidloop_xPitch:UPDATE(TIME:SECONDS, scalar_currentXSpeed).
    PRINT "Target pitch for longitude correction: " + scalar_targetXPitch AT (0, 13).

    SET landing_pidloop_ySpeed:SETPOINT TO 0.
    LOCAL scalar_targetYSpeed TO landing_pidloop_ySpeed:UPDATE(TIME:SECONDS, scalar_yError).
    PRINT "Target latitude speed: " + scalar_targetYSpeed AT (0, 14).
    SET landing_pidloop_yPitch:SETPOINT TO scalar_targetYSpeed.
    LOCAL scalar_currentYSpeed TO vector_currentVelocity:Y.
    PRINT "Current latitude speed: " + scalar_currentYSpeed AT (0, 15).
    SET landing_pidloop_yPitch:SETPOINT TO scalar_targetYSpeed.
    LOCAL scalar_targetYPitch TO landing_pidloop_yPitch:UPDATE(TIME:SECONDS, scalar_currentYSpeed).
    PRINT "Target pitch for latitude correction: " + scalar_targetYPitch AT (0, 16).

    LOCAL scalar_totalTargetPitch TO ARCCOS(COS(scalar_targetXPitch) * COS(scalar_targetYPitch)).
    PRINT "Total target pitch: " + scalar_totalTargetPitch AT (0, 17).
    LOCAL scalar_totalTargetHeading TO ARCTAN2(SIN(scalar_targetXPitch), SIN(scalar_targetYPitch)).
    PRINT "Total target heading: " + scalar_totalTargetHeading AT (0, 18).
    LOCAL direction_targetDirection TO HEADING(scalar_totalTargetHeading, 90 - scalar_totalTargetPitch).
    SET standard_direction_targetDirection TO direction_targetDirection.

    LOCAL scalar_engineResponse TO standard_scalar_stage1CurrentThrust.
    LOG TIME:SECONDS + ", " + scalar_verticalSpeed + ", " + scalar_currentRadarAltitude + ", " + scalar_targetVerticalSpeed + ", " + scalar_targetThrottle + ", " + scalar_engineResponse + ", " + scalar_currentLatitude + ", " + scalar_currentLongitude + ", " + scalar_xError + ", " + scalar_yError + ", " + scalar_targetXSpeed + ", " + scalar_currentXSpeed + ", " + scalar_targetXPitch + ", " + scalar_targetYSpeed + ", " + scalar_currentYSpeed + ", " + scalar_targetYPitch + ", " + scalar_totalTargetPitch + ", " + scalar_totalTargetHeading TO "0:/grasshopper/landing/landing_log.csv".

    IF (scalar_verticalSpeed >= -1 AND scalar_currentRadarAltitude <= 36) {
        PRINT "Final approach" AT (0, 19).
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION landingStep_void_touchDown {
    PRINT "TOUCHDOWN" AT (0, 0).

    SET standard_direction_targetDirection TO UP.
    SET landing_pidloop_verticalSpeed:SETPOINT TO 26.
    LOCAL scalar_currentRadarAltitude TO ALT:RADAR.
    PRINT "Current radar altitude: " + scalar_currentRadarAltitude AT (0, 1).
    LOCAL scalar_targetVerticalSpeed TO -1.
    PRINT "Target vertical speed: " + scalar_targetVerticalSpeed AT (0, 2).
    LOCAL scalar_currentVerticalSpeed TO SHIP:VERTICALSPEED.
    PRINT "Current vertical speed: " + scalar_currentVerticalSpeed AT (0, 3).
    SET landing_pidloop_throttle:SETPOINT TO scalar_targetVerticalSpeed.
    LOCAL scalar_targetThrottle TO landing_pidloop_throttle:UPDATE(TIME:SECONDS, scalar_currentVerticalSpeed).
    PRINT "Target throttle: " + scalar_targetThrottle AT (0, 4).
    SET standard_scalar_targetThrottle TO scalar_targetThrottle.

    IF (scalar_currentVerticalSpeed >= 0) {
        PRINT "Landed!" AT (0, 5).
        SET standard_scalar_step TO FALSE.
    }
}