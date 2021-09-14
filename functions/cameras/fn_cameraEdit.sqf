#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Initiates the edit camera. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_baseTarget", ["_cameraAngle", "top"], ["_camDist", 20]];
private ["_camera", "_display", "_ctrl", "_targetPos", "_targetDir", "_target", "_angle", "_coords"];
_angle = 180;
showcinemaborder false; 
if (DAKKA_debug) then { diag_log format ["DAKKA: cameraEdit - Terminating preview camera..."] };
call DAKKA_fnc_cameraPreviewTerminate;
// waitUntil { isNull DAKKA_previewCamera };
waitUntil { DAKKA_cameraPreviewTerminateDone };
// Disable ambient fauna
enableEnvironment [false, true];
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
_ctrl ctrlShow true;
DAKKA_previewCamera = "camera" camCreate [0, 0, 0];
_camera = DAKKA_previewCamera;
_targetPos = getPosATL _baseTarget;
_targetDir = getDir _baseTarget;
_target = "Land_HelipadEmpty_F" createVehicle _targetPos;
_target setDir _targetDir;
_target setPos _targetPos;
DAKKA_previewCameraPlaying = true;

_camera cameraEffect ["INTERNAL", "BACK"];
switch (_cameraAngle) do {
	case "high": {
		// _camera camPrepareRelPos [0, 20, 20];
		// _coords = [_target, _camDist * 2, _angle] call BIS_fnc_relPos;
        _coords = _target getPos [_camDist * 2, _angle];
		_coords set [2, _camDist];
		_camera camPreparePos _coords;
	};
	case "top";
	default {
		_camera camPrepareRelPos [0, 0, _camDist * 3];
	};
};
_camera camPrepareFOV DAKKA_cameraZoom;
_camera camPrepareFocus [-1, -1];
_camera camPrepareTarget _target;
_camera camCommitPrepared 0;

waitUntil { camCommitted _camera || !(DAKKA_previewCameraPlaying)};
cameraEffectEnableHUD true;
cutText ["", "BLACK IN", 2];

while { DAKKA_previewCameraPlaying && !isNull _camera } do {
	waitUntil { camCommitted _camera || !(DAKKA_previewCameraPlaying)};
	if(!isNull _camera && DAKKA_previewCameraPlaying) then {
		// _targetPos = [(_targetPos select 0) + (DAKKA_cameraX), (_targetPos select 1) - (DAKKA_cameraY), (_targetPos select 2)];
		// _target setPosATL _targetPos;
		// _camera camPrepareTarget _target;
		// _camera camPrepareRelPos [0, 0, 50];
		_targetPos = getPosATL _baseTarget;
		_targetDir = getDir _baseTarget;
		switch (_cameraAngle) do {
			case "high": {
				// _camera camPrepareRelPos [0 - ((DAKKA_cameraX * 10)), 20, 20 - (DAKKA_cameraY * 10)];
				_target setDir _targetDir;
				_target setPos _targetPos;
				// _coords = [_target, _camDist * 2, _angle] call BIS_fnc_relPos;
                _coords = _target getPos [_camDist * 2, _angle];
				_coords set [2, _camDist - (DAKKA_cameraY * 30)];
				_camera camPreparePos _coords;
				_camera camPrepareFOV DAKKA_cameraZoom;
				_camera camCommitPrepared 0.05;
				_angle = _angle - (DAKKA_cameraX * 50);
				DAKKA_cameraX = 0;
			};
			case "top";
			default {
				_target setPos _targetPos;
				_camera camPrepareRelPos [0 + (DAKKA_cameraX * 10), 0 - (DAKKA_cameraY * 10), _camDist * 3];
				_camera camPrepareFOV DAKKA_cameraZoom;
				_camera camCommitPrepared 0.05;
			};
		};
	};
};

deleteVehicle _target;