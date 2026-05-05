RUNONCEPATH("0:/grasshopper/grasshopper_lib.ks").
RUNONCEPATH("0:/grasshopper/landing/landing_lib.ks").
RUNONCEPATH("0:/grasshopper/landing/landing_steps.ks").

DELETEPATH("0:/grasshopper/landing/landing_log.csv").
LOG "TIME, VerticalSpeed, RadarAltitude, TargetVerticalSpeed, TargetThrottle, EngineResponse(kn), Latitude, Longitude, XError, YError, TargetXSpeed, CurrentXSpeed, TargetXPitch, TargetYSpeed, CurrentYSpeed, TargetYPitch, TotalTargetPitch, TotalTargetHeading" TO "0:/grasshopper/landing/landing_log.csv". 
standard_void_runStep("Descent", landingStep_void_guideDescent@).
standard_void_runStep("TouchDown", landingStep_void_touchDown@).
