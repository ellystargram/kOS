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

