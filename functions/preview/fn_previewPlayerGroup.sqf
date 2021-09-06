#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Previews the player's group. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

private ["_taskData", "_playerGroupData", "_unitClassArr", "_ranksArr", "_loadoutsArr", "_groupMods"];

call DMORBAT_fnc_previewGroupDelete;
_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
_playerGroupData = _playerGroupData select 0;

_unitClassArr = [];
_ranksArr = [];
_loadoutsArr = [];
{
	_unitClassArr pushBack (_x select 0);
	_ranksArr pushBack (_x select 1);
	_loadoutsArr pushBack (_x select 2);
} forEach (_playerGroupData select 1);
_groupMods = _playerGroupData select 2;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: _unitClassArr: %1", _unitClassArr] };
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: previewPlayerGroup CALLING PREVIEWGROUP", ""] };
[_unitClassArr, _ranksArr, _loadoutsArr, _groupMods] call DMORBAT_fnc_previewGroup;