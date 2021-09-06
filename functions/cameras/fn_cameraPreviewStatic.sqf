#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Initiates the preview camera in static mode. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/


params ["_pos", ["_dir", 180], ["_FOV", 0.7], ["_relX", 0], ["_relY", 0], ["_relZ", 0], ["_height", 0], ["_target", objNull]];
private ["_camera", "_display", "_ctrl", "_targetPos", "_relDir", "_relPos"];
showcinemaborder false; 
call DMORBAT_fnc_cameraPreviewTerminate;
if (DMORBAT_debug) then { diag_log format ["DMBORBAT: camerapreviewstatic _FOV: %1", _FOV] };
waitUntil { isNull DMORBAT_previewCamera };
// Disable ambient fauna
enableEnvironment [false, true];
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
_ctrl ctrlShow true;
DMORBAT_cameraZoom = _FOV;
DMORBAT_previewCamera = "camera" camCreate [0, 0, 0];
_camera = DMORBAT_previewCamera;
DMORBAT_previewCameraPlaying = true;
if (DMORBAT_debug) then { diag_log format ["DMBORBAT: camerapreviewstatic _pos: %1", _pos] };

// private _relX = 0.5;
// private _relY = 12;
// private _relZ = 0.5;
// private _height = 2;
// private _FOV = 0.35;

_camera cameraEffect ["INTERNAL", "BACK"];
if (DMORBAT_debug) then { diag_log format ["DMBORBAT: camerapreviewstatic _target: %1", _target] };
if (!isNull _target) then { 
	_pos = _target getRelPos [_relY, getDir _target];
	_relDir = ((getPosATL _target) vectorFromTo _pos);
	_targetPos = getPosATL _target;
	_camera camSetTarget [(_targetPos select 0) - _relX, _targetPos select 1, (_targetPos select 2) + _height];
    _relPos = [0, -_relY, _relZ];
	_camera camSetRelPos _relPos;
} else {
    _targetPos = [(_pos select 0) - _relX, _pos select 1, _height];
	_camera camSetTarget _targetPos;
    _relPos = [0, -_relY, _relZ];
    _camera camSetRelPos _relPos;
};
DMORBAT_cameraTargetPos = _targetPos;
DMORBAT_cameraRelPos = _relPos;
_camera camPrepareFOV DMORBAT_cameraZoom;
_camera camSetFocus [-1, -1];
_camera camCommit 0.1;	

cameraEffectEnableHUD true;
cutText ["", "BLACK IN", 2];


while { DMORBAT_previewCameraPlaying && !isNull _camera } do {
	waitUntil { camCommitted _camera || !(DMORBAT_previewCameraPlaying)};
	if(!isNull _camera && DMORBAT_previewCameraPlaying) then {
		_camera camPrepareFOV DMORBAT_cameraZoom;
        // _camera camSetRelPos DMORBAT_cameraRelPos;
		_camera camSetTarget [(DMORBAT_cameraTargetPos select 0) - (_relX - DMORBAT_cameraX), DMORBAT_cameraTargetPos select 1, (DMORBAT_cameraTargetPos select 2) + (_height - DMORBAT_cameraY)];
		// _camera camSetPos [(_pos select 0) + DMORBAT_cameraX, (_pos select 1) + DMORBAT_cameraY, (_pos select 2)];
		_camera camCommitPrepared 0.05;
	};
};