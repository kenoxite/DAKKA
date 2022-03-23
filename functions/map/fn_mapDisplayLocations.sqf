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
private ["_display", "_ctrl", "_worldLocationsData", "_locationsData", "_categoryData", "_locations", "_markers", "_mrkr", "_mrkrName", "_txt", "_mrkrToMove", "_indexCat", "_pos", "_dir", "_pos1"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;
if (DAKKA_debug) then { diag_log format ["DAKKA: mapDisplayLocations _locations: %1", _locations] };

_markers = [];

// Reset markers
call DAKKA_fnc_deleteTaskMarkers;
 
if (count _locations == 0) exitWith { if (DAKKA_debug) then { diag_log "DAKKA: mapDisplayLocations - EXIT FUNCTION - No locations found!" }; false };

// Create markers
// "|MARKERNAME|markerPos|markerType|markerShape|markerSize|markerDir|markerBrush|markerColor|markerAlpha|markerText"
_mrkr = "";
for [{_i = 0}, {_i < (count _locations)}, {_i = _i + 1}] do
{
    private _location = _locations select _i;
    _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2", DAKKA_Task, _i + 1];
    _pos = _location select 0;
    _dir = _location select 1;
    _txt = format ["Location %1", _i + 1];
    _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos, "Select", "ICON", [1, 1], _dir, "Solid", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
    _markers pushBack _mrkr;

    // Create aditional markers
    if (DAKKA_Task == 2) then {
        // Contested area
        _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2_area", DAKKA_Task, _i + 1];
        _pos1 = _pos;
        _txt = "Contested Area";
        _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos1, "empty", "RECTANGLE", [500, 250], _dir, "FDiagonal", "ColorEAST", 0.8, _txt] call BIS_fnc_stringToMarker;
        // Friendly spawn
        _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2_area_friendly", DAKKA_Task, _i + 1];
        _pos1 = _pos getPos [-500, _dir];
        _txt = "Friendly Spawn Area";
        _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos1, "empty", "RECTANGLE", [500, 500], _dir, "Border", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
        // Friendly spawn Text
        _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2_area_friendly_txt", DAKKA_Task, _i + 1];
        _pos1 = _pos getPos [-500, _dir];
        _txt = "Friendly Spawn Area";
        _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos1, "hd_dot", "ICON", [1, 1], _dir, "Solid", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
        // Enemy spawn
        _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2_area_enemy", DAKKA_Task, _i + 1];
        _pos1 = _pos getPos [500, _dir];
        _txt = "Enemy Spawn Area";
        _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos1, "empty", "RECTANGLE", [500, 500], _dir, "Border", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
        // Enemy spawn Text
        _mrkrName = format ["DAKKA_mrkr_Task%1_location_%2_area_enemy_txt", DAKKA_Task, _i + 1];
        _pos1 = _pos getPos [500, _dir];
        _txt = "Enemy Spawn Area";
        _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", _mrkrName, _pos1, "hd_dot", "ICON", [1, 1], _dir, "Solid", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
    };
};

if (DAKKA_debug) then { diag_log format ["DAKKA: mapDisplayLocations _markers: %1", _markers] };
if (count _locations > 0) then {
    _mrkrToMove = _markers select (lbCurSel _idcCombo) max 0;
    [_idcTerrain, _idcSatellite, _mrkrToMove] call DAKKA_fnc_moveToCtrlMapMarker;
};

true