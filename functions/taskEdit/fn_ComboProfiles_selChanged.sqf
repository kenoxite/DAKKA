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
if (DAKKA_debug) then { diag_log format ["DAKKA: ComboProfiles_selChanged _selectionPath:%1", _selectionPath] };
private _slotIndex = (DAKKA_saveSlots select (DAKKA_Task - 1));
if (_selectionPath < 0 || _slotIndex == _selectionPath) exitWith { false };

disableSerialization;
private _display = findDisplay IDC_MENU_MISSION_EDIT;

// Save task settings
// call DAKKA_fnc_settingsSave;

// Update all controls - part 1
if (DAKKA_lastPage == 5) then {
    [true] call DAKKA_fnc_compositionRemove;
    waitUntil {DAKKA_compositionsRemoved};
};

if (count DAKKA_saveSlots >= DAKKA_Task) then {
    DAKKA_saveSlots set [DAKKA_Task - 1, _selectionPath];
} else {
    DAKKA_saveSlots pushBack _selectionPath;
};

// Save last selected profile
["Selected Profiles"] call DAKKA_fnc_globalSettingsSave;

// Load task settings
call DAKKA_fnc_settingsLoad;

// Update profile display
_ctrl = _display displayCtrl IDC_TXT_CURRENTSAVEDDATA;
_ctrl ctrlSetText format ["Profile: %1", DAKKA_saveSlotName];

// Update all controls - part 2
if (DAKKA_lastPage == 2) then {
    _ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
    [IDC_TREE_PLAYER_GRP1] call DAKKA_fnc_updatePlayerGroupTreeList;
};

if (DAKKA_lastPage > 2 && DAKKA_lastPage < 5) then {
    _ctrl = (_display displayCtrl IDC_TREE_GRP1);
    [IDC_TREE_GRP1, 1, if (DAKKA_lastPage == 3) then { false } else { true }] call DAKKA_fnc_updateCustomGroupsTreeList;

    _ctrl = (_display displayCtrl IDC_TREE_GRP2);
    [IDC_TREE_GRP2, 2, if (DAKKA_lastPage == 3) then { false } else { true }] call DAKKA_fnc_updateCustomGroupsTreeList;

    _ctrl = (_display displayCtrl IDC_TREE_GRP3);
    [IDC_TREE_GRP3, 3, if (DAKKA_lastPage == 3) then { false } else { true }] call DAKKA_fnc_updateCustomGroupsTreeList;
};

if (DAKKA_lastPage == 5) then {
    _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
    _ctrl lbSetCurSel -1;
    call DAKKA_fnc_deleteTaskMarkers;
    call DAKKA_fnc_deleteCompositionMarkers;
};

// Reload page
[] execVM format ["menuPages\page%1.sqf", DAKKA_lastPage];

true