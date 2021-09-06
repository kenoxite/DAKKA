#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Adds the selected group as a custom group. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _grp
  _this select 1: _grpName
 

  Returns:


  Examples:

*/

params [["_enemy", true]];
private ["_grp", "_grpName", "_idc", "_groupNumber", "_selectionPath", "_taskData", "_thisCategoryGroups", "_groupsData", "_groupsCategoryData", "_unitsData", "_unitClasses", "_unitClass", "_index", "_veh", "_thisCategoryName", "_grpType", "_groupMods", "_mod", "_knownMods", "_modIndex"];

_grp = DMORBAT_previewGroup;
_grpName = tvData [IDC_TREE_FACTION_GROUPS, (tvCurSel IDC_TREE_FACTION_GROUPS) select [0, 2]];
if (isNull _grp || _grpName == "") exitWith { ["ERROR: No group was selected!"]spawn DMORBAT_fnc_displayMessage; };

// Override current custom group selection with one based on the selected group units type
_groupNumber = DMORBAT_customGroupsSelection select 0;
if (DMORBAT_debug) then { diag_log format ["DMORBAT: addGroupToGroup original _groupNumber: %1", _groupNumber] };
_selectionPath = DMORBAT_customGroupsSelection select 1;
_grpType = "";
if (DMORBAT_Task == 2) then {
  _grpType = [_grp] call DMORBAT_fnc_groupType;
  switch (_grpType) do {
    case "Inf": {
      _groupNumber = 1;
    };
    case "Land": {
      _groupNumber = 2;
    };
    case "Air": {
      _groupNumber = 3;
    };
    default {
      _groupNumber = 2; 
    };
  };  
};
if (DMORBAT_debug) then { diag_log format ["DMORBAT: addGroupToGroup final _groupNumber: %1 _grpType: %2", _groupNumber, _grpType] };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, format ["%1 groups", if (_enemy) then { "Enemy" } else { "Friendly" }]] call BIS_fnc_getFromPairs;
_groupsCategoryData = _groupsData select (_groupNumber - 1);
_thisCategoryName = _groupsCategoryData select 0;
_thisCategoryGroups = _groupsCategoryData select 1;

_unitClasses = [];
_groupMods = [];
{
  _veh = vehicle _x;
  if (_x == effectiveCommander _veh) then {
    _unitClasses pushBack [(typeOf _veh), rank _veh, [], 1, 0];
    // Check for the unit mod dependencies
    _mod = [typeOf _veh] call DMORBAT_fnc_modsCheck;
    _groupMods pushBackUnique _mod;
  };
} forEach (units _grp);

if ((count units _grp) > 1) then {
  _grpName = format ["%1", _grpName];
} else {
  _grpName = format ["%1", _thisCategoryName];
};
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addGroupToGroup _grpName: %1", _grpName] };
_thisCategoryGroups pushBack [_grpName, _unitClasses, _groupMods];
_index = (count _thisCategoryGroups);

// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addGroupToGroup _thisCategoryGroups: %1", _thisCategoryGroups] };

[-1, _groupNumber, _enemy] call DMORBAT_fnc_updateCustomGroupsTreeList;

tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];
ctrlEnable [IDC_BT_ADD_UNIT, false];

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
((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc) tvSetCurSel [_index];

// Save task settings
call DMORBAT_fnc_settingsSave;