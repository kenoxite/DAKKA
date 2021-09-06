#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the AO location combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcTerrain", "_idcSatellite", "_selectionPath", ["_idcButtons", []]];
private ["_mrkr"];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: LocationsCombo_selChanged _selectionPath:%1", _selectionPath] };
if (_selectionPath < 0) exitWith { false };

private _locData = (lbData [IDC_COMBO_AO_SELECTION_LOC, lbCurSel IDC_COMBO_AO_SELECTION_LOC]);
if (!isNil "_locData") then {
    ctrlEnable [IDC_BT_AO_SEL_SET, true];
    ctrlEnable [IDC_BT_AO_SEL_REMOVE, true];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_LEFT, true];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_RIGHT, true];
};

_mrkr = format ["DMORBAT_mrkr_Task%1_location_%2", DMORBAT_Task, _selectionPath + 1];
[_idcTerrain, _idcSatellite, _mrkr] call DMORBAT_fnc_moveToCtrlMapMarker;

if (DMORBAT_previewCameraPlaying) then {
	[_selectionPath] call DMORBAT_fnc_locationPreview;
};

true