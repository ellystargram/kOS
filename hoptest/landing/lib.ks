GLOBAL landing_scalar_landingTarget TO "LZ1".

GLOBAL landing_scalar_landingZone1Latitude TO 28.608.
GLOBAL landing_scalar_landingZone1Longitude TO 279.403.

GLOBAL landing_scalar_landingTargetLatitude TO 0.
GLOBAL landing_scalar_landingTargetLongitude TO 0.

GLOBAL landing_scalar_impactLocationEastError TO 0.
GLOBAL landing_scalar_impactLocationNorthError TO 0.

GLOBAL landing_scalar_maxHorizontalSpeed TO 20.
GLOBAL landing_pidloop_eastErrorControl TO PIDLOOP(0.2, 0.2, 0.2, -landing_scalar_maxHorizontalSpeed, landing_scalar_maxHorizontalSpeed).
GLOBAL landing_pidloop_northErrorControl TO PIDLOOP(0.2, 0.2, 0.2, -landing_scalar_maxHorizontalSpeed, landing_scalar_maxHorizontalSpeed).
GLOBAL landing_scalar_errorMargin TO 10.

GLOBAL landing_scalar_maxHorizontalAngleDeg TO 25.
GLOBAL landing_pidloop_eastAngleControl TO PIDLOOP(0.5, 0.05, 0.2, -landing_scalar_maxHorizontalAngleDeg, landing_scalar_maxHorizontalAngleDeg).
GLOBAL landing_pidloop_northAngleControl TO PIDLOOP(0.5, 0.05, 0.2, -landing_scalar_maxHorizontalAngleDeg, landing_scalar_maxHorizontalAngleDeg).

GLOBAL landing_scalar_maxVerticalSpeed TO -5.
GLOBAL landing_pidloop_verticalSpeedControl TO PIDLOOP(0.2, 0.05, 1, landing_scalar_maxVerticalSpeed, 0).
GLOBAL landing_pidloop_throttleControl TO PIDLOOP(0.2, 0.05, 1, 0.01, 1).



FUNCTION landing_scalar_getDistanceFromLatitudeAndLongitudeDifference {
    PARAMETER param_geo_geo1.
    PARAMETER param_geo_geo2.
    RETURN (param_geo_geo1:POSITION - param_geo_geo2:POSITION):MAG.
}

FUNCTION landing_scalar_getAngleFromLatitudeAndLongitudeDifference {
    PARAMETER param_geo_geo1.
    PARAMETER param_geo_geo2.

    RETURN ARCTAN2(param_geo_geo1:LNG - param_geo_geo2:LNG, param_geo_geo1:LAT - param_geo_geo2:LAT).
}

FUNCTION landing_scalar_scalarProjection {
	PARAMETER param_vector_vector1.
	PARAMETER param_vector_vector2.
	IF (param_vector_vector2:MAG = 0) { PRINT "sProj: Divide by 0. Returning 1". RETURN 1. }
	RETURN VDOT(param_vector_vector1, param_vector_vector2) * (1/param_vector_vector2:MAG).
}

FUNCTION landing_vector_divideVector {
	LOCAL vector_surfaceVector IS SHIP:VELOCITY:SURFACE.
	LOCAL vector_eastVector IS VCRS(UP:VECTOR, NORTH:VECTOR).
	LOCAL scalar_eastComp IS landing_scalar_scalarProjection(vector_surfaceVector, vector_eastVector).
	LOCAL scalar_northComp IS landing_scalar_scalarProjection(vector_surfaceVector, NORTH:VECTOR).
	LOCAL scalar_upComp IS landing_scalar_scalarProjection(vector_surfaceVector, UP:VECTOR).
	RETURN V(scalar_eastComp, scalar_upComp, scalar_northComp).
}



FUNCTION landing_void_setTarget {
    IF (landing_scalar_landingTarget = "LZ1") {
        SET landing_scalar_landingTargetLatitude TO landing_scalar_landingZone1Latitude.
        SET landing_scalar_landingTargetLongitude TO landing_scalar_landingZone1Longitude.
    }
}

FUNCTION landing_void_tickLandingPIDLoops {
    landing_void_setTarget().

    SET landing_pidloop_eastErrorControl:SETPOINT TO 0.
    SET landing_pidloop_northErrorControl:SETPOINT TO 0.

    SET landing_pidloop_eastAngleControl:SETPOINT TO -landing_pidloop_eastErrorControl:UPDATE(TIME:SECONDS, landing_scalar_impactLocationEastError).
    SET landing_pidloop_northAngleControl:SETPOINT TO -landing_pidloop_northErrorControl:UPDATE(TIME:SECONDS, landing_scalar_impactLocationNorthError).
    
    LOCAL vector_surfaceVelocity IS landing_vector_divideVector().
    landing_pidloop_eastAngleControl:UPDATE(TIME:SECONDS, vector_surfaceVelocity:X).
    landing_pidloop_northAngleControl:UPDATE(TIME:SECONDS, vector_surfaceVelocity:Z).

    SET landing_pidloop_verticalSpeedControl:SETPOINT TO 0.
    SET landing_pidloop_throttleControl:SETPOINT TO landing_pidloop_verticalSpeedControl:UPDATE(TIME:SECONDS, ALT:RADAR-50).
    landing_pidloop_throttleControl:UPDATE(TIME:SECONDS, SHIP:VERTICALSPEED).
}
