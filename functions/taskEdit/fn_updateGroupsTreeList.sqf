#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the tree list displaying the groups of the selected faction. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _faction
  _this select 2: _showUnits
 

  Returns:


  Examples:

*/

params ["_idc", "_faction", ["_showUnits", true]];
private ["_ctrl", "_factionGroups", "_groupTypeData", "_groupTypeName", "_groupsData", "_thisGroupData", "_unitsData", "_thisUnitData", "_unitClass", "_rank", "_unitName", "_rankImg", "_tooltip", "_groupTypeIndex", "_groupIndex", "_unitIndex"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc;
tvClear _ctrl;	
// diag_log format ["DMORBAT: updateGroupsTreeList _faction: %1", _faction];

_factionGroups = [_faction] call DMORBAT_fnc_extractGroupsData;
/*{
    diag_log format ["DMORBAT: updateGroupsTreeList %1: data: %2", _forEachIndex, _x];
} forEach _factionGroups;*/

for [{private _i = 0}, {_i < count _factionGroups}, {_i = _i + 1}] do
{
	_groupTypeData = _factionGroups select _i;
    _groupTypeName = _groupTypeData select 0;
    _groupsData = _groupTypeData select 1;
	_groupTypeIndex = _ctrl tvAdd [[], _groupTypeName];
	_ctrl tvSetData [[_groupTypeIndex], _groupTypeName];
	if (_i == 0) then { _ctrl tvExpand [_groupTypeIndex] };
	for [{private _j = 0}, {_j < count _groupsData}, {_j = _j + 1}] do 
	{
        _thisGroupData = _groupsData select _j;
		_groupName = _thisGroupData select 0;
        _groupIndex = _ctrl tvAdd [[_i], _groupName];
		_ctrl tvSetData [[_groupTypeIndex, _groupIndex], _groupName];
        _tooltip = format ["%1\n\nClick to preview.\nExpand to view the group's units", _groupName];
		_ctrl tvSetTooltip [[_groupTypeIndex, _groupIndex], _tooltip];
		if (_showUnits) then {
			_unitsData = _thisGroupData select 1;
			for [{private _k = 0}, {_k < count _unitsData}, {_k = _k + 1}] do 
			{
                _thisUnitData = _unitsData select _k;
				_unitClass = _thisUnitData select 0;
				_rank = _thisUnitData select 1;
				_unitName = getText (configFile >> "CfgVehicles" >> _unitClass >> "displayname");
				_rankImg = [_rank, "texture"] call BIS_fnc_rankParams;
                _unitIndex = _ctrl tvAdd [[_groupTypeIndex, _groupIndex], _unitName];
				_ctrl tvSetData [[_groupTypeIndex, _groupIndex, _unitIndex], _unitClass];
				_ctrl tvSetPicture [[_groupTypeIndex, _groupIndex, _unitIndex], _rankImg];
				_ctrl tvSetTooltip [[_groupTypeIndex, _groupIndex, _unitIndex], format ["%1\n%2\n\nClick to highlight in preview panel", _unitName, _unitClass]];
			};
		};
	};
};

true