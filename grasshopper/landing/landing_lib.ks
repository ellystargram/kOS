RUNONCEPATH("0:/grasshopper/grasshopper_lib.ks").

GLOBAL landing_pidloop_verticalSpeed TO PIDLOOP(1.5, 0.5, 0.1, -15, 0).
GLOBAL landing_pidloop_throttle TO PIDLOOP(0.4, 0.05, 0.05, 0.01, 1).

GLOBAL landing_pidloop_xSpeed TO PIDLOOP(0.08, 0.0, 0.06, -15, 15). //longitude
GLOBAL landing_pidloop_xPitch TO PIDLOOP(1.2, 0.01, 0.6, -15, 15).
GLOBAL landing_pidloop_ySpeed TO PIDLOOP(0.08, 0.0, 0.06, -15, 15). //latitude
GLOBAL landing_pidloop_yPitch TO PIDLOOP(1.2, 0.01, 0.6, -15, 15).

GLOBAL landing_scalar_LZ_R_Latitude TO 28.6092681884766. // degrees
GLOBAL landing_scalar_LZ_R_Longitude TO 279.40287018. // degrees 

//GLOBAL landing_scalar_LZ_L_Latitude TO 28.3922. // degrees
GLOBAL landing_scalar_LZ_L_Longitude TO 279.40287018. // degrees

FUNCTION landing_scalar_getDistanceByAngle {
    PARAMETER param_body_body.
    PARAMETER param_scalar_currentAngleDegrees.
    PARAMETER param_scalar_targetAngleDegrees.

    IF (param_scalar_currentAngleDegrees < 0) {
        SET param_scalar_currentAngleDegrees TO param_scalar_currentAngleDegrees + 360.
    }
    IF (param_scalar_targetAngleDegrees < 0) {
        SET param_scalar_targetAngleDegrees TO param_scalar_targetAngleDegrees + 360.
    }
    LOCAL scalar_angleDegrees TO param_scalar_currentAngleDegrees - param_scalar_targetAngleDegrees.
    
    LOCAL scalar_angleRadians TO scalar_angleDegrees * CONSTANT:PI / 180.
    RETURN param_body_body:RADIUS * scalar_angleRadians.
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
	RETURN V(scalar_eastComp, scalar_northComp, scalar_upComp).
}

