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

private _savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);
private _slotIndex = (DMORBAT_saveSlots select (DMORBAT_Task - 1));
private _currentSlot = _savedData select _slotIndex;

if (count _savedData > 1) then {
    _savedData deleteAt _slotIndex;

    // Update profiles combo
    _ctrl = (_display displayCtrl IDC_COMBO_SAVEDDATAPROFILES);
    [IDC_COMBO_SAVEDDATAPROFILES] call DMORBAT_fnc_updateSavedDataCombo;
    _ctrl lbSetCurSel ((count _savedData) - 1);

    // Close profiles menu
    _ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
    _ctrl ctrlShow false;
} else {
    [format ["ERROR: Deleting not possible. At least one profile must be present!"]] spawn DMORBAT_fnc_displayMessage;;
};

true