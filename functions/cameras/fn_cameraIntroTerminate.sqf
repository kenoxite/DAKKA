#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Terminates the intro camera. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

if (!isNull DMORBAT_cameraIntro) then {
  DMORBAT_cameraIntro cameraEffect ["TERMINATE", "BACK"];
  camDestroy DMORBAT_cameraIntro;
  DMORBAT_cameraIntroPlaying = false;
  DMORBAT_cameraIntro = objNull;

  // [group DMORBAT_introTarget] call DMORBAT_fnc_deleteGroup;
};  
