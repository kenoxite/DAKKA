#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Places the currently selected composition 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idc"];
private ["_display", "_ctrl", "_pos", "_selectionPath", "_category", "_subCategory", "_composition", "_taskData", "_compArr", "_worldCompositionsData", "_compositionsData", "_compName", "_mrkr", "_ref", "_dir"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idc);

_pos = getMarkerPos "DMORBAT_mrkr_MapCenter";
_selectionPath = tvCurSel _ctrl;
if ((count _selectionPath) < 3) exitWith { ["ERROR: No composition was selected!"] spawn DMORBAT_fnc_displayMessage; };
_category = _ctrl tvData (_selectionPath select [0, 1]);
_subCategory = _ctrl tvData (_selectionPath select [0, 2]);
_composition = _ctrl tvData _selectionPath;
// systemChat format ["DMORBAT: compositionPlace _pos: %5, _selectionPath: %1, _category: %2, subcategory: %3, composition: %4", _selectionPath, _category, _subCategory, _composition, _pos];
_compArr = [_pos, 0, _category, _subCategory, _composition, true, false] call DMORBAT_fnc_compositionSpawn;

// Update task array
_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

// _compName = format ["Composition %1", (count _compositionsData) + 1];
_compName = _ctrl tvText _selectionPath;
_compositionsData pushBack [_compName, _compArr select 0, _compArr select 1];

[IDC_TREE_GRP1] call DMORBAT_fnc_updatePlacedCompositionsTreeList;

// Update markers
call DMORBAT_fnc_mapDisplayCompositions;

// Save task settings
call DMORBAT_fnc_settingsSave;

true