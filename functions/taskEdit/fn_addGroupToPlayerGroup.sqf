#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the selected group as the player group. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _grp
  _this select 1: _grpName
 

  Returns:


  Examples:

*/

params ["_idc", "_grp", "_grpName"];
private ["_taskData", "_playerGroupData", "_unitClasses", "_unitClass", "_index", "_veh", "_groupMods", "_mod", "_knownMods", "_modIndex"];

if (isNull _grp || _grpName == "") exitWith { ["ERROR: No group was selected!"] spawn DAKKA_fnc_displayMessage; };
_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
_unitClasses = [];
_groupMods = [];
_knownMods = [DAKKA_settings, "Known mods"] call BIS_fnc_getFromPairs;
{
	_veh = vehicle _x;
	if (_x == effectiveCommander _veh) then {
		_unitClasses pushBack [(typeOf _veh), rank _veh, [], 1, 0];
        // Check for the unit mod dependencies
        _mod = [typeOf _veh] call DAKKA_fnc_modsCheck;
        _groupMods pushBackUnique _mod;
	};
} forEach (units _grp);
_playerGroupData set [0, [format ["%1 (Player) ", _grpName], _unitClasses, _groupMods]];
// if (DAKKA_debug) then { diag_log format ["DAKKA: addGroupToPlayerGroup player group: %1", ((DAKKA_TaskData select (DAKKA_Task - 1)) select 3)] };

// Reset player unit
[_taskData, "Player data", [0, 0, []]] call BIS_fnc_setToPairs;
DAKKA_previewUnitisPlayer = false;

// Reset player unit data and retrieve playable unit loadout
[_taskData, "Player data", [0, 0, getUnitLoadout ((units DAKKA_previewGroup) select 0)]] call BIS_fnc_setToPairs;
// if (DAKKA_debug) then { diag_log format ["DAKKA: addGroupToPlayerGroup _playerLoadout: %1", getUnitLoadout ((units DAKKA_previewGroup) select 0)] };

// Choose crew slot if first unit is vehicle
_unitClass = (_unitClasses select 0) select 0;
_index = 0;
if (!([_unitClass] call DAKKA_fnc_isMan) && [_index] call DAKKA_fnc_checkIfSelIsPlayer) then {
	[IDC_COMBO_TASK_GROUPS_CREW, vehicle ((units DAKKA_previewGroup) select _index)] call DAKKA_fnc_updateCrewSlotsCombo;
} else {
	[_idc] call DAKKA_fnc_updatePlayerGroupTreeList;
};

tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];
ctrlEnable [IDC_BT_ADD_UNIT, false];

// Save task settings
call DAKKA_fnc_settingsSave;