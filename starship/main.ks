RUNONCEPATH("0:/starship/starship_lib.ks").
RUNONCEPATH("0:/starship/starship_steps.ks").

CLEARSCREEN.
standard_void_runStep("SetT0", step_void_setT0@).
standard_void_runStep("CountDown", step_void_countDown@).
standard_void_runStep("LiftOff", step_void_liftOff@).
standard_void_runStep("Hop", step_void_hop@).
standard_void_runStep("Coast", step_void_coast@).

RUNPATH("0:/starship/landing/landing_main.ks").

standard_void_runStep("VehicleSafing", step_void_vehicleSafing@).
