FUNCTION landing_step_landingGuide {
    LOCAL geo_currentLocation TO SHIP:GEOPOSITION.
    LOCAL geo_landingTargetLocation TO LATLNG(landing_scalar_landingTargetLatitude, landing_scalar_landingTargetLongitude).
    PRINT "Current Location: " + geo_currentLocation AT (0, 0).
    PRINT "Landing Target Location: " + geo_landingTargetLocation AT (0, 1).
    LOCAL scalar_distanceToTarget TO landing_scalar_getDistanceFromLatitudeAndLongitudeDifference(geo_currentLocation, geo_landingTargetLocation).
    LOCAL scalar_headingToTarget TO landing_scalar_getAngleFromLatitudeAndLongitudeDifference(geo_currentLocation, geo_landingTargetLocation).
    LOCAL scalar_eastErrorMeter TO SIN(scalar_headingToTarget) * scalar_distanceToTarget. //if ROCKET is in WEST to PAD IS NEGATIVE, ROCKET is in EAST TO PAD IS POSITIVE
    LOCAL scalar_northErrorMeter TO COS(scalar_headingToTarget) * scalar_distanceToTarget.
    PRINT "EAST Error: " + scalar_eastErrorMeter + " m" AT (0, 2).
    PRINT "NORTH Error: " + scalar_northErrorMeter + " m" AT (0, 3).

    SET landing_scalar_impactLocationEastError TO scalar_eastErrorMeter.
    SET landing_scalar_impactLocationNorthError TO scalar_northErrorMeter.

    landing_void_tickLandingPIDLoops().

    LOCAL vector_surfaceVector TO landing_vector_divideVector().
    PRINT "Current EAST VEL: " + vector_surfaceVector:X AT (0, 4).
    PRINT "Current NORTH VEL: " + vector_surfaceVector:Z AT (0, 5).
    PRINT "WANT EAST VEL: " + landing_pidloop_eastErrorControl:OUTPUT AT (0, 6).
    PRINT "WANT NORTH VEL: " + landing_pidloop_northErrorControl:OUTPUT AT (0, 7).

    LOCAL scalar_eastAngle TO -landing_pidloop_eastAngleControl:OUTPUT. //NEGATIVE to LOOK WEST, POSITIVE to LOOK EAST
    LOCAL scalar_northAngle TO -landing_pidloop_northAngleControl:OUTPUT. //NEGATIVE to LOOK SOUTH, POSITIVE to LOOK NORTH
    LOCAL scalar_angle TO MAX(ABS(scalar_eastAngle), ABS(scalar_northAngle)).

    PRINT "EAST ANGLE: " + scalar_eastAngle + " deg" AT (0, 8).
    PRINT "NORTH ANGLE: " + scalar_northAngle + " deg" AT (0, 9).

    LOCAL scalar_angleHeading TO ARCTAN2(scalar_eastAngle, scalar_northAngle). //deg

    LOCAL direction_direction TO HEADING(scalar_angleHeading, 90 - scalar_angle).

    SET standard_scalar_steering TO direction_direction.
    PRINT "Heading to target: " + scalar_angleHeading AT (0, 10).
    PRINT "Angle to target: " + scalar_angle + " deg" AT (0, 11).

    SET standard_scalar_throttle TO landing_pidloop_throttleControl:OUTPUT.

    LOCAL scalar_touchDownLeftTime TO (ALT:RADAR-50) / -SHIP:VERTICALSPEED.
    IF (SHIP:VERTICALSPEED >= 0) {
        SET scalar_touchDownLeftTime TO 1000000. // If the ship is going up, we assume it will never touch down.
    }
    PRINT "RADAR RAW Altitude: " + (ALT:RADAR) + " m" AT (0, 12).
    PRINT "TARGET ERROR: " + scalar_distanceToTarget + " m" AT (0, 13).
    PRINT "Touch Down Left Time: " + scalar_touchDownLeftTime + " s" AT (0, 14).

    IF ((ABS(scalar_distanceToTarget) <= landing_scalar_errorMargin) AND (scalar_touchDownLeftTime <= 5)) {
        PRINT "Landing Guide: Target reached. Preparing to touch down.".
        SET standard_scalar_step TO FALSE.
    }
    IF (scalar_touchDownLeftTime <= 5) {
        PRINT "Landing Guide: Touch down imminent.".
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION landing_step_touchDown {
    GEAR ON.

    // 2as = (v^2 - u^2)
    // u = ship:verticalspeed
    // v = -1
    // s = alt:radar
    // a = (v^2 - u^2) / (2 * s)
    LOCAL scalar_touchDownAcceleration TO ABS((4 - SHIP:VERTICALSPEED * SHIP:VERTICALSPEED) / (2 * (ALT:RADAR-50))).
    // f = ma
    LOCAL scalar_touchDownThrust TO scalar_touchDownAcceleration * SHIP:MASS.
    LOCAL scalar_touchDownThrottle TO scalar_touchDownThrust / SHIP:AVAILABLETHRUST.

    SET standard_scalar_throttle TO scalar_touchDownThrottle.

    IF (SHIP:VERTICALSPEED >= 0) {
        SET standard_scalar_step TO FALSE.
        PRINT "Touch down complete.".
    }
}