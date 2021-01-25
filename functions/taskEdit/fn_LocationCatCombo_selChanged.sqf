#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the AO location categories combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath"];
private ["_mrkr"];
diag_log format ["DMORBAT: LocationCatCombo_selChanged _selectionPath:%1", _selectionPath];
if (_selectionPath < 0) exitWith { false };

[_idc] call DMORBAT_fnc_updateLocationsCombo;

true