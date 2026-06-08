RUNONCEPATH("0:/falcon1/std_lib.ks").

GLOBAL gui_gui_mainWindow TO GUI(500).

GLOBAL gui_label_title TO gui_gui_mainWindow:ADDLABEL("Falcon 1 Flight Software v0.1").
SET gui_label_title:STYLE:ALIGN TO "CENTER".
SET gui_label_title:STYLE:HSTRETCH TO TRUE.

// MISSION STATUS PANEL
GLOBAL gui_box_missionStatusPanel TO gui_gui_mainWindow:ADDVBOX().
GLOBAL gui_label_terminalCount TO gui_box_missionStatusPanel:ADDLABEL("T" + standard_timestamp_terminalCountDown:SECONDS + "s").
GLOBAL gui_label_stepInfo TO gui_box_missionStatusPanel:ADDLABEL("Step: " + standard_scalar_step).

// LD go/no go poll panel
GLOBAL gui_box_pollingPanel TO gui_gui_mainWindow:ADDVBOX().
GLOBAL gui_label_pollingTopic TO gui_box_pollingPanel:ADDLABEL("Polling topic: ").
GLOBAL gui_progress_pollingCountDown TO gui_box_pollingPanel:ADDLABEL("Poll end IN: ").
GLOBAL gui_box_pollingButtonPanel TO gui_box_pollingPanel:ADDHBOX().
GLOBAL gui_button_launchDirectorGoButton TO gui_box_pollingButtonPanel:ADDBUTTON("Launch Director Go").
GLOBAL gui_button_launchDirectorNoGoButton TO gui_box_pollingButtonPanel:ADDBUTTON("Launch Director No Go").

SET gui_button_launchDirectorGoButton:ONCLICK TO {
    SET standard_boolean_isPolling TO FALSE.
    SET standard_boolean_lastPollingResult TO TRUE.
    SET standard_string_lastPollingTopic TO standard_string_pollingTopic.
}.
SET gui_button_launchDirectorNoGoButton:ONCLICK TO {
    SET standard_boolean_isPolling TO FALSE.
    SET standard_boolean_lastPollingResult TO FALSE.
    SET standard_string_lastPollingTopic TO standard_string_pollingTopic.
}.

FUNCTION gui_void_updateContent {
    //MISSION STATUS PANEL
    SET gui_label_terminalCount:TEXT TO "T" + standard_timestamp_terminalCountDown:SECONDS + "s".
    SET gui_label_stepInfo:TEXT TO "Step: " + standard_scalar_step.

    //LD GO/NO GO POLL PANEL.
    IF (standard_boolean_isPolling = TRUE) {
        SET gui_label_pollingTopic:TEXT TO "Polling topic: " + standard_string_pollingTopic.
        SET gui_progress_pollingCountDown:TEXT TO "Poll end IN: " + (standard_timestamp_pollingEndTerminalCount - standard_timestamp_terminalCountDown):SECONDS + "s".
    }
}

gui_gui_mainWindow:SHOW().