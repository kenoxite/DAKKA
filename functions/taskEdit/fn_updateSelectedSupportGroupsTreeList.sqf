#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the tree list displaying the selected support groups. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

// diag_log format ["DMORBAT: updateCustomGroupsTreeList params:%1 %2 %3", _idc, _groupNumber, _enemy];
private ["_ctrl", "_indexCtrl", "_taskData", "_groupsData", "_thisCategoryData", "_thisCategoryName", "_thisCategoryGroups", "_thisGroupData", "_groupName", "_unitsData", "_unitClass", "_unitName", "_rank", "_rankImg", "_faction", "_factionName", "_unitNameFull", "_tooltip", "_txt", "_presence", "_skill", "_thisUnitData", "_lodaout", "_groupMods", "_ctrlGrpIndex", "_ctrlUnitIndex"];

_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_TREE_GRP1;
tvClear _ctrl;

_supportGroup = lbCurSel IDC_COMBO_SUPPORT_TYPES;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs; 
_groupsCategoryData = _groupsData select _supportGroup; 
_thisCategoryName = _groupsCategoryData select 0;
_thisCategoryData = _groupsCategoryData select 1;
_thisCategoryGroups = _thisCategoryData select 1; 
// diag_log format ["DMORBAT: updateCustomGroupsTreeList _groupNumber: %2 _thisCategoryName: %3 _thisCategoryGroups:%1", _thisCategoryGroups, _groupNumber, _thisCategoryName];

// Handle to add units and groups to the category
_ctrlGrpIndex = _ctrl tvAdd [[], format ["<Add unit to %1>", _thisCategoryName]];
 _tooltip = "Click this to create a new support group with the selected unit";
_ctrl tvSetTooltip [[_ctrlGrpIndex], _tooltip];
if (count _thisCategoryGroups > 0) then {
    // Add groups
    for [{private _i = 1}, {_i <= count _thisCategoryGroups}, {_i = _i + 1}] do
    {
        _thisGroupData = _thisCategoryGroups select (_i - 1);
        _groupName = _thisGroupData select 0;
        _unitsData = _thisGroupData select 1;
        _groupMods = _thisGroupData select 2;
        // diag_log format ["DMORBAT: updateCustomGroupsTreeList _groupName:%1", _groupName];
        _ctrlGrpIndex = _ctrl tvAdd [[], _groupName];
            _txt = if (_i > 0) then {
            format ["%1 (Group %2) ", _groupName, _i];
        } else {
            format ["%1", _groupName];
        };
        _ctrl tvSetText [[_ctrlGrpIndex], _txt];
        _ctrl tvSetData [[_ctrlGrpIndex], format ["%1_%2", _groupName, _i]];
        // _ctrl tvExpand [_i];
        _tooltip = format ["%1\n\nClick to preview and set this group as the target when adding support units", _groupName];
        // Mod dependencies
        _knownMods =+ [DMORBAT_settings, "Known mods"] call BIS_fnc_getFromPairs;
        if (count _groupMods > 0) then {
            private _noMods = true;
          {
            _mod = (modParams [_knownMods select _x, ["name"]]) select 0;
            if (isNil "_mod") then { _mod = _knownMods select _x };
            if (isNil "_mod") then { _mod = _knownMods select 0 };
            if (_mod != "") then {
                if (_noMods) then{
                    _tooltip = format ["%1\nGroup dependencies:\n", _tooltip];
                    _noMods = false;
                };
                _tooltip = format ["%1%2%3", _tooltip, if (_forEachIndex > 0) then {", "} else {""}, _mod];
            };
          } forEach _groupMods;
        };
        _ctrl tvSetTooltip [[_ctrlGrpIndex], _tooltip];

        for [{private _j = 0}, {_j < count _unitsData}, {_j = _j + 1}] do
        {
            _thisUnitData = _unitsData select _j;
            _unitClass = _thisUnitData select 0;
            _lodaout = _thisUnitData select 2;
            _presence = _thisUnitData select 3;
            _skill = _thisUnitData select 4;
            _unitName = getText (configFile >> "CfgVehicles" >> _unitClass >> "displayname");
            _faction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");
            _factionName = getText (configFile >> "CfgFactionClasses" >> _faction >> "displayName");
            _isMan = [_unitClass] call DMORBAT_fnc_isMan;
            _unitNameFull = format ["%1. %2 [%3]", _j + 1, _unitName, _factionName];
            // _rank = if (_j == 0) then { "SERGEANT" } else { "PRIVATE" };
            _rank = (_unitsData select _j) select 1;
            _rankImg = [_rank, "texture"] call BIS_fnc_rankParams;
            
            _ctrlUnitIndex = _ctrl tvAdd [[_ctrlGrpIndex], _unitName];
            _ctrl tvSetText [[_ctrlGrpIndex, _ctrlUnitIndex], _unitNameFull];
            _ctrl tvSetData [[_ctrlGrpIndex, _ctrlUnitIndex], _unitClass];
            _ctrl tvSetPicture [[_ctrlGrpIndex, _ctrlUnitIndex], _rankImg];
            // _tooltip = format ["Click to highlight in preview panel\n%1", _unitClass];
            // if (_j == 0) then { _tooltip = format ["GROUP LEADER\n%1", _tooltip] };
            _ctrl tvSetTooltip [[_ctrlGrpIndex, _ctrlUnitIndex], [format ["%1 [%2]", _unitName, _factionName], _unitClass, _j, count _lodaout, _presence, _skill, _groupMods] call DMORBAT_fnc_createUnitTooltip];
            // diag_log format ["DMORBAT: updateCustomGroupsTreeList _unitName:%1", _unitName];
        };
    };
};