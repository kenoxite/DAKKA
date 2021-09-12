#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Initiates the preview camera in circling mode. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_target", ["_radius", 5], ["_altitude", 1.5], ["_speed", 0.1]];
private ["_angle", "_dir", "_coords", "_display", "_camera", "_newPos"];
// _radius = _radius; // circle radius
_angle = 180; // starting angle
// _altitude = _altitude; // camera altitude
_dir = 0; //Direction of camera movement 0: anti - clockwise, 1: clockwise
// _speed = 0.1; //lower is faster
call DAKKA_fnc_cameraPreviewTerminate;
// if (DAKKA_debug) then { diag_log format ["DAKKA: DAKKA_previewCamera:%1", DAKKA_previewCamera] };
waitUntil { isNull DAKKA_previewCamera };
// Disable ambient fauna
enableEnvironment [false, true];
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
_ctrl ctrlShow true;
_coords = [_target, _radius, _angle] call BIS_fnc_relPos;
_coords set [2, _altitude];
DAKKA_previewCamera = "camera" camCreate _coords;
_camera = DAKKA_previewCamera;
DAKKA_previewCameraPlaying = true; // set to false to stop the camera
_camera cameraEffect ["INTERNAL", "BACK"];
_camera camPrepareFOV DAKKA_cameraZoom;
_camera camSetFocus [-1, -1];
_camera camPrepareTarget _target;
_camera camCommitPrepared 0;

waitUntil { camCommitted _camera || !(DAKKA_previewCameraPlaying)};
cameraEffectEnableHUD true;
cutText ["", "BLACK IN", 2];

while { DAKKA_previewCameraPlaying && !isNull _camera } do {
	_coords = [_target, _radius, _angle] call BIS_fnc_relPos;
	_coords set [2, _altitude];

	_camera camPreparePos _coords;
	_camera camPrepareFOV DAKKA_cameraZoom;
	_camera camCommitPrepared _speed;

	// if(!camCommitted _camera && (DAKKA_previewCameraPlaying) && !isNull _camera) then {
	// 	uiSleep 0.01;
	// };
	waitUntil { camCommitted _camera || !(DAKKA_previewCameraPlaying)};
	if(!isNull _camera && DAKKA_previewCameraPlaying) then {
		_newPos = [(_target select 0) + (DAKKA_cameraX * 30), (_target select 1) + (DAKKA_cameraY * 30), 0];
		// DAKKA_cameraX = 0;
		_camera camPrepareTarget _newPos;
		_camera camPrepareFOV DAKKA_cameraZoom;
		_camera camCommitPrepared 0.05;

		_angle = if (_dir == 0) then { _angle - 1 } else { _angle + 1 };
	};
};	