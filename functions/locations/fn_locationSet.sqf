#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the map coordinates as the ones for the selected location 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_locations", "_thisLocationData", "_coords", "_index", "_indexCat", "_mrkr", "_pos", "_dir"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idcCombo);

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;
_index = lbCurSel _ctrl;
_thisLocationData = _locations select _index;
_pos = getMarkerPos "DMORBAT_mrkr_MapCenter";
_thisLocationData set [0, _pos];
_dir = _thisLocationData select 1;
copyToClipboard str ([_pos, _dir]);

// Update position of reference object
(DMORBAT_locationPreview select (_index + 1)) setPos _pos;

// Rotate additional markers
if (DMORBAT_Task == 2) then {
  // Contested area
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area", DMORBAT_Task, _index + 1];
  _mrkr setMarkerPos _pos;
  _mrkr setMarkerDir _dir;
  // Friendly spawn
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly", DMORBAT_Task, _index + 1];
  _mrkr setMarkerPos ([_pos, -500, _dir] call BIS_fnc_relPos);
  _mrkr setMarkerDir _dir;
  // Friendly spawn Text
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly_txt", DMORBAT_Task, _index + 1];
  _mrkr setMarkerPos ([_pos, -500, _dir] call BIS_fnc_relPos);
  _mrkr setMarkerDir _dir;
  // Enemy spawn
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy", DMORBAT_Task, _index + 1];
  _mrkr setMarkerPos ([_pos, 500, _dir] call BIS_fnc_relPos);
  _mrkr setMarkerDir _dir;
  // Enemy spawn Text
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy_txt", DMORBAT_Task, _index + 1];
  _mrkr setMarkerPos ([_pos, -500, _dir] call BIS_fnc_relPos);
  _mrkr setMarkerDir _dir;
};

[IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, _idcCombo] call DMORBAT_fnc_mapDisplayLocations;

// Save task settings
call DMORBAT_fnc_settingsSave;

true