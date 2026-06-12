RUNONCEPATH("0:/falcon1/std_lib.ks").
RUNONCEPATH("0:/falcon1/ascent/libs.ks").

FUNCTION ascent_step_towerClear {
    SET standard_scalar_targetThrottle TO 1.0.
    IF ((standard_scalar_vehicleRadarAltitude > ascentLibs_scalar_towerClearTargetAltitude) AND (SHIP:VERTICALSPEED > ascentLibs_scalar_towerClearTargetVerticalSpeed)) {
        SET ascentLibs_timestamp_pitchKickStartTime TO standard_timestamp_terminalCountDown.
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION ascent_step_pitchKick {
    IF (BODY:ATM:ALTITUDEPRESSURE(ALTITUDE) * CONSTANT:ATMTOKPA < ascentLibs_scalar_pitchKickEndAtmosphericKPA) {
        SET standard_scalar_step TO FALSE.
    } 
    LOCAL scalar_timeSincePitchKickStart TO (standard_timestamp_terminalCountDown - ascentLibs_timestamp_pitchKickStartTime):SECONDS.
    LOCAL scalar_targetPitch TO MIN(scalar_timeSincePitchKickStart * ascentLibs_scalar_pitchKickDegreePerSecond, ascentLibs_scalar_pitchKickTargetmAXAngle).

    SET standard_direction_targetDirection TO HEADING(ascent_scalar_getLaunchHeading(), 90 - scalar_targetPitch, 0).
}

FUNCTION ascent_step_closeLoop {
    LOCAL vector_relativeLocation TO SHIP:POSITION - BODY:POSITION.
    LOCAL vector_orbitalVelocity TO VELOCITY:ORBIT.

    LOCAL scalar_currentVerticalSpeed TO VDOT(vector_orbitalVelocity, vector_orbitalVelocity:NORMALIZED).
    LOCAL scalar_currentAltitude TO vector_relativeLocation:MAG - BODY:RADIUS.
    LOCAL scalar_currentHorizontalSpeed TO SQRT(vector_orbitalVelocity:SQRMAGNITUDE - scalar_currentVerticalSpeed^2).

    LOCAL scalar_apWithBodyRadius TO ascentLibs_scalar_targetAP + BODY:RADIUS.
    LOCAL scalar_peWithBodyRadius TO ascentLibs_scalar_targetPE + BODY:RADIUS.
    LOCAL scalar_semiMajorAxis TO (scalar_apWithBodyRadius + scalar_peWithBodyRadius) / 2.
    LOCAL scalar_targetOrbitalVelocityAtPE TO SQRT(BODY:MU * (2 / scalar_peWithBodyRadius - 1 / scalar_semiMajorAxis)).

    LOCAL scalar_deltaHorizontalSpeed TO scalar_targetOrbitalVelocityAtPE - scalar_currentHorizontalSpeed.

    
}