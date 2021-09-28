/*
  Author: kenoxite

  Description:
  Adds groups to task data


  Parameter (s):
  _sideType: "Friendly groups" or "Enemy groups", string
  _groupType: type of group as defined in the categorized faction groups, string
  _groupsPool: groups to be chosen from, array
  _groupsAmount: amount of groups of this type to be generated, number
  _maxUnits: amount of units to be assigned to each group, 0 to use the whole group as defined, number
  _limitPresence: establish a presence chance to units beyond a given threshold, with decremental chance of presence, bool
  _minUnits: amount of units with a 100% chance of presence if _limitPresence was true, number
  _skill: 0: default skill, 1: untrained (below average skills, no FSM), 2: elite (exceptional stats, will never flee), number
  _sameEdCat: force all groups of the same type to belong to the same editor subcategory, bool
  _edCat: editor subcategory to check for if _sameEdCat was true, string

  Returns:
  true
        
  Examples:
  ["Enemy groups","Air Vehicles",_airGroups,1] call DAKKA_fnc_addGroupsToTaskData;   

*/

params ["_sideType", "_groupType", "_groupsPool", ["_groupsAmount", 1], ["_maxUnits", 0], ["_limitPresence", false], ["_minUnits", 3], ["_skill", 1], ["_sameEdCat", true], ["_edCat", ""]];
// if (DAKKA_debug) then { diag_log format ["_sideType: %1 _groupType: %2 _groupsPool: %3 _groupsAmount: %4 _maxUnits: %5 _limitPresence: %6 _minUnits: %7 _skill: %8 _sameEdCat: %9 _edCat: %10", _sideType, _groupType, (_groupsPool select 0) select 0, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, _sameEdCat, _edCat] };

private _task = DAKKA_Task;
private _taskData = DAKKA_TaskData select (_task - 1);

private _groupsDataIndex = [_taskData, _sideType] call BIS_fnc_findInPairs;
private _groupsData = (_taskData select _groupsDataIndex) select 1;
private _selectedGroup = [];
private _presenceChance = 1;
for [{private _i = 0}, {_i < _groupsAmount}, {_i = _i + 1}] do 
{
    // if (_sameEdCat && _sideType == "Friendly groups" && _groupType == "Infantry") then {
    if (_sameEdCat && (_groupType == "Infantry" || _groupType == "Patrols" || _groupType == "Defenders") && _edCat != "") then {
    // Pick only teams of the same editor category
        if (DAKKA_debug) then { diag_log format ["DAKKA: Play Now -_fnc_addGroupsToTaskData - Filtering provided groups by category for %1, %2: %3", _sideType, _groupType, _edCat] };
        _groupsPoolTemp = _groupsPool select {
            _thisESubCat = getText (configFile >> "CfgVehicles" >> ((_x select 0) select 0) >> "editorSubcategory");
            // _playerESubCat = getText (configFile >> "CfgVehicles" >> ((_playerGroup select 0) select 0) >> "editorSubcategory");
            // _thisESubCat == _playerESubCat
            _thisESubCat == _edCat;
        };
        if (count _groupsPoolTemp == 0) exitWith {
            diag_log format ["DAKKA: --- WARNING --- Couldn't find groups of the same editor category for %1! Trying again without category limits...", _sideType];
            [_sideType, _groupType, _groupsPool, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, false] call DAKKA_fnc_addGroupsToTaskData
        };
        _groupsPool = +_groupsPoolTemp;
    };
    _selectedGroup = selectRandom _groupsPool;
    // if (DAKKA_debug) then { diag_log format ["DAKKA: Play Now - _fnc_addGroupsToTaskData - _thisGroupData: %1", ((_selectedGroup select 0) select 0)] };

    private _groupEdCat = getText (configFile >> "CfgVehicles" >> ((_selectedGroup select 0) select 0) >> "editorSubcategory");
    private _friendly = if (_sideType == "Friendly groups") then { true } else { false };
    if (("sno" in toLowerAnsi(_groupEdCat) || "winter" in toLowerAnsi(_groupEdCat)) && isNil format ["DAKKA_snowCamo_checked_%1", if (_friendly) then { "friendly" } else { "enemy" }]) exitWith {
        diag_log format ["DAKKA: --- WARNING --- Unit camo is 'Snow' and it usually looks silly in most terrains. Trying again...", _sideType];
        missionNamespace setVariable [format ["DAKKA_snowCamo_checked_%1", if (_friendly) then { "friendly" } else { "enemy" }], true];
        [_sideType, _groupType, _groupsPool, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill] call DAKKA_fnc_addGroupsToTaskData
    };

    // Set side editor category if it wasn't set already
    if (_sameEdCat && (_groupType == "Infantry" || _groupType == "Patrols" || _groupType == "Defenders") && _edCat == "") exitWith {
        if (_sideType == "Friendly groups") then {
            DAKKA_friendlyInfEdCat = _groupEdCat;
        } else {
            DAKKA_enemyInfEdCat = _groupEdCat;
        };
        diag_log format ["DAKKA: Editor category wasn't set. Trying again with: %1", _groupEdCat];
        [_sideType, _groupType, _groupsPool, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, true, _groupEdCat] call DAKKA_fnc_addGroupsToTaskData
    };

    private _thisGroupData = [format ["%1 Group %2", _groupType, _i + 1], [], []];
    {
        if (_maxUnits > 0 && _forEachIndex == _maxUnits) exitWith { true };
        if (_limitPresence && {_forEachIndex > _minUnits}) then { _presenceChance = (_presenceChance - 0.25) max 0.25 };
        (_thisGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], _presenceChance, _skill];
    } forEach (_selectedGroup select 0);
    // Add to tasks array
    [_groupsData, _groupType, [_thisGroupData]] call BIS_fnc_addToPairs;
    if (_limitPresence) then { _presenceChance = (1 - (0.1 * _i)) max 0.25 };
};

true