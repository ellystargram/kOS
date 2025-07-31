GLOBAL string_landingLibraryVersion TO "1".

GLOBAL scalar_landingThrottle TO 0.
LOCK throttle TO scalar_landingThrottle.

// SET pidloop_hoverAltitude:setPoint
SET pidloop_hoverAltitude TO PIDLOOP(1, 0.01, 0.0, -50, 50).

//Controls vertical speed
SET pidloop_verticalSpeed TO PIDLOOP(0.1, 0.3, 0.005, 0, 1).

//Controls horizontal speed by tilting rocket
//Controls horizontal position by changing velPID setpoints
SET pidloop_eastVelocity TO PIDLOOP(3, 0.01, 0.0, -20, 20).
SET pidloop_northVelocity TO PIDLOOP(3, 0.01, 0.0, -20, 20).

SET pidloop_eastPosition TO PIDLOOP(ship:body:radius, 0, 100, -40,40).
SET pidloop_northPosition TO PIDLOOP(ship:body:radius, 0, 100, -40,40).

set scalar_shipPitch TO 0.
SET scalar_impactGeoErrorDistance TO 0.
SET scalar_steeringDirection TO 0.
SET scalar_targetDirection TO 0.
SET geo_landingTarget TO LATLNG(0, 0).
SET scalar_impactDistance TO 0.
SET scalar_g TO CONSTANT:G * BODY:MASS / BODY:RADIUS^2.
SET scalar_suicideBurnDistance TO 0.


FUNCTION scalar_scalarProjection {
	PARAMETER param_vector_vector1.
	PARAMETER param_vector_vector2.
	IF param_vector_vector2:MAG = 0 { PRINT "sProj: Divide by 0. Returning 1". RETURN 1. }
	RETURN VDOT(param_vector_vector1, param_vector_vector2) * (1/param_vector_vector2:MAG).
}

FUNCTION vector_divideVector {
	LOCAL vector_surfaceVector IS SHIP:VELOCITY:SURFACE.
	LOCAL vector_eastVector IS VCRS(UP:VECTOR, NORTH:VECTOR).
	LOCAL scalar_eastComp IS scalar_scalarProjection(vector_surfaceVector, vector_eastVector).
	LOCAL scalar_northComp IS scalar_scalarProjection(vector_surfaceVector, NORTH:VECTOR).
	LOCAL scalar_upComp IS scalar_scalarProjection(vector_surfaceVector, UP:VECTOR).
	RETURN V(scalar_eastComp, scalar_upComp, scalar_northComp).
}

FUNCTION scalar_velocityAngleToHorizontal {
    PARAMETER param_vector_divideVector.
    LOCAL vector_divideVectorHorizontal IS V(param_vector_divideVector:X, 0, param_vector_divideVector:Z).
	RETURN VANG(param_vector_divideVector, vector_divideVectorHorizontal).
}

FUNCTION vector_currentVectorByCompass {
	LOCAL vector_surfaceVentor IS SHIP:VELOCITY:SURFACE.
	LOCAL vector_eastVector IS VCRS(UP:VECTOR, NORTH:VECTOR).
	LOCAL scalar_eastComp IS scalar_scalarProjection(vector_surfaceVentor, vector_eastVector).
	LOCAL scalar_northComp IS scalar_scalarProjection(vector_surfaceVentor, NORTH:VECTOR).
	LOCAL scalar_upComp IS scalar_scalarProjection(vector_surfaceVentor, UP:VECTOR).
	RETURN V(scalar_eastComp, scalar_upComp, scalar_northComp).
}

