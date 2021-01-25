#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Adds the selected unit to a custom group or creates a new custom group if conditions apply. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _grp
  _this select 1: _grpName
 

  Returns:


  Examples:

*/

params [["_enemy", true]];
// diag_log format ["DMORBAT: addUnitToGroup params: %1", _enemy];
private ["_groupNumber", "_selectionPath", "_taskData", "_groupsCategoryData", "_thisCategoryGroups", "_groupsData", "_thisGroupData", "_unitsData", "_unitClass", "_index", "_display", "_ctrl", "_thisCategoryName", "_classType", "_isNew", "_groupMods", "_mod", "_knownMods", "_modIndex", "_groupIndex"];  

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;

_unitClass = tvData [IDC_TREE_FACTION_UNITS, tvCurSel IDC_TREE_FACTION_UNITS];
diag_log format ["DMORBAT: addUnitToGroup _unitClass: %1", _unitClass];
if (count _unitClass == 0) exitWith { ["ERROR: No unit was selected!"] spawn DMORBAT_fnc_displayMessage; };
_isNew = false;
_groupNumber = DMORBAT_customGroupsSelection select 0;
_selectionPath = DMORBAT_customGroupsSelection select 1;
if (DMORBAT_Task == 2) then {
  _classType = [_unitClass] call DMORBAT_fnc_returnClassType;
  // Allow infantry being part of land groups
  if (_classType == "Inf" && _groupNumber == 2) then {
    _classType = "Land";
  };
  switch (_classType) do {
    case "Inf": {
      if (_groupNumber != 1) then { _selectionPath = [0]; _isNew = true;};
      _groupNumber = 1;
    };
    case "Land": {
      if (_groupNumber != 2) then { _selectionPath = [0]; _isNew = true;};
      _groupNumber = 2;
    };
    case "Air": {
      if (_groupNumber != 3) then { _selectionPath = [0]; _isNew = true;};
      _groupNumber = 3;
    };
    default {
      if (_groupNumber != 2) then { _selectionPath = [0]; _isNew = true;};
      _groupNumber = 2; 
    };
  };  
};
diag_log format ["DMORBAT: addUnitToGroup _groupNumber: %1 _selectionPath: %2", _groupNumber, _selectionPath];

_groupIndex = (_selectionPath select 0) - 1;

// _mainArr = (DMORBAT_TaskData select (DMORBAT_Task - 1)) select (if (_enemy) then { 5 } else { 4 });  
// _groupArr = (_mainArr select (_groupNumber - 1)) select 1;
// _unitsArr = (_groupArr select (_selectionPath select 0)) select 1;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, format ["%1 groups", if (_enemy) then { "Enemy" } else { "Friendly" }]] call BIS_fnc_getFromPairs;
_groupsCategoryData = _groupsData select (_groupNumber - 1); 
_thisCategoryName = _groupsCategoryData select 0;
_thisCategoryGroups = _groupsCategoryData select 1;
// diag_log format ["DMORBAT: addUnitToGroup _thisCategoryGroups: %1", _thisCategoryGroups];

// Check for the unit mod dependencies
_mod = [_unitClass] call DMORBAT_fnc_modsCheck;

if (_groupIndex < 0) then {
    // Add group to groups array
    _thisCategoryGroups pushBack [format ["%1", _thisCategoryName], [[_unitClass, "SERGEANT", [], 1, 0]], [_mod]];
    // diag_log format ["DMORBAT: addUnitToGroup _thisCategoryGroups: %1", _thisCategoryGroups];
    _groupIndex = (count _thisCategoryGroups);
    _index = 0;
} else {
    // Add group units to selected group
    _thisGroupData = _thisCategoryGroups select _groupIndex;
    // diag_log format ["DMORBAT: addUnitToGroup _groupIndex: %2 _thisGroupData: %1", _thisGroupData, _groupIndex];
    _unitsData = _thisGroupData select 1;
    // diag_log format ["DMORBAT: addUnitToGroup _unitsData: %1", _unitsData];
    _unitsData pushBack [_unitClass, "PRIVATE", [], 1, 0];
    DMORBAT_PreviewGroupName = "";  
    DMORBAT_PreviewGroupID = "";
    _groupIndex = (_selectionPath select 0);
    _index = (count _unitsData) - 1;

    // diag_log format ["DMORBAT: addUnitToGroup _unitsData: %1", _unitsData];
    // Add the unit mod dependencies
    _groupMods = _thisGroupData select 2;
    _groupMods pushBackUnique _mod;
    _thisGroupData set [2, _groupMods];
};

[-1, _groupNumber, _enemy] call DMORBAT_fnc_updateCustomGroupsTreeList;
_ctrl = _display displayCtrl IDC_TREE_FACTION_GROUPS;
_ctrl tvSetCurSel [-1];
_ctrl = _display displayCtrl IDC_BT_ADD_GROUP;
_ctrl ctrlEnable false;

switch (_groupNumber) do {
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
_ctrl = _display displayCtrl _idc;
_ctrl tvExpand [_groupIndex];
_ctrl tvSetCurSel [_groupIndex, _index];

// Save task settings
call DMORBAT_fnc_settingsSave;