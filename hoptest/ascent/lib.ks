GLOBAL ascent_scalar_towerHeight TO 100.
GLOBAL ascent_scalar_liftOffStartAltitude TO SHIP:ALTITUDE.
GLOBAL ascent_scalar_targetAltitude TO 250.
GLOBAL ascent_scalar_maxAscentSpeed TO 0.
GLOBAL ascent_pidloop_ascentSpeedControl TO PIDLOOP(0.2, 0.05, 1, 0.01, 1).

//
// initialization
//