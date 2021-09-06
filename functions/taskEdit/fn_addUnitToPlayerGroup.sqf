#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Adds the selected unit to the player group. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _grp
  _this select 1: _grpName
 

  Returns:


  Examples:

*/

params ["_idc", "_unit"];
private ["_taskData", "_playerGroupData", "_unitClass", "_index", "_ctrl", "_groupMods", "_mod", "_knownMods", "_modIndex"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc;

if (isNull _unit) exitWith { systemChat "DMORBAT: --- ERROR --- No unit was selected!" };
_realUnit = [DMORBAT_previewGroup, 0] call DMORBAT_fnc_realUnitbyIndex;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToPlayerGroup _realUnit: %1", _realUnit] };
_unitClass = (typeOf _realUnit);
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToPlayerGroup _unitClass: %1", _unitClass] };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs; 
if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToPlayerGroup _playerGroupData: %1", _playerGroupData] };
// Check for the unit mod dependencies
_mod = [_unitClass] call DMORBAT_fnc_modsCheck;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToPlayerGroup _knownMods: %1", _knownMods] };
if ((count _playerGroupData) == 0) then {
  // Create new group
  _index = _playerGroupData pushBack ["Custom Group", [[_unitClass, "SERGEANT", [], 1, 0]], [_mod]];
    // Reset player unit
    [_taskData, "Player data", [0, 0, []]] call BIS_fnc_setToPairs;
    DMORBAT_previewUnitisPlayer = false;
} else {
  // Add unit to existing group
  (_playerGroupData select 0) set [0, "Custom Group"];
  _index = ((_playerGroupData select 0) select 1) pushBack [_unitClass, "PRIVATE", [], 1, 0];
  // Add the unit mod dependencies
  _groupMods = (_playerGroupData select 0) select 2;
  _groupMods pushBackUnique _mod;
  (_playerGroupData select 0) set [2, _groupMods];
};

// Choose crew slot if unit is vehicle
if (!([_unitClass] call DMORBAT_fnc_isMan) && [_index] call DMORBAT_fnc_checkIfSelIsPlayer) then {
  // if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToPlayerGroup adding unit: %1", _realUnit] };
  [IDC_COMBO_TASK_GROUPS_CREW, _realUnit] call DMORBAT_fnc_updateCrewSlotsCombo;
} else {
  [_idc] call DMORBAT_fnc_updatePlayerGroupTreeList;
};
((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_TREE_FACTION_GROUPS) tvSetCurSel [-1];
((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_BT_ADD_GROUP) ctrlEnable false;

// Save task settings
call DMORBAT_fnc_settingsSave;