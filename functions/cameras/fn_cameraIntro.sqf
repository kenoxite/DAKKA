#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Initiates the intro camera. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/
params [["_target", [], [[]]]];
private ["_camera", "_pos", "_dir", "_landPos"];
cutText ["Loading preview...", "BLACK IN", 999];
// 0 fadeSound 0;
enableRadio false;
call DMORBAT_fnc_cameraIntroTerminate;
waitUntil { isNull DMORBAT_previewCamera };
showCinemaBorder false; 

if (count _target == 0) then {
    _target = [worldSize / 2, worldSize / 2, 0]; // world center
    if (surfaceIsWater _target) then {
        _landPos = [_target, 0, 2000,  0, 0] call BIS_fnc_findSafePos;
        if (count _landPos == 2) then {
            _target = _landPos;
        };
    };
    // _pos = [(random 500) + (random (worldSize)), (random 500) + (random (worldsize)), 30];
    _pos = [_target, 100 + (random 5000), random 360] call BIS_fnc_relPos;
    if (surfaceIsWater _pos) then {
        _landPos = [_pos, 0, 2000,  0, 0] call BIS_fnc_findSafePos;
        if (count _landPos == 2) then {
            _pos = _landPos;
        };
    };
} else {
    _pos = [_target, 800, random 360] call BIS_fnc_relPos;
    // Make a copy so modifying the passed position doesn't modify the original (which in this case is the global variable for the task location)
    _target = +_target;
};
_pos set [2, (getTerrainHeightASL _pos) + 40];
_camera = "camera" camCreate _pos;
DMORBAT_cameraIntro = _camera;
_target set [2, (getTerrainHeightASL _target) + 20];
DMORBAT_cameraIntroPlaying = true;

_camera camsettarget _target;
_camera camSetFov 0.3;
// _camera camSetFocus [-1, -1];
_camera camSetFocus [10, 1];
_camera cameraeffect ["INTERNAL", "BACK"];
_camera camCommit 0;

if ([DMORBAT_customDate] call DMORBAT_fnc_isNight) then { camUseNVG true; } else { camUseNVG false; };

cutText ["", "BLACK IN"];
