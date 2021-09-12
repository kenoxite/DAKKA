#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Prepares the array of unit classes and rank *from the default faction groups* to display the group in the preview panel.


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_selectionPath", "_faction"];
private ["_factionGroups", "_groupTypeName", "_groupTypeIndex", "_groupType", "_groupsData", "_groupName", "_groupIndex", "_thisGroupData", "_unitsData", "_thisUnitData", "_unitClasses", "_ranks", "_unitClass", "_rank"];

// if (DAKKA_debug) then { diag_log format ["DAKKA: updateFactionGroupUnitsList params:%1 %2", _selectionPath, _faction] };
_factionGroups = [_faction] call DAKKA_fnc_extractFactionGroupsData;

call DAKKA_fnc_previewGroupDelete;

_selectionPath resize 2;
_groupTypeName = tvData [IDC_TREE_FACTION_GROUPS, [_selectionPath select 0]];
_groupTypeIndex = [_factionGroups, _groupTypeName] call DAKKA_fnc_findFirstNested;
if (_groupTypeIndex >= 0) then {
	_groupType = _factionGroups select _groupTypeIndex;
    _groupsData = _groupType select 1;
	_groupName = tvData [IDC_TREE_FACTION_GROUPS, _selectionPath];
	_groupIndex = [_groupsData, _groupName] call DAKKA_fnc_findFirstNested;
	if (_groupIndex >= 0) then {
		_thisGroupData = _groupsData select _groupIndex;
        _unitsData = _thisGroupData select 1;
		_unitClasses = [];
		_ranks = [];
		for [{private _i = 0}, {_i < count _unitsData}, {_i = _i + 1}] do
		{
			_thisUnitData = _unitsData select _i;
			_unitClass = _thisUnitData select 0;
			_rank = _thisUnitData select 1;
			_unitClasses pushBack _unitClass;
			_ranks pushBack _rank;
		};
		[_unitClasses, _ranks] call DAKKA_fnc_previewGroup;
	};
};

true