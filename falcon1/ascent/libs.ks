RUNONCEPATH("0:/falcon1/std_lib.ks").

GLOBAL ascentLibs_scalar_targetAP TO 2000000.0. //m
GLOBAL ascentLibs_scalar_targetPE TO 2000000.0. //m
GLOBAL ascentLibs_scalar_targetInclination TO 45.0. //degrees

GLOBAL ascentLibs_scalar_towerClearTargetAltitude TO 150. //m
GLOBAL ascentLibs_scalar_towerClearTargetVerticalSpeed TO 50. //m/s
GLOBAL ascentLibs_scalar_pitchKickDegreePerSecond TO 0.5.
GLOBAL ascentLibs_scalar_pitchKickTargetmAXAngle TO 40.0.
SET ascentLibs_timestamp_pitchKickStartTime TO standard_timestamp_terminalCountDown.
GLOBAL ascentLibs_scalar_pitchKickEndAtmosphericKPA TO 1.0. //kPa

FUNCTION ascent_scalar_getLaunchHeading {
    LOCAL scalar_headingCOSInertial TO COS(ascentLibs_scalar_targetInclination) / COS(SHIP:LATITUDE).
    LOCAL scalar_headingCOS TO MAX(-1, MIN(1, scalar_headingCOSInertial)).
    LOCAL scalar_heading TO ARCCOS(scalar_headingCOS).
    IF (ascentLibs_scalar_targetInclination > 180) {
        SET scalar_heading TO 360-scalar_heading.
    }

    LOCAL scalar_apWithBodyRadius TO ascentLibs_scalar_targetAP + BODY:RADIUS.
    LOCAL scalar_peWithBodyRadius TO ascentLibs_scalar_targetPE + BODY:RADIUS.
    LOCAL scalar_semiMajorAxis TO (scalar_apWithBodyRadius + scalar_peWithBodyRadius) / 2.
    LOCAL scalar_targetOrbitalVelocityAtPE TO SQRT(BODY:MU * (2 / scalar_peWithBodyRadius - 1 / scalar_semiMajorAxis)).

    LOCAL scalar_targetOrbitalVelocityEast TO scalar_targetOrbitalVelocityAtPE * SIN(scalar_heading).
    LOCAL scalar_targetOrbitalVelocityNorth TO scalar_targetOrbitalVelocityAtPE * COS(scalar_heading).
    LOCAL vector_dividedCurrentOrbitalVelocity TO standard_vector_divideVector(VELOCITY:ORBIT).
    LOCAL scalar_currentOrbitalVelocityEast TO vector_dividedCurrentOrbitalVelocity:X.
    LOCAL scalar_currentOrbitalVelocityNorth TO vector_dividedCurrentOrbitalVelocity:Y.
    LOCAL scalar_deltaVelocityEast TO scalar_targetOrbitalVelocityEast - scalar_currentOrbitalVelocityEast.
    LOCAL scalar_deltaVelocityNorth TO scalar_targetOrbitalVelocityNorth - scalar_currentOrbitalVelocityNorth.

    RETURN ARCTAN2(scalar_deltaVelocityEast, scalar_deltaVelocityNorth).
}