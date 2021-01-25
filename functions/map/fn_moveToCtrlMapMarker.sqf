#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Centers the map on a marker


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params [["_idcTerrain", -1], ["_idcSatellite", -1], ["_mrkr", ""]];
private ["_display", "_ctrl", "_mrkr"];
diag_log format ["DMORBAT: moveToCtrlMapMarker _mrkr: %1", _mrkr];
if (_idcTerrain < 0 || _idcSatellite < 0 || _mrkr == "") exitWith { false };

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;

_ctrl = _display displayCtrl _idcTerrain;
_ctrl ctrlMapAnimAdd [0.1, ctrlMapScale _ctrl, markerPos _mrkr];
ctrlMapAnimCommit _ctrl;

_ctrl = _display displayCtrl _idcSatellite;
_ctrl ctrlMapAnimAdd [0.1, ctrlMapScale _ctrl, markerPos _mrkr];
ctrlMapAnimCommit _ctrl;

// Move map center marker
"DMORBAT_mrkr_MapCenter" setMarkerPos (markerPos _mrkr);

// Reset previous marker
if (DMORBAT_selectedLocMrkr != "") then { 
	DMORBAT_selectedLocMrkr setMarkerSize [1, 1];
	DMORBAT_selectedLocMrkr setMarkerDir 0;
};
// Set currently selected marker
DMORBAT_selectedLocMrkr = _mrkr;

true