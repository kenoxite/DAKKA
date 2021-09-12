#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Switch between Terrain and Satellite modes


  Parameter(s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params [["_idcTerrain", -1], ["_idcSatellite", -1]];
private ["_display", "_ctrl", "_scale"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idcTerrain);
if (ctrlShown _ctrl) then {
	_scale = ctrlMapScale _ctrl;
	_ctrl ctrlShow false;
	_ctrl = (_display displayCtrl _idcSatellite);
	_ctrl ctrlShow true;
	// _ctrl ctrlSetScale _scale;
	DAKKA_mapSatellite = true;
} else {
	_ctrl = (_display displayCtrl _idcSatellite);
	_scale = ctrlMapScale _ctrl;
	_ctrl ctrlShow false;
	_ctrl = (_display displayCtrl _idcTerrain);
	_ctrl ctrlShow true;
	// _ctrl ctrlSetScale _scale;
	DAKKA_mapSatellite = false;
};

true