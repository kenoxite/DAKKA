#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private ["_supportGroup", "_selectionPath", "_taskData", "_groupsCategoryData", "_thisCategoryGroups", "_groupsData", "_thisGroupData", "_unitsData", "_unitClass", "_index", "_display", "_ctrl", "_thisCategoryName", "_classType", "_isNew", "_groupMods", "_mod", "_knownMods", "_modIndex", "_groupIndex"];  

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;

_unitClass = tvData [IDC_TREE_SUPPORT_UNITS, tvCurSel IDC_TREE_SUPPORT_UNITS];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: supportUnitAdd _unitClass: %1", _unitClass] };
if (count _unitClass == 0) exitWith { ["ERROR: No unit was selected!"] spawn DMORBAT_fnc_displayMessage; };

_selectionPath = DMORBAT_customGroupsSelection select 1;
_groupIndex = (_selectionPath select 0) - 1;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;
_supportGroup = lbCurSel IDC_COMBO_SUPPORT_TYPES;
_groupsCategoryData = _groupsData select _supportGroup; 
_thisCategoryName = _groupsCategoryData select 0;
_thisCategoryData = _groupsCategoryData select 1;
_thisCategoryGroups = _thisCategoryData select 1;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToGroup _thisCategoryGroups: %1", _thisCategoryGroups] };

// Check for the unit mod dependencies
_mod = [_unitClass] call DMORBAT_fnc_modsCheck;

if (_groupIndex < 0 || _thisCategoryName == "Air Transport") then {
    // Add group to groups array
    _thisCategoryGroups pushBack [format ["%1", _thisCategoryName], [[_unitClass, "SERGEANT", [], 1, 2]], [_mod]];
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToGroup _thisCategoryGroups: %1", _thisCategoryGroups] };
    _groupIndex = (count _thisCategoryGroups);
    _index = 0;
} else {
    // Add group units to selected group
    _thisGroupData = _thisCategoryGroups select _groupIndex;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToGroup _groupIndex: %2 _thisGroupData: %1", _thisGroupData, _groupIndex] };
    _unitsData = _thisGroupData select 1;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToGroup _unitsData: %1", _unitsData] };

    if (_thisCategoryName == "Air Transport") then {
        // If air transport then create a new group. Tranport module doesn't work well with more than one vehicle
        _thisCategoryGroups deleteAt 0;
        _unitsData set [0, [[_unitClass, "SERGEANT", [], 1, 2]]];
    } else {
        _unitsData pushBack [_unitClass, "PRIVATE", [], 1, 2];
    };
    DMORBAT_PreviewGroupName = "";  
    DMORBAT_PreviewGroupID = "";
    _groupIndex = (_selectionPath select 0);
    _index = (count _unitsData) - 1;

    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: addUnitToGroup _unitsData: %1", _unitsData] };
    // Add the unit mod dependencies
    _groupMods = _thisGroupData select 2;
    _groupMods pushBackUnique _mod;
    _thisGroupData set [2, _groupMods];
};

call DMORBAT_fnc_updateSelectedSupportGroupsTreeList;

_ctrl = _display displayCtrl IDC_TREE_GRP1;
_ctrl tvExpand [_groupIndex];
_ctrl tvSetCurSel [_groupIndex, _index];

// Save task settings
call DMORBAT_fnc_settingsSave;