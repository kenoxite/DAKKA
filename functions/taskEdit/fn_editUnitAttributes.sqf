#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Opens the pop-up that allows the user to edit the unit's attributes and populates it. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath", ["_groupNumber", 1], ["_enemy", true]];
private ["_display", "_ctrl", "_taskData", "_groupsData", "_groupsCategoryData", "_thisCategoryGroups", "_thisGroupData", "_unitsData", "_unit", "_unitIndex", "_thisUnitData", "_unitClass", "_unitRank", "_unitLoadout", "_unitPresence", "_unitSkill", "_displayName", "_presence", "_skill", "_units", "_groupMods", "_groupIndex"];

if ((count _selectionPath) < 1 || (_groupNumber > 0 && (count _selectionPath) == 1 && (_selectionPath select 0) == 0)) exitWith { ["ERROR: No unit or group was selected!"] spawn DMORBAT_fnc_displayMessage; };

_groupIndex = (_selectionPath select 0) - 1;
_unitIndex = _selectionPath select 1;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
if (_groupNumber > 0) then {
    // Custom group
    _groupsData = [_taskData, format ["%1 groups", if (_enemy) then { "Enemy" } else { "Friendly" }]] call BIS_fnc_getFromPairs;
    _groupsCategoryData = _groupsData select (_groupNumber - 1);
    _thisCategoryGroups = _groupsCategoryData select 1;
    _thisGroupData = _thisCategoryGroups select _groupIndex;
    diag_log format ["DMORBAT: editUnitAttributes  _groupIndex: %2 _thisGroupData: %1", _thisGroupData, _groupIndex];
} else {
    // Player group
    _groupsData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
    _thisGroupData = _groupsData select 0;
};
_unitsData = _thisGroupData select 1;
diag_log format ["DMORBAT: editUnitAttributes _unitsData: %1", _unitsData];

_display = findDisplay IDC_MENU_MISSION_EDIT;

if ((count _selectionPath) > 1) then {
  // Edit single unit
  _unit = (units DMORBAT_previewGroup) select _unitIndex;

  _thisUnitData = _unitsData select _unitIndex;
  _unitPresence = _thisUnitData select 3;
  _unitSkill = _thisUnitData select 4;

  // Reset combo selections
  _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_PRESENCE);
  _ctrl lbSetCurSel (_unitPresence / 0.25);
  _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_SKILL);
  _ctrl lbSetCurSel _unitSkill;

  // Edit title
  _ctrl = (_display displayCtrl _idc);
  _displayName = _ctrl tvText _selectionPath;
  _ctrl = (_display displayCtrl IDC_TITLE_UNITEDIT);
  _ctrl ctrlSetText format ["Edit: %1", _displayName];
} else {
  // Edit group
  _unit = (units DMORBAT_previewGroup) select 0;
  _thisUnitData = _unitsData select 0;

  // Reset combo selections
  _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_PRESENCE);
  _ctrl lbSetCurSel 4;
  _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_SKILL);
  _ctrl lbSetCurSel 0;

  // Edit title
  _ctrl = (_display displayCtrl _idc);
  _displayName = _ctrl tvText [_selectionPath select 0];
  _ctrl = (_display displayCtrl IDC_TITLE_UNITEDIT);
  _ctrl ctrlSetText format ["Edit: %1", _displayName];
};
// diag_log format ["DMORBAT: editUnitAttributes _thisUnitData: %1", _thisUnitData];
DMORBAT_editedUnit = _unit;
diag_log format ["DMORBAT: editUnitAttributes _unit: %1", _unit];
DMORBAT_editAccepted = false;

_groupMods = _thisGroupData select 2;

// Show pop-up
_ctrl = (_display displayCtrl IDC_GRP_UNITEDIT);
_ctrl ctrlShow true;

// Bring window up front
_ctrl = (_display displayCtrl IDC_BT_UNITEDIT_OK);
ctrlSetFocus _ctrl;

// Wait for pop-up to close to apply changes
_ctrl = (_display displayCtrl IDC_GRP_UNITEDIT);
while { !isNull DMORBAT_editedUnit } do {
  waitUntil { !ctrlShown  _ctrl };

  if (DMORBAT_editAccepted) then {

    if ((count _selectionPath) > 1) then {
      _units = [_unit];
    } else {
      _units = units DMORBAT_previewGroup;
    };

    {
        if (_forEachIndex <= (count _unitsData) - 1) then {
          if (count _selectionPath == 1) then {
            _thisUnitData = _unitsData select _forEachIndex;
          };
          if (!isNil "_thisUnitData") then {
            diag_log format ["DMORBAT: editUnitAttributes _thisUnitData: %1", _thisUnitData];
            _unitClass = _thisUnitData select 0;
            _unitRank = _thisUnitData select 1;
            _unitLoadout = _thisUnitData select 2;
            _unitPresence = _thisUnitData select 3;
            _unitSkill = _thisUnitData select 4;
            // Set presence
            _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_PRESENCE);
            _presence = call compile format ["%1 * 0.25", lbCurSel _ctrl];
            _thisUnitData set [3, _presence];
            // Set skill
            _ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_SKILL);
            // Skill as number
            _skill = lbCurSel _ctrl;
            _thisUnitData set [4, _skill];

            // Update tooltips
            switch (_groupNumber) do {
              case 0: {
                _idc = IDC_TREE_PLAYER_GRP1;
              };
              case 1: {
                _idc = IDC_TREE_GRP1;
              };
              case 2: {
                _idc = IDC_TREE_GRP2;
              };
              case 3: {
                _idc = IDC_TREE_GRP3;
              };
            }; 
            private _pathIndex = if (count _selectionPath == 1) then { [_selectionPath select 0, _forEachIndex] } else { _selectionPath };
            _ctrl = (_display displayCtrl _idc);
            _ctrl tvSetTooltip [_pathIndex,
                                    [
                                        (_display displayCtrl _idc) tvText _pathIndex,
                                        _unitClass,
                                        if (count _selectionPath == 1) then { _forEachIndex } else { _unitIndex },
                                        count _unitLoadout,
                                        _presence,
                                        _skill,
                                        _groupMods,
                                        if (_groupNumber == 0) then { true } else { false }
                                    ] call DMORBAT_fnc_createUnitTooltip
                                ];

            // diag_log format ["DMORBAT: editUnitAttributes new settings: %1", _thisUnitData select [3, 1]];
          };
      };
    } forEach _units;

    DMORBAT_editAccepted = false;
    DMORBAT_editedUnit = objNull;

    // Save task settings
    call DMORBAT_fnc_settingsSave;
  };
};