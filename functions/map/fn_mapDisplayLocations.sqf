#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Displayes the AO locations on the map. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcTerrain", "_idcSatellite", ["_idcCombo", -1]];
private ["_display", "_ctrl", "_worldLocationsData", "_locationsData", "_categoryData", "_locations", "_markers", "_mrkr", "_txt", "_mrkrToMove", "_indexCat", "_pos", "_dir", "_pos1"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;
diag_log format ["DMORBAT: mapDisplayLocations _locations: %1", _locations];

_markers = [];

// Reset markers
 call DMORBAT_fnc_deleteTaskMarkers;
 
if (count _locations == 0) exitWith { false };

// Create markers
// "|MARKERNAME|markerPos|markerType|markerShape|markerSize|markerDir|markerBrush|markerColor|markerAlpha|markerText"
{
  _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2", DMORBAT_Task, _forEachIndex + 1];
  _pos = _x select 0;
  _dir = _x select 1;
  if (isNil _mrkr) then {
    _txt = format ["Location %1", _forEachIndex + 1];
    // [_x select 0, [1, 1], "ColorEAST", "b_hq", _txt, 1, [_mrkr]] call BIS_fnc_markerCreate;
    // _mrkr setMarkerDir (_x select 1); 
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos, "Select", "ICON", [1, 1], _dir, "Solid", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
  } else {
    _mrkr setMarkerPos (_x select 0);
    _mrkr setMarkerDir (_x select 1);
    _mrkr setMarkerText format ["Location %1", _forEachIndex + 1];
  };
  _markers pushBack _mrkr;

  // Create aditional markers
  if (DMORBAT_Task == 2) then {
    // Contested area
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area", DMORBAT_Task, _forEachIndex + 1];
    _pos1 = _pos;
    _txt = "Contested Area";
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos1, "empty", "RECTANGLE", [500, 250], _dir, "FDiagonal", "ColorEAST", 0.8, _txt] call BIS_fnc_stringToMarker;
    // Friendly spawn
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly", DMORBAT_Task, _forEachIndex + 1];
    _pos1 = [_pos, -500, _dir] call BIS_fnc_relPos;
    _txt = "Friendly Spawn Area";
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos1, "empty", "RECTANGLE", [500, 500], _dir, "Border", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
    // Friendly spawn Text
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly_txt", DMORBAT_Task, _forEachIndex + 1];
    _pos1 = [_pos, -500, _dir] call BIS_fnc_relPos;
    _txt = "Friendly Spawn Area";
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos1, "hd_dot", "ICON", [1, 1], _dir, "Solid", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
    // Enemy spawn
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy", DMORBAT_Task, _forEachIndex + 1];
    _pos1 = [_pos, 500, _dir] call BIS_fnc_relPos;
    _txt = "Enemy Spawn Area";
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos1, "empty", "RECTANGLE", [500, 500], _dir, "Border", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
    // Enemy spawn Text
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy_txt", DMORBAT_Task, _forEachIndex + 1];
    _pos1 = [_pos, 500, _dir] call BIS_fnc_relPos;
    _txt = "Enemy Spawn Area";
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkr, _pos1, "hd_dot", "ICON", [1, 1], _dir, "Solid", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
  };
} forEach _locations;

diag_log format ["DMORBAT: mapDisplayLocations _markers: %1", _markers];
if (count _locations > 0) then {
  _mrkrToMove = if (_idcCombo >= 0) then {
    _markers select (lbCurSel _idcCombo) max 0;
  } else {
    _markers select 0;
  };
  [_idcTerrain, _idcSatellite, _mrkrToMove] call DMORBAT_fnc_moveToCtrlMapMarker;
};

true