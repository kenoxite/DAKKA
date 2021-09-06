#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Removes the selected unit or group from the custom group list. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _selectionPath
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath", "_idcButtons"];
private ["_taskData", "_unitsData", "_unitIndex", "_playerIndex", "_sel", "_thisGroupData", "_groupsData", "_thisCategoryData", "_thisCategoryGroups", "_groupMods", "_groupIndex"];

tvSetCurSel [IDC_TREE_SUPPORT_UNITS, [-1]];
ctrlEnable [IDC_BT_SUPPORT_UNITS_ADD, false];

if ((count _selectionPath) < 1 || ((count _selectionPath) == 1 && (_selectionPath select 0) == 0)) exitWith { ["ERROR: No unit or group was selected!"] spawn DMORBAT_fnc_displayMessage; };
tvDelete [_idc, _selectionPath];

_groupIndex = (_selectionPath select 0) - 1;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;
_supportGroup = lbCurSel IDC_COMBO_SUPPORT_TYPES;
_groupsCategoryData = _groupsData select _supportGroup; 
_thisCategoryName = _groupsCategoryData select 0;
_thisCategoryData = _groupsCategoryData select 1;
_thisCategoryGroups = _thisCategoryData select 1;
_thisGroupData = _thisCategoryGroups select _groupIndex;
if (DMORBAT_debug) then { diag_log format ["DMORBAT: removeFromGroup _thisGroupData:%1", _thisGroupData] };
_unitsData = _thisGroupData select 1;
_groupMods = _thisGroupData select 2;

if ((count _selectionPath) > 1) then {
    // Remove unit
  _unitIndex = _selectionPath select 1;
  _unitsData deleteAt _unitIndex;
  if (count _unitsData == 0) then {
    _thisCategoryGroups deleteAt _groupIndex;
    call DMORBAT_fnc_previewGroupDelete;
  } else {
    DMORBAT_PreviewGroupName = "";  
    DMORBAT_PreviewGroupID = "";  
    [_unitsData, [], _groupMods] call DMORBAT_fnc_previewGroup;
  };
} else {
    // Remove group
  _thisCategoryGroups deleteAt _groupIndex;
  call DMORBAT_fnc_previewGroupDelete;
  _unitsData = [];
};

ctrlEnable [_idcButtons select 0, false];
call DMORBAT_fnc_updateSelectedSupportGroupsTreeList;

if (DMORBAT_debug) then { diag_log format ["DMORBAT: removeFromGroup _unitsData: %1", _unitsData] };
if (count _unitsData > 0) then {
    private _tvCount = tvCount [_idc, [_selectionPath select 0]];
    _sel = [_selectionPath select 0, (_selectionPath select 1) min (_tvCount - 1)];
    tvSetCurSel [_idc, _sel];
    _ctrl tvExpand [_selectionPath select 0];
} else {
    private _tvCount = tvCount [_idc, []];
    _sel = [(_selectionPath select 0) min (_tvCount - 1)];
    tvSetCurSel [_idc, _sel];
};

if ((tvCurSel _idc) isEqualTo [0]) then {
    tvSetCurSel [IDC_TREE_SUPPORT_UNITS, [0, 0]];
};

// Save task settings
call DMORBAT_fnc_settingsSave;