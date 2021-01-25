#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Rotate the currently selected location. 


  Parameter (s):
  _this select 0: _idc


  Returns:


  Examples:

*/

params [["_idcCombo", -1], ["_right", true]];
private ["_display", "_ctrl", "_index", "_pos", "_dir", "_dirMod", "_indexCat", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_locations", "_thisLocationData", "_mrkr"];
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idcCombo;
_index = lbCurSel _ctrl;
// systemChat format ["DMBORBAT: locationRotate _index: %1", _index];

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;

_thisLocationData = _locations select _index;
_pos = _thisLocationData select 0;
_dir = _thisLocationData select 1;
_dirMod = 5;

if (_right) then {
  if ((_dir + _dirMod) < 360) then {
   _dir = _dir + _dirMod;
  } else {
    _dir = 0;
  };
} else {
  if ((_dir - _dirMod) > 0) then {
   _dir = _dir - _dirMod;
  } else {
    _dir = 360;
  };
};
// Update location array
_thisLocationData set [1, _dir];
copyToClipboard str ([_pos, _dir]);
// Update position of reference object
(DMORBAT_locationPreview select (_index + 1)) setDir _dir;

// Rotate additional markers
if (DMORBAT_Task == 2) then {
  // Contested area
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area", DMORBAT_Task, _index + 1];
  _mrkr setMarkerDir _dir;
  // Friendly spawn
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly", DMORBAT_Task, _index + 1];
  _mrkr setMarkerDir _dir;
  _mrkr setMarkerPos ([_pos, -500, _dir] call BIS_fnc_relPos);
  // Friendly spawn Text
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly_txt", DMORBAT_Task, _index + 1];
  _mrkr setMarkerDir _dir;
  _mrkr setMarkerPos ([_pos, -500, _dir] call BIS_fnc_relPos);
  // Enemy spawn
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy", DMORBAT_Task, _index + 1];
  _mrkr setMarkerDir _dir;
  _mrkr setMarkerPos ([_pos, 500, _dir] call BIS_fnc_relPos);
  // Enemy spawn Text
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy_txt", DMORBAT_Task, _index + 1];
  _mrkr setMarkerDir _dir;
  _mrkr setMarkerPos ([_pos, 500, _dir] call BIS_fnc_relPos);
};


// Update location marker
[IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, _idcCombo] call DMORBAT_fnc_mapDisplayLocations;

// Save task settings
call DMORBAT_fnc_settingsSave;


true