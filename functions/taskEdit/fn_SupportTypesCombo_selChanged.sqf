#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of factions combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_selectionPath"];
private ["_display", "_ctrl", "_supportType", "_taskData", "_groupsData", "_catIndex", "_groupsCategoryData", "_thisCategoryData", "_supportLimit"];
diag_log format ["DMORBAT: supportTypesCombo_selChanged _selectionPath: %1", _selectionPath];
if (_selectionPath < 0) exitWith { false };

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl IDC_COMBO_SUPPORT_TYPES;
_supportType = _ctrl lbData _selectionPath;

_ctrl = _display displayCtrl IDC_TREE_SUPPORT_UNITS;
[IDC_TREE_SUPPORT_UNITS, lbData [IDC_COMBO_SUPPORT_FACTIONS, lbCurSel IDC_COMBO_SUPPORT_FACTIONS], _supportType] call DMORBAT_fnc_updateUnitsTreeList;
_ctrl tvSetCurSel [0, 0];

_ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
_ctrl ctrlSetText format ["%1 GROUPS", toUpper (_supportType)];

[IDC_TREE_GRP1] call DMORBAT_fnc_updateSelectedSupportGroupsTreeList;

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
if ((_ctrl tvCount []) > 1) then {
    _ctrl tvSetCurSel [1];
} else {
    _ctrl tvSetCurSel [0];
};


_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;
_catIndex = [_groupsData, _supportType] call BIS_fnc_findInPairs;
if (_catIndex < 0) exitWith { diag_log format ["DMORBAT: supportTypesCombo_selChanged Suppport type ""%1"" not found!", _supportType]; false };
_groupsCategoryData = _groupsData select _catIndex; 
_thisCategoryData = _groupsCategoryData select 1;
_supportLimit = (_thisCategoryData select 0) select 0;

diag_log format ["DMORBAT: supportTypesCombo_selChanged _supportLimit: %1", _supportLimit];

_ctrl = _display displayCtrl IDC_TITLE_SUPPORT_LIMIT;
_ctrl ctrlSetText format ["%1 Request Limit", _supportType];

_ctrl = _display displayCtrl IDC_EDIT_SUPPORT_LIMIT;
_ctrl ctrlSetText (str _supportLimit);

if (_supportLimit < 0) then {
    _ctrl = (_display displayCtrl IDC_EDIT_SUPPORT_LIMIT);
    _ctrl ctrlEnable false;
    _ctrl = (_display displayCtrl IDC_BT_SUPPORT_LIMIT);
    _ctrl ctrlEnable false;
    _ctrl = (_display displayCtrl IDC_CHK_SUPPORT_LIMIT);
    _ctrl cbSetChecked true;
} else {
    _ctrl = (_display displayCtrl IDC_EDIT_SUPPORT_LIMIT);
    _ctrl ctrlEnable true;
    _ctrl = (_display displayCtrl IDC_BT_SUPPORT_LIMIT);
    _ctrl ctrlEnable true;
    _ctrl = (_display displayCtrl IDC_CHK_SUPPORT_LIMIT);
    _ctrl cbSetChecked false;
};


true