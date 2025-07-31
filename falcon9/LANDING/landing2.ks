RUNPATH ("0:/falcon9/landing/landing_lib.ks").
RUNPATH("0:/falcon9/std_lib.ks").

PRINT "LANDING PROFILE v2 loaded.".
PRINT "LANDING LIBRARY v" + string_landingLibraryVersion + " loaded.".


FUNCTION void_step_aeroGuide {
    void_setLandingTarget().
    void_updateSuicideBurnDistance().
    IF (SHIP:ALTITUDE > 10000) {
        RCS ON.
    } ELSE {
        RCS OFF.
    }

    SET scalar_landingBurnStartAltitude TO 3500.
    SET scalar_landingThrottle TO 0.

    void_gridFinSteer().

    IF (SHIP:ALTITUDE < scalar_landingBurnStartAltitude) {
        SET scalar_step TO false.
    }
}

FUNCTION void_step_suicideBurn {
    LOCK STEERING TO vector_surfaceRetrograde().
    IF (scalar_suicideBurnDistance > SHIP:ALTITUDE OR SHIP:ALTITUDE < 300) {
        void_throttleUp(0.05).
    } ELSE {
        void_throttleDown(0.05).
    }

    IF (SHIP:VERTICALSPEED< -65) {
        SET scalar_step TO false.
    }
}

FUNCTION void_step_touchDown {
    GEAR ON.
    void_setLandingBurnMaxSteerAngle(5).
    void_setLandingBurnMaxHorizontalSpeed(10).

    void_setLandingAltitude(debug_landingAlt-5).

    if(SHIP:ALTITUDE<500){
		void_setLandingBurnThrottle(20,0.1).
	}else if(SHIP:ALTITUDE<debug_landingAlt+20){
		void_setLandingBurnThrottle(2,0.1).
	}else{
		void_setLandingBurnThrottle(45,0.1).
	}

    void_updateLandingBurnSteering().

    IF (SHIP:VERTICALSPEED >= 0) {
        SET scalar_step TO false.
    }
}

BRAKES ON.

void_runStep("aeroGuide", void_step_aeroGuide@).
void_runStep("suicideBurn", void_step_suicideBurn@).
void_runStep("touchDown", void_step_touchDown@).