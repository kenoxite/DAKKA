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

if (!isNull DAKKA_cameraIntro) then {
  DAKKA_cameraIntro cameraEffect ["TERMINATE", "BACK"];
  camDestroy DAKKA_cameraIntro;
  DAKKA_cameraIntroPlaying = false;
  DAKKA_cameraIntro = objNull;

  // [group DAKKA_introTarget] call DAKKA_fnc_deleteGroup;
};  
