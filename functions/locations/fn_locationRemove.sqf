#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Removes the currently selected location 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_locations", "_mrkr", "_coords", "_index", "_indexCat"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idcCombo);

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;

_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;
_index = lbCurSel _ctrl;
_locations deleteAt _index;

[_idcCombo] call DAKKA_fnc_updateLocationsCombo;
_ctrl lbSetCurSel (_index max ((count _locations) - 1));

if ((count _locations) == 0) then {
    ctrlEnable [IDC_BT_AO_SEL_SET, false];
    ctrlEnable [IDC_BT_AO_SEL_REMOVE, false];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_LEFT, false];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_RIGHT, false];
};
[IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, _idcCombo] call DAKKA_fnc_mapDisplayLocations;

// Save task settings
call DAKKA_fnc_settingsSave;

true