FUNCTION void_updateLandingBurnSteering {
	PARAMETER param_boolean_reverse IS FALSE.
	PARAMETER param_scalar_minPitch IS 0.
	LOCAL vector_vectorCompassLast IS vector_currentVectorByCompass().
	SET pidloop_eastVelocity:SETPOINT TO pidloop_eastPosition:UPDATE(TIME:SECONDS, SHIP:GEOPOSITION:LNG).
	SET pidloop_northVelocity:SETPOINT TO pidloop_northPosition:UPDATE(TIME:SECONDS, SHIP:GEOPOSITION:LAT).
	LOCAL scalar_eastVelocity IS pidloop_eastVelocity:UPDATE(TIME:SECONDS, vector_vectorCompassLast:X).
	LOCAL scalar_northVelocity IS pidloop_northVelocity:UPDATE(TIME:SECONDS, vector_vectorCompassLast:Z).
	LOCAL scalar_eastNorthPitchMax IS MAX(ABS(scalar_eastVelocity), ABS(scalar_northVelocity)).

	LOCAL scalar_steeringDirectionNonNormalized IS ARCTAN2(pidloop_eastVelocity:OUTPUT, pidloop_northVelocity:OUTPUT).
	if scalar_steeringDirectionNonNormalized >= 0 {
		SET scalar_steeringDirection TO scalar_steeringDirectionNonNormalized.
	} else {
		SET scalar_steeringDirection TO 360 + scalar_steeringDirectionNonNormalized.
	}
	if(param_boolean_reverse) {
		SET scalar_steeringDirection TO scalar_steeringDirection - 180.
		if scalar_steeringDirection < 0 {
			SET scalar_steeringDirection TO 360 + scalar_steeringDirection.
		}
	}
	SET scalar_shipPitch TO 90 - scalar_eastNorthPitchMax.
	if(scalar_shipPitch < param_scalar_minPitch) {
		SET scalar_shipPitch TO param_scalar_minPitch.
	}
	LOCAL direction_thisHeading IS HEADING(scalar_steeringDirection, scalar_shipPitch).
	LOCK STEERING TO lookdirup(direction_thisHeading:vector, SHIP:facing:topvector).
}

FUNCTION void_setLandingTarget {
	// PARAMETER param_scalar_latitude.
	// PARAMETER param_scalar_longitude.
	// SET pidloop_eastPosition:SETPOINT TO param_scalar_longitude.
	// SET pidloop_northPosition:SETPOINT TO param_scalar_latitude.
	SET geo_landingTarget TO LATLNG(28.608389, -80.604333).
}

FUNCTION void_setLandingAltitude {
	PARAMETER param_scalar_altitude.
	SET pidloop_hoverAltitude:SETPOINT TO param_scalar_altitude.
}

FUNCTION void_setLandingBurnThrottle {
	PARAMETER param_scalar_altitude.
	PARAMETER param_scalar_minThrottle IS 0.01.
	SET pidloop_hoverAltitude:MAXOUTPUT TO param_scalar_altitude.
	SET pidloop_hoverAltitude:MINOUTPUT TO -param_scalar_altitude.
	SET pidloop_verticalSpeed:SETPOINT TO pidloop_hoverAltitude:UPDATE(TIME:SECONDS, SHIP:ALTITUDE).
	SET scalar_calculatedThrottle TO pidloop_verticalSpeed:UPDATE(TIME:SECONDS, SHIP:verticalspeed).
	IF (scalar_calculatedThrottle < param_scalar_minThrottle) { 
		SET scalar_calculatedThrottle TO param_scalar_minThrottle. 
	}
	IF (SHIP:VERTICALSPEED > -0.1) {
		SET scalar_calculatedThrottle TO 0.
	}
	SET scalar_landingThrottle TO scalar_calculatedThrottle.
}

FUNCTION void_setLandingBurnMaxSteerAngle{
	PARAMETER param_scalar_maxSteerAngle.
	SET pidloop_eastVelocity:MAXOUTPUT TO param_scalar_maxSteerAngle.
	SET pidloop_eastVelocity:MINOUTPUT TO -param_scalar_maxSteerAngle.
	SET pidloop_northVelocity:MAXOUTPUT TO param_scalar_maxSteerAngle.
	SET pidloop_northVelocity:MINOUTPUT TO -param_scalar_maxSteerAngle.
}

