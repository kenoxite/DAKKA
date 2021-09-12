#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Removes the selected unit from the player's group. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _selectionPath
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath"];
private ["_taskData", "_unitsData", "_index", "_playerIndex", "_sel", "_thisPlayerGroupData", "_playerGroupData", "_playerData"];
disableSerialization;
tvSetCurSel [IDC_TREE_FACTION_GROUPS, [-1]];
ctrlEnable [IDC_BT_ADD_GROUP, false];
tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];
ctrlEnable [IDC_BT_ADD_UNIT, false];

if ((count _selectionPath) < 1) exitWith { ["ERROR: No unit or group was selected!"] spawn DAKKA_fnc_displayMessage; };
tvDelete [_idc, _selectionPath];

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
_thisPlayerGroupData = _playerGroupData select (_selectionPath select 0);

_unitsData = _thisPlayerGroupData select 1;

if (DAKKA_debug) then { diag_log format ["DAKKA: removeFromPlayerGroup _thisPlayerGroupData:%1", _thisPlayerGroupData] };

if ((count _selectionPath) > 1) then {
  _index = _selectionPath select 1;
  _unitsData deleteAt _index;
  if (count _unitsData == 0) then {
    // Delete empty group if no units left
    [_taskData, "Player group", []] call BIS_fnc_setToPairs;
    call DAKKA_fnc_previewGroupDelete;
  } else {
    DAKKA_PreviewGroupName = "";  
    DAKKA_PreviewGroupID = "";  
    // Check if player unit was removed. If so, last unit is now player
    _playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
    _playerIndex = _playerData select 0;
    if (_playerIndex > (count _unitsData) - 1) then {
      [(count _unitsData) - 1] call DAKKA_fnc_setPlayerUnit;
    } else {
      if (_index == (_playerIndex - 1)) then {
        [(_playerIndex - 1) max 0] call DAKKA_fnc_setPlayerUnit;
      };
    };
    _thisPlayerGroupData set [0, "Custom Group"];
    call DAKKA_fnc_previewPlayerGroup;
  };
} else {
    [_taskData, "Player group", []] call BIS_fnc_setToPairs;
  _unitsData = [];
  call DAKKA_fnc_previewGroupDelete;
};

// ctrlEnable [IDC_BT_1_GRP1, false];
ctrlEnable [IDC_BT_2_GRP1, false];
ctrlEnable [IDC_BT_3_GRP1, false];
ctrlEnable [IDC_BT_4_GRP1, false];
[_idc] call DAKKA_fnc_updatePlayerGroupTreeList;

// Reselect element in tree list
if (count _unitsData > 0) then {
    private _tvCount = tvCount [_idc, [_selectionPath select 0]];
    _sel = [_selectionPath select 0, (_selectionPath select 1) min (_tvCount - 1)];
    tvSetCurSel [_idc, _sel];
    _ctrl tvExpand [_selectionPath select 0];
};

if ((tvCount [_idc, []]) == 0) then {
    tvSetCurSel [IDC_TREE_FACTION_GROUPS, [0, 0]];
};

// if (DAKKA_debug) then { diag_log format ["DAKKA: player group: %1", ((DAKKA_TaskData select (DAKKA_Task - 1)) select 3)] };

// Save task settings
call DAKKA_fnc_settingsSave;