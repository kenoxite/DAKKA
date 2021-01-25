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

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_TREE_GRP1);
_selectionPath = tvCurSel _ctrl;
diag_log format ["DMORBAT: compositionRemove _selectionPath: %1", _selectionPath];
if ((count _selectionPath) < 1 && !_all) exitWith { [format ["ERROR: No composition was selected!"]] spawn DMORBAT_fnc_displayMessage;; };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
diag_log format ["DMORBAT: compositionRemove _compositionsData: %1", _compositionsData];

_index = (_selectionPath select 0);
_compsToDelete = [];
if (_all) then {
    private _compCount = _ctrl tvCount [];
    diag_log format ["DMORBAT: compositionRemove _compCount: %1", _compCount];
    for [{private _i = 0}, {_i < _compCount}, {_i = _i + 1}] do
    {
        _compsToDelete pushBack _i;
    };
} else {
    _compsToDelete pushBack _index;
};
diag_log format ["DMORBAT: compositionRemove _compsToDelete: %1", _compsToDelete];
{
    diag_log format ["DMORBAT: compositionRemove _x: %1", _x];
    _thisCompositionData = _compositionsData select _x;
    diag_log format ["DMORBAT: compositionRemove _thisCompositionData: %1", _thisCompositionData];
    if (isNil "_thisCompositionData") exitWith { false };
    if (_all) then {
        _compObjects =+ _thisCompositionData select 1;
    } else {
        _compObjects = _thisCompositionData select 1;
    };
    diag_log format ["DMORBAT: compositionRemove _compObjects: %1", _compObjects];
    // Delete the first element, which is the reference object
    deletevehicle ((_compObjects select 0) select 0);
    _compObjects deleteAt 0;
    // Retrieve and delete the hidden terrain objects list
    _hiddenObjects =+ _thisCompositionData select 2;
    _thisCompositionData deleteAt 2;

    // Now delete the rest
    {
    	deleteVehicle (_x select 0);
    	diag_log format ["DMORBAT: compositionRemove deleting object: %1", _x select 0];
    } forEach _compObjects;

    // Show hidden terrain objects
    {
      _x hideObject false;
    } forEach _hiddenObjects;
} forEach _compsToDelete;

// Delete composition array
if (!_all) then {
    _compositionsData deleteAt _index;
};

[IDC_TREE_GRP1] call DMORBAT_fnc_updatePlacedCompositionsTreeList;

// Rebuild markers
call DMORBAT_fnc_mapDisplayCompositions;

// Save task settings
call DMORBAT_fnc_settingsSave;

true