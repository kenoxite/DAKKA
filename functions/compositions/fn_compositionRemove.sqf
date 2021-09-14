#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Removes the currently selected composition 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params [["_all", false]];
private ["_display", "_ctrl", "_selectionPath", "_taskData", "_worldCompositionsData", "_compositionsData", "_index", "_thisCompositionData", "_compObjects", "_obj", "_itemPos", "_hiddenObjects", "_hideDist", "_mrkr", "_txt", "_ref", "_pos", "_dir", "_compsToDelete"];

DAKKA_compositionsRemoved = false;
diag_log format ["DAKKA: compositionRemove - Deleting %1 compositions...", if (_all) then {"all"} else {"some"}];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_TREE_GRP1);
_selectionPath = tvCurSel _ctrl;
if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _selectionPath: %1", _selectionPath] };
if ((count _selectionPath) < 1 && !_all) exitWith { [format ["ERROR: No composition was selected!"]] spawn DAKKA_fnc_displayMessage;; };

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _compositionsData: %1", _compositionsData] };

_index = (_selectionPath select 0);
_compsToDelete = [];
if (_all) then {
    private _compCount = _ctrl tvCount [];
    if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _compCount: %1", _compCount] };
    for [{private _i = 0}, {_i < _compCount}, {_i = _i + 1}] do
    {
        _compsToDelete pushBack _i;
    };
} else {
    _compsToDelete pushBack _index;
};
if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _compsToDelete: %1", _compsToDelete] };
{
    if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _x: %1", _x] };
    _thisCompositionData = _compositionsData select _x;
    if (isNil "_thisCompositionData") exitWith { diag_log format ["DAKKA: compositionRemove --- ERROR --- No composition data found!"]; false };
    if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _thisCompositionData: %1", _thisCompositionData] };
    if (_all) then {
        _compObjects = +_thisCompositionData select 1;
    } else {
        _compObjects = _thisCompositionData select 1;
    };
    if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove _compObjects: %1", _compObjects] };
    // Delete the first element, which is the reference object
    deletevehicle ((_compObjects select 0) select 0);
    _compObjects deleteAt 0;
    // Retrieve and delete the hidden terrain objects list
    _hiddenObjects = +_thisCompositionData select 2;
    _thisCompositionData deleteAt 2;

    // Now delete the rest
    {
        if (DAKKA_debug) then { diag_log format ["DAKKA: compositionRemove deleting object: %1", _x select 0] };
    	deleteVehicle (_x select 0);
    } forEach _compObjects;

    // Show hidden terrain objects
    if (!isNil "_hiddenObjects") then {
        {
          _x hideObject false;
        } forEach _hiddenObjects;
    };
} forEach _compsToDelete;

// Allow loading compositions next time
if (_all) then {
    DAKKA_loadCompositions = true;
};

{
    _compositionsData deleteAt _x;
} forEach _compsToDelete;

[IDC_TREE_GRP1] call DAKKA_fnc_updatePlacedCompositionsTreeList;

// Rebuild markers
call DAKKA_fnc_mapDisplayCompositions;

// Save task settings
if (!DAKKA_automated) then {
    call DAKKA_fnc_settingsSave;
};

diag_log format ["DAKKA: compositionRemove - %1 compositions deleted!", if (_all) then {"All"} else {"Some"}];

DAKKA_compositionsRemoved = true;

true