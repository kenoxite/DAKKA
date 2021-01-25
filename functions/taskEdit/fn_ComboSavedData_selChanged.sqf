#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of saved data combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath"];
diag_log format ["DMORBAT: ComboSavedData_selChanged _selectionPath:%1", _selectionPath];
private _slotIndex = (DMORBAT_saveSlots select (DMORBAT_Task - 1));
if (_selectionPath < 0 || _slotIndex == _selectionPath) exitWith { false };

disableSerialization;
private _display = findDisplay IDC_MENU_MISSION_EDIT;

// Save task settings
// call DMORBAT_fnc_settingsSave;

// Update all controls - part 1
if (DMORBAT_lastPage == 5) then {
    [true] call DMORBAT_fnc_compositionRemove;
};

if (count DMORBAT_saveSlots >= DMORBAT_Task) then {
    DMORBAT_saveSlots set [DMORBAT_Task - 1, _selectionPath];
} else {
    DMORBAT_saveSlots pushBack _selectionPath;
};

// Save last selected profile
["Selected Profiles"] call DMORBAT_fnc_globalSettingsSave;

// Load task settings
call DMORBAT_fnc_settingsLoad;

// Update profile display
_ctrl = _display displayCtrl IDC_TXT_CURRENTSAVEDDATA;
_ctrl ctrlSetText format ["Profile: %1", DMORBAT_saveSlotName];

// Update all controls - part 2
if (DMORBAT_lastPage == 2) then {
    _ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
    [IDC_TREE_PLAYER_GRP1] call DMORBAT_fnc_updatePlayerGroupTreeList;
};

if (DMORBAT_lastPage > 2 && DMORBAT_lastPage < 5) then {
    _ctrl = (_display displayCtrl IDC_TREE_GRP1);
    [IDC_TREE_GRP1, 1, if (DMORBAT_lastPage == 3) then { false } else { true }] call DMORBAT_fnc_updateCustomGroupsTreeList;

    _ctrl = (_display displayCtrl IDC_TREE_GRP2);
    [IDC_TREE_GRP2, 2, if (DMORBAT_lastPage == 3) then { false } else { true }] call DMORBAT_fnc_updateCustomGroupsTreeList;

    _ctrl = (_display displayCtrl IDC_TREE_GRP3);
    [IDC_TREE_GRP3, 3, if (DMORBAT_lastPage == 3) then { false } else { true }] call DMORBAT_fnc_updateCustomGroupsTreeList;
};

if (DMORBAT_lastPage == 5) then {
    _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
    _ctrl lbSetCurSel -1;
    call DMORBAT_fnc_deleteTaskMarkers;
    call DMORBAT_fnc_deleteCompositionMarkers;
};

// Reload page
[] execVM format ["menuPages\page%1.sqf", DMORBAT_lastPage];

true