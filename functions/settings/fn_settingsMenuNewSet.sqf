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

_ctrl = (_display displayCtrl IDC_TXT_DATARENAME);
private _newName = ctrlText _ctrl;

if (count _newName == 0 || _newName == " ") exitWith {
    [format ["ERROR: Profile name can't be empty!"]] spawn DMORBAT_fnc_displayMessage;;
    false
};


private _savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);

// Update profile saved data array
private _currentTaskData =+ DMORBAT_TaskData_default select (DMORBAT_Task - 1);
_savedData pushBack [_newName, _currentTaskData];

// Close popup
_ctrl = (_display displayCtrl IDC_GRP_DATARENAME);
_ctrl ctrlShow false;

_slotIndex = count _savedData;
DMORBAT_saveSlots set [DMORBAT_Task - 1, _slotIndex];
DMORBAT_saveSlotName = _newName;

// Update profiles combo
_ctrl = (_display displayCtrl IDC_COMBO_SAVEDDATAPROFILES);
[IDC_COMBO_SAVEDDATAPROFILES] call DMORBAT_fnc_updateSavedDataCombo;
_ctrl lbSetCurSel _slotIndex;

// Update profile display
_ctrl = (_display displayCtrl IDC_TXT_CURRENTSAVEDDATA);
_ctrl ctrlSetText format ["Profile: %1", DMORBAT_saveSlotName];

// Close profiles menu
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;

true