FUNCTION void_setLandingBurnMaxHorizontalSpeed{
	PARAMETER param_scalar_maxHorizontalSpeed.
	SET pidloop_eastPosition:MAXOUTPUT TO param_scalar_maxHorizontalSpeed.
	SET pidloop_eastPosition:MINOUTPUT TO -param_scalar_maxHorizontalSpeed.
	SET pidloop_northPosition:MAXOUTPUT TO param_scalar_maxHorizontalSpeed.
	SET pidloop_northPosition:MINOUTPUT TO -param_scalar_maxHorizontalSpeed.
}

FUNCTION void_setLandingBurnThrottleSensitivity{
	PARAMETER param_scalar_sensitivity.
	SET pidloop_verticalSpeed:KP TO param_scalar_sensitivity.
}

FUNCTION void_lockSteeringToStandardVector {
	PARAMETER param_vector_standardVector.
	LOCK STEERING TO lookdirup(param_vector_standardVector, SHIP:facing:topvector).
}

FUNCTION scalar_calculateDistance {
	PARAMETER param_geo_position1.
	PARAMETER param_geo_position2.
	RETURN (param_geo_position1:POSITION - param_geo_position2:POSITION):MAG.
}

FUNCTION scalar_calculateDirection {
	PARAMETER param_geo_position1.
	PARAMETER param_geo_position2.
	return ARCTAN2(param_geo_position1:LNG - param_geo_position2:LNG, param_geo_position1:LAT - param_geo_position2:LAT).
}

FUNCTION void_updateMaxAcceleration {
	SET scalar_gravityAcceleration TO CONSTANT:G * BODY:MASS / BODY:RADIUS^2.
	SET scalar_maxAcceleration TO (SHIP:AVAILABLETHRUST) / SHIP:MASS - scalar_gravityAcceleration. //max acceleration in up direction the engines can create
}

FUNCTION scalar_getPhaseAngleToTargetOld{
	PARAMETER param_geo_targetPosition.
	LOCAL vector_targetVector IS V(param_geo_targetPosition:LNG, 0, param_geo_targetPosition:LAT).
	LOCAL vector_shipVector IS SHIP:POSITION.
	RETURN VANG(vector_shipVector, vector_targetVector).
}

FUNCTION scalar_getPhaseAngleToTarget{
	PARAMETER param_body_targetBody.
	LOCAL vector_targetPosition IS (param_body_targetBody:orbit:position - SHIP:body:position):NORMALIZED.
	LOCAL vector_shipPosition IS (SHIP:POSITION - SHIP:BODY:POSITION):NORMALIZED.
	LOCAL scalar_phaseAngle IS ARCTAN2(vector_targetPosition:Z, vector_targetPosition:X) - ARCTAN2(vector_shipPosition:Z, vector_shipPosition:X).
	IF (scalar_phaseAngle < 0) {
		SET scalar_phaseAngle TO scalar_phaseAngle + 360.
	}
	RETURN scalar_phaseAngle.
}

FUNCTION scalar_getInterceptAngle{
	PARAMETER param_scalar_phaseAngle.
	SET scalar_interceptAngle TO param_scalar_phaseAngle - SHIP:ORBIT:PHASEANGLE.
	IF (scalar_interceptAngle < 0) {
		SET scalar_interceptAngle TO scalar_interceptAngle + 360.
	}
	RETURN scalar_interceptAngle.
}

// FUNCTION void_setLandingTarget {
// 	SET geo_landingTarget TO LATLNG(28.608389, -80.604333).
// }

