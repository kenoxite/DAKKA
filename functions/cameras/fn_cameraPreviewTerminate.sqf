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

if(!isNull DMORBAT_previewCamera) then {
  DMORBAT_previewCamera cameraEffect ["TERMINATE", "BACK"];
  camDestroy DMORBAT_previewCamera;
  DMORBAT_previewCameraPlaying = false;
  DMORBAT_previewCamera = objNull;
  deleteVehicle DMORBAT_cameraTarget;
  DMORBAT_cameraTarget = objNull;

  _display = findDisplay IDC_MENU_MISSION_EDIT;
  _ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
  _ctrl ctrlShow false;
  DMORBAT_cameraZoom = 0.75;
  DMORBAT_cameraX = 0;
  DMORBAT_cameraY = 0;
  _ctrl = (_display displayCtrl IDC_GRP_EDIT_CONTROLS);
  _ctrl ctrlShow false;
  DMORBAT_editReference = objNull;
  _ctrl = (_display displayCtrl IDC_GRP_CAM_TYPE);
  _ctrl ctrlShow false;

  // Enable ambient fauna
  // enableEnvironment DMORBAT_environment;
};  