#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Adds the map coordinates as a new location 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_indexCat", "_categoryLocations", "_coords", "_index"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idcCombo);

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_categoryLocations = _categoryData select 1;
_coords = getMarkerPos "DAKKA_mrkr_MapCenter";
_categoryLocations pushBack [_coords, 0];
copyToClipboard str ([_coords, 0]);

[_idcCombo] call DAKKA_fnc_updateLocationsCombo;
[IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, _idcCombo] call DAKKA_fnc_mapDisplayLocations;
_ctrl lbSetCurSel (count _categoryLocations);

ctrlEnable [IDC_BT_AO_SEL_SET, true];
ctrlEnable [IDC_BT_AO_SEL_REMOVE, true];

// Save task settings
call DAKKA_fnc_settingsSave;

true