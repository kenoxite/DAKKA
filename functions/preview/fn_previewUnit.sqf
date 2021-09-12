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

params ["_index"];
DAKKA_previewUnit = [DAKKA_previewGroup, _index] call DAKKA_fnc_realUnitbyIndex;
DAKKA_previewUnit