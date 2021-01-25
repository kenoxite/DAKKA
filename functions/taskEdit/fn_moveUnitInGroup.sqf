#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Moves the unit up and down in the group list. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _selectionPath
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath", ["_up", false]];
private ["_unitsArr", "_index", "_unitClass", "_newIndex", "_newArray", "_playerIndex", "_isPlayer"];
disableSerialization;
tvSetCurSel [IDC_TREE_FACTION_GROUPS, [-1]];
ctrlEnable [IDC_BT_ADD_GROUP, false];
tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];
ctrlEnable [IDC_BT_ADD_UNIT, false];
_unitsArr = (((DMORBAT_TaskData select (DMORBAT_Task - 1)) select 3) select 0) select 1;
_index = _selectionPath select 1;
_isPlayer = [_index] call DMORBAT_fnc_checkIfSelIsPlayer;
_playerIndex = ((DMORBAT_TaskData select (DMORBAT_Task - 1)) select 6) select 0;
_unitClass = _unitsArr select _index;
// diag_log format ["DMORBAT: _unitClass: %1", _unitClass];
_newIndex=-1;
_newArray = _unitsArr;
if (_up) then {
  if (_index - 1 >= 0) then {
    _newIndex = _index - 1;
  } else {
    ctrlEnable [IDC_BT_2_GRP1, false];
  };
} else {
  if (_index + 1 <= (count _unitsArr) - 1) then {
    _newIndex = _index + 1;
  } else {
    ctrlEnable [IDC_BT_3_GRP1, false];
  };
};
if (_newIndex >= 0) then {
  if (_isPlayer) then {
    _playerIndex = _newIndex;
  } else {
    if (_up) then {
      if (_newIndex == _playerIndex) then {
        _playerIndex = _playerIndex + 1;
      };
    } else {
      if (_newIndex == _playerIndex) then {
        _playerIndex = _playerIndex - 1;
      };
    };
  };
  ((DMORBAT_TaskData select (DMORBAT_Task - 1)) select 6) set [0, _playerIndex];

  _newArray deleteAt _index;
  _newIndex = if (_up) then { _index - 1 } else { _index + 1 };
  _newArray = [_newArray, [_unitClass], _newIndex] call BIS_fnc_arrayInsert;
  // diag_log format ["DMORBAT: _newArray: %1", _newArray];
  (((DMORBAT_TaskData select (DMORBAT_Task - 1)) select 3) select 0) set [1, _newArray];
  // [_playerIndex] call DMORBAT_fnc_setPlayerUnit;
  // diag_log format ["DMORBAT: player group: %1", ((DMORBAT_TaskData select (DMORBAT_Task - 1)) select 3)];

  ctrlEnable [IDC_BT_1_GRP1, false];
  ctrlEnable [IDC_BT_2_GRP1, false];
  ctrlEnable [IDC_BT_3_GRP1, false];
  ctrlEnable [IDC_BT_4_GRP1, false];
  [_idc] call DMORBAT_fnc_updatePlayerGroupTreeList;
  call DMORBAT_fnc_previewPlayerGroup;
  tvSetCurSel [_idc, [_selectionPath select 0, _newIndex]];
};