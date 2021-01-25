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
if (isNil "_playerIndex") exitWith { ["ERROR: No unit was selected!"] spawn DMORBAT_fnc_displayMessage; };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
// Set the new player index and retrieve loadout of new playable unit
[_taskData, "Player data", [_playerIndex, 0, getUnitLoadout ((units DMORBAT_previewGroup) select _playerIndex)]] call BIS_fnc_setToPairs;

// Set player faction as that of the playable unit
_unitClass = tvData [IDC_TREE_PLAYER_GRP1, [0, _playerIndex]];
DMORBAT_PlayerFaction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");
// systemChat format ["DMORBAT: DMORBAT_PlayerFaction: %1", DMORBAT_PlayerFaction]; 

if !([_unitClass] call DMORBAT_fnc_isMan) then {
	ctrlEnable [IDC_BT_1_GRP1, false];
	ctrlEnable [IDC_BT_2_GRP1, false];
	ctrlEnable [IDC_BT_3_GRP1, false];

	[IDC_COMBO_TASK_GROUPS_CREW, [DMORBAT_previewGroup, _playerIndex] call DMORBAT_fnc_realUnitbyIndex] call DMORBAT_fnc_updateCrewSlotsCombo;
} else {
	[IDC_TREE_PLAYER_GRP1] call DMORBAT_fnc_updatePlayerGroupTreeList;
	DMORBAT_previewUnitisPlayer = true;
	tvSetCurSel [IDC_TREE_PLAYER_GRP1, [0, _playerIndex]];
};
ctrlEnable [IDC_BT_4_GRP1, false];

// Save task settings
call DMORBAT_fnc_settingsSave;