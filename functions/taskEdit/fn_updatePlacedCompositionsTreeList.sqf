#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available AO location categories. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc"];
private ["_ctrl", "_indexCtrl", "_taskData", "_worldCompositionsData", "_compositionsData", "_i"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc;
if (isNull _ctrl) exitWith { 
  diag_log format ["DMORBAT: --- ERROR --- updatePlacedCompositionsTreeList CONTROL %1  could not be found!", _ctrl];
};
tvClear _ctrl;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

_i = 0;
{ 
  _i = _forEachIndex;
  _ctrl tvAdd [[], format ["%1. %2", _i + 1, _x select 0]];
  _ctrl tvSetData [[_i], _x select 0];
} forEach _compositionsData; 

true