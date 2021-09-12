#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Displayes the compositions on the map. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

private ["_taskData", "_worldCompositionsData", "_compositionsData", "_mrkr", "_txt", "_pos", "_dir"];

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

// Reset markers
call DAKKA_fnc_deleteCompositionMarkers;

// Create markers
// "|MARKERNAME|markerPos|markerType|markerShape|markerSize|markerDir|markerBrush|markerColor|markerAlpha|markerText"
{
  _mrkr = format ["DAKKA_mrkr_Task%1_comp_%2", DAKKA_Task, _forEachIndex + 1];
  _txt = format ["%1. %2", _forEachIndex + 1, _x select 0];
  _pos = ((_x select 1) select 0) select 1;
  _dir = ((_x select 1) select 0) select 2;
  _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos, "hd_dot", "ICON", [1, 1], _dir, "Solid", "ColorUNKNOWN", 0.8, _txt] call BIS_fnc_stringToMarker;
} forEach _compositionsData;

true