#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Manual control of various settings of the preview camera. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_action", "_EHvalue"];

if (_action == "scrollwheel") then {
    // systemChat format ["scrollwheel params: %1", _EHvalue];
    if ((_EHvalue select 1) > 0) then {
        _action = "ZOOMIN";
    } else {
        _action = "ZOOMOUT";
    };
};

if (_action == "leftBtnMouse") then {
    // _screenPos = getMousePosition;
    // systemChat format ["DAKKA_cameraZoom: %1", DAKKA_cameraZoom];
    // _screenPosX = (_screenPos select 0) - (DAKKA_cameraZoom);
    // _screenPosY = (_screenPos select 1) - (DAKKA_cameraZoom);
    // _adjScreenPosX = if (_screenPosX < 0.5) then {_screenPosX max 0.45} else {_screenPosX min 0.55};
    // _adjScreenPosY = if (_screenPosY < 0.5) then {_screenPosY max 0.45} else {_screenPosY min 0.55};
    // _screenPos = [_adjScreenPosX, _adjScreenPosY];
    // systemChat format ["_screenPos: %1", _screenPos];
    // DAKKA_cameraTargetPos = screenToWorld _screenPos;
};

if (_action == "rightBtnMouse") then {
    // systemChat format ["leftBtnMouse params: %1", _EHvalue];
};

if (_action == "ZOOMIN" && DAKKA_cameraZoom > 0.01) then {
	DAKKA_cameraZoom = DAKKA_cameraZoom - 0.02;
};

if (_action == "ZOOMOUT" && DAKKA_cameraZoom < 2) then {
	DAKKA_cameraZoom = DAKKA_cameraZoom + 0.02;
};

if (_action == "LEFT") then {
	DAKKA_cameraX = DAKKA_cameraX - 0.05;
};

if (_action == "RIGHT") then {
	DAKKA_cameraX = DAKKA_cameraX + 0.05;
};

if (_action == "UP") then {
	DAKKA_cameraY = DAKKA_cameraY - 0.05;
};

if (_action == "DOWN") then {
	DAKKA_cameraY = DAKKA_cameraY + 0.05;
};

true