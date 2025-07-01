GLOBAL string_landingLibraryVersion TO "1".

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

LOCK scalar_currentBodyGravityAccelation TO SHIP:BODY:MU / ((SHIP:BODY:RADIUS + SHIP:ALTITUDE) ^ 2).
LOCK scalar_currentRocketWeight TO SHIP:MASS * scalar_currentBodyGravityAccelation.

