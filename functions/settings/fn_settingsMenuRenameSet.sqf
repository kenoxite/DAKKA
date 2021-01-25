#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:


  Parameter (s):
 

  Returns:


  Examples:

*/

disableSerialization;
private _display = findDisplay IDC_MENU_MISSION_EDIT;

private _currentName = DMORBAT_saveSlotName;
_ctrl = (_display displayCtrl IDC_TXT_DATARENAME);
private _newName = ctrlText _ctrl;

if (count _newName == 0 || _newName == " ") exitWith {
    ["ERROR: Profile name can't be empty!"] spawn DMORBAT_fnc_displayMessage;
    false
};


private _savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);
private _slotIndex = (DMORBAT_saveSlots select (DMORBAT_Task - 1));
private _currentSlot = _savedData select _slotIndex;

_currentSlot set [0, _newName];
DMORBAT_saveSlotName = _newName;

// Close popup
_ctrl = (_display displayCtrl IDC_GRP_DATARENAME);
_ctrl ctrlShow false;

// Update profiles combo
_ctrl = (_display displayCtrl IDC_COMBO_SAVEDDATAPROFILES);
[IDC_COMBO_SAVEDDATAPROFILES] call DMORBAT_fnc_updateSavedDataCombo;
_ctrl lbSetCurSel _slotIndex;

// Update profile display
_ctrl = (_display displayCtrl IDC_TXT_CURRENTSAVEDDATA);
_ctrl ctrlSetText format ["Profile: %1", DMORBAT_saveSlotName];

true