FUNCTION void_steerToTarget{
	PARAMETER param_scalar_pitch.
	PARAMETER param_scalar_latitudeOffset.
	PARAMETER param_scalar_longitudeOffset.
	LOCAL geo_overshootLatLng IS LATLNG(geo_landingTarget:LAT + param_scalar_latitudeOffset, geo_landingTarget:LNG + param_scalar_longitudeOffset).
	SET scalar_targetDirection TO scalar_targetDirection(ADDONS:TR:IMPACTPOS, geo_overshootLatLng).
	SET scalar_impactDistance TO scalar_calculateDistance(geo_overshootLatLng, ADDONS:TR:IMPACTPOS).
	SET scalar_steeringDirection TO scalar_targetDirection - 180.

	LOCK STEERING TO HEADING(scalar_steeringDirection, param_scalar_pitch).
}

FUNCTION vector_surfaceRetrograde {
	return -1 * SHIP:VELOCITY:SURFACE.
}

FUNCTION void_throttleUp {
	PARAMETER param_scalar_deltaThrottle.
	PARAMETER param_scalar_maxThrottle IS 1.
	SET scalar_landingThrottle TO scalar_landingThrottle + param_scalar_deltaThrottle.
	if (scalar_landingThrottle > param_scalar_maxThrottle) {
		SET scalar_landingThrottle TO param_scalar_maxThrottle.
	}
}

FUNCTION void_throttleDown {
	PARAMETER param_scalar_deltaThrottle.
	PARAMETER param_scalar_minThrottle IS 0.01.
	SET scalar_landingThrottle TO scalar_landingThrottle - param_scalar_deltaThrottle.
	if (scalar_landingThrottle < param_scalar_minThrottle) {
		SET scalar_landingThrottle TO param_scalar_minThrottle.
	}
}

FUNCTION void_updateSuicideBurnDistance {
	SET scalar_impactGeoErrorDistance TO scalar_calculateDistance(geo_landingTarget, SHIP:GEOPOSITION).
	SET scalar_shipPitch TO 90 - vAng(SHIP:UP:VECTOR, SHIP:FACING:FOREVECTOR).
	LOCAL scalar_distanceMargin TO 500.
	LOCAL scalar_maxVerticalAcceleration TO (SHIP:AVAILABLETHRUST) / SHIP:MASS - scalar_g.
	LOCAL scalar_verticalAcceleration TO scalar_scalarProjection(SHIP:SENSORS:ACC, UP:VECTOR).
	LOCAL scalar_dragAcceleration TO scalar_g + scalar_verticalAcceleration.
	SET scalar_suicideBurnDistance TO (SHIP:VERTICALSPEED^2 / (2 * (scalar_maxVerticalAcceleration + scalar_dragAcceleration/2)))+scalar_distanceMargin.
}

//
// FUNCTIONS FOR MY VESSEL
//

FUNCTION void_setGridFinAuthority {
  PARAMETER param_scalar_limit.
  SET list_gridfins TO SHIP:PARTSTAGGED("gridfin").
  FOR part_fin IN list_gridfins {
    part_fin:getmodule("ModuleControlSurface"):setfield("authority limiter", param_scalar_limit).
  }
}

FUNCTION void_gridFinSteer {
	IF (scalar_impactGeoErrorDistance > 100) {
		void_setLandingBurnMaxSteerAngle(20).
	} ELSE {
		void_setLandingBurnMaxSteerAngle(15).
	}
	IF (scalar_impactGeoErrorDistance > 1000 or SHIP:GROUNDSPEED<100){
		SET scalar_minPitch TO 0.
	} ELSE {
		SET scalar_minPitch TO 90 - (scalar_impactGeoErrorDistance / 1000) * 90 + 5.
	}
	PRINT "Min pitch: " + scalar_minPitch.
	void_setLandingBurnMaxHorizontalSpeed(250).
	void_updateLandingBurnSteering(true, scalar_minPitch).
}

FUNCTION void_lockCurrentGravityAndWeight {
  LOCK scalar_currentBodyGravityAccelation TO SHIP:BODY:MU / ((SHIP:BODY:RADIUS + SHIP:ALTITUDE) ^ 2).
  LOCK scalar_currentRocketWeight TO SHIP:MASS * scalar_currentBodyGravityAccelation.
}
