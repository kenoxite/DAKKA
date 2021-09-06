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
if (DMORBAT_debug) then { diag_log format ["DMORBAT: TaskSelectionCombo_selChanged _selectionPath:%1", _selectionPath] };

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idc;

// Destroy cameras when closing menu
call DMORBAT_fnc_cameraPreviewTerminate;
call DMORBAT_fnc_previewGroupDelete;
// Delete location markers and things
_ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
_ctrl lbSetCurSel -1;
DMORBAT_locationPreview = [];
[true] call DMORBAT_fnc_compositionRemove;
call DMORBAT_fnc_deleteTaskMarkers;
call DMORBAT_fnc_deleteCompositionMarkers;
// Delete wheelchocks
{
  deleteVehicle _x;
} forEach DMORBAT_wheelChock;
DMORBAT_wheelChock = []; 

// Update task var
DMORBAT_Task = (_this select 1) + 1;

call DMORBAT_fnc_displayTaskInfo;
[IDC_COMBO_FACTIONS_PLAYER, true] call DMORBAT_fnc_updateFactionCombo;
[IDC_COMBO_FACTIONS_ENEMY, false] call DMORBAT_fnc_updateFactionCombo;


// Load task settings
call DMORBAT_fnc_settingsLoad;

// Save selected task
["Selected Task"] call DMORBAT_fnc_globalSettingsSave;

true