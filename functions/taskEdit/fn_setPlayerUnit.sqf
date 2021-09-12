#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the selected unit as a player. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_playerIndex"];
private ["_taskData", "_unitClass"];
disableSerialization;
tvSetCurSel [IDC_TREE_FACTION_GROUPS, [-1]];
ctrlEnable [IDC_BT_ADD_GROUP, false];
tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];
ctrlEnable [IDC_BT_ADD_UNIT, false];
if (isNil "_playerIndex") exitWith { ["ERROR: No unit was selected!"] spawn DAKKA_fnc_displayMessage; };

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
// Set the new player index and retrieve loadout of new playable unit
[_taskData, "Player data", [_playerIndex, 0, getUnitLoadout ((units DAKKA_previewGroup) select _playerIndex)]] call BIS_fnc_setToPairs;

// Set player faction as that of the playable unit
_unitClass = tvData [IDC_TREE_PLAYER_GRP1, [0, _playerIndex]];
DAKKA_PlayerFaction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");
// systemChat format ["DAKKA: DAKKA_PlayerFaction: %1", DAKKA_PlayerFaction]; 

if !([_unitClass] call DAKKA_fnc_isMan) then {
	ctrlEnable [IDC_BT_1_GRP1, false];
	ctrlEnable [IDC_BT_2_GRP1, false];
	ctrlEnable [IDC_BT_3_GRP1, false];

	[IDC_COMBO_TASK_GROUPS_CREW, [DAKKA_previewGroup, _playerIndex] call DAKKA_fnc_realUnitbyIndex] call DAKKA_fnc_updateCrewSlotsCombo;
} else {
	[IDC_TREE_PLAYER_GRP1] call DAKKA_fnc_updatePlayerGroupTreeList;
	DAKKA_previewUnitisPlayer = true;
	tvSetCurSel [IDC_TREE_PLAYER_GRP1, [0, _playerIndex]];
};
ctrlEnable [IDC_BT_4_GRP1, false];

// Save task settings
call DAKKA_fnc_settingsSave;