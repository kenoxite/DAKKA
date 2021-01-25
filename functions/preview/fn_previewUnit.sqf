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
DMORBAT_previewUnit = [DMORBAT_previewGroup, _index] call DMORBAT_fnc_realUnitbyIndex;
DMORBAT_previewUnit