#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of task selection combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params [["_idc", -1], "_selectionPath"];
private ["_display", "_ctrl", "_locations", "_mrkr"];
if (DAKKA_debug) then { diag_log format ["DAKKA: TaskSelectionCombo_selChanged _selectionPath:%1", _selectionPath] };

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idc;

// Destroy cameras when closing menu
if (DAKKA_debug) then { diag_log format ["DAKKA: TaskSelectionCombo_selChanged - Terminating preview camera..."] };
call DAKKA_fnc_cameraPreviewTerminate;
waitUntil {DAKKA_cameraPreviewTerminateDone};
call DAKKA_fnc_previewGroupDelete;
// Delete location markers and things
_ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
_ctrl lbSetCurSel -1;
DAKKA_locationPreview = [];
[true] call DAKKA_fnc_compositionRemove;
waitUntil {DAKKA_compositionsRemoved};
call DAKKA_fnc_deleteTaskMarkers;
call DAKKA_fnc_deleteCompositionMarkers; 

// Update task var
DAKKA_Task = (_this select 1) + 1;

call DAKKA_fnc_displayTaskInfo;
[IDC_COMBO_FACTIONS_PLAYER, true] call DAKKA_fnc_updateFactionCombo;
[IDC_COMBO_FACTIONS_ENEMY, false] call DAKKA_fnc_updateFactionCombo;


// Load task settings
call DAKKA_fnc_settingsLoad;

// Save selected task
["Selected Task"] call DAKKA_fnc_globalSettingsSave;

true