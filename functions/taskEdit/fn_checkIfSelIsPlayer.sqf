#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Returns wether the selected unit is set as a player. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_index"];
private ["_taskData", "_playerData", "_playerIndex"];

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs; 
_playerIndex = _playerData select 0;
_index == _playerIndex