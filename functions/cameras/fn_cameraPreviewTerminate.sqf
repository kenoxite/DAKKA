#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Terminates the preview camera. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

private ["_display", "_ctrl"];

if(!isNull DAKKA_previewCamera) then {
  DAKKA_previewCamera cameraEffect ["TERMINATE", "BACK"];
  camDestroy DAKKA_previewCamera;
  DAKKA_previewCameraPlaying = false;
  DAKKA_previewCamera = objNull;
  deleteVehicle DAKKA_cameraTarget;
  DAKKA_cameraTarget = objNull;

  _display = findDisplay IDC_MENU_MISSION_EDIT;
  _ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
  _ctrl ctrlShow false;
  DAKKA_cameraZoom = 0.75;
  DAKKA_cameraX = 0;
  DAKKA_cameraY = 0;
  _ctrl = (_display displayCtrl IDC_GRP_EDIT_CONTROLS);
  _ctrl ctrlShow false;
  DAKKA_editReference = objNull;
  _ctrl = (_display displayCtrl IDC_GRP_CAM_TYPE);
  _ctrl ctrlShow false;

  // Enable ambient fauna
  // enableEnvironment DAKKA_environment;
};  