RUNONCEPATH("0:/falcon1/std_lib.ks").
RUNONCEPATH("0:/falcon1/ascent/steps.ks").

standard_void_runStep("TOWER CLEAR", ascent_step_towerClear@).
standard_void_runStep("PITCH KICK", ascent_step_pitchKick@).
standard_void_runStep("CLOSE LOOP", ascent_step_closeLoop@).