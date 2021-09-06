#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Opens the virtual arsenal for the selected unit. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath", ["_groupNumber", 1], ["_enemy", true]];
private ["_display", "_ctrl", "_taskData", "_groupsData", "_groupsCategoryData", "_thisCategoryGroups", "_thisGroupData", "_unitsData", "_unit", "_unitIndex", "_unitClass", "_unitRank", "_unitLoadout", "_unitPresence", "_unitSkill", "_groupIndex", "_editedLoadout", "_inVeh", "_veh", "_isPlayer", "_crewSlot", "_crewRole", "_playerLoadout", "_crewUnit", "_groupUnits"];

if ((count _selectionPath) < 2) exitWith { ["ERROR: No unit was selected!"] spawn DMORBAT_fnc_displayMessage; };

_groupIndex = (_selectionPath select 0) - 1;
_unitIndex = _selectionPath select 1;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
if (_groupNumber > 0) then {
    // Custom group
    _groupsData = [_taskData, format ["%1 groups", if (_enemy) then { "Enemy" } else { "Friendly" }]] call BIS_fnc_getFromPairs;
    _groupsCategoryData = _groupsData select (_groupNumber - 1);
    _thisCategoryGroups = _groupsCategoryData select 1;
    _thisGroupData = _thisCategoryGroups select _groupIndex;
} else {
    // Player group
    _groupsData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
    _thisGroupData = _groupsData select 0;
};
_unitsData = _thisGroupData select 1;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _unitsData: %1", _unitsData] };
_unitArr = _unitsData select _unitIndex;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _unitArr: %1", _unitArr] };
_unitClass = _unitArr select 0;
_unitRank = _unitArr select 1;
_unitLoadout = _unitArr select 2;
	// if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _unitLoadout (before): %1", _unitLoadout] };
_unitPresence = _unitArr select 3;
_unitSkill = _unitArr select 4;

_groupUnits = (units DMORBAT_previewGroup);
_unit = _groupUnits select _unitIndex;
_veh = vehicle _unit;
_inVeh = if ([_veh] call DMORBAT_fnc_isMan) then { false } else { true };
// if (_inVeh) exitWith { ["ERROR: You can only modify loadouts of infantry units"] call DMORBAT_fnc_displayMessage; };
_isPlayer = if (_groupNumber == 0 && [_unitIndex] call DMORBAT_fnc_checkIfSelIsPlayer) then { true } else { false };
_playerData = [];
_crewSlot = 0;
_crewRole = DMORBAT_crewSlotRoles select _crewSlot;
_playerLoadout = [];
if (_isPlayer) then {
    _playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
    if (_inVeh) then {
        _crewSlot = _playerData select 1;
        _crewRole = DMORBAT_crewSlotRoles select _crewSlot;
    };
    _playerLoadout = _playerData select 2;
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _playerLoadout: %1", _playerLoadout] };
};
if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _unit: %1 (%2)", _unit, _unitClass] };

_display = findDisplay IDC_MENU_MISSION_EDIT;

// Hide menus
_ctrl = (_display displayCtrl IDC_GRP_NAV_BUTTONS);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_FACTION_GROUPS);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUPS);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_TASK_DESCRIPTION);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TXT_TIPS);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_LEFTBAR_BCKG);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_BOTTOMBAR_BCKG);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_BT_PREVIEW);
_ctrl ctrlShow false;

// Hide the rest of the units in the group
_crewUnit = objNull;
{
	if (_x != _unit) then {
		(vehicle _x) hideObject true;
    } else {
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout %1 is the previewed unit", _x] };
        if (_inVeh) then {
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout %1 is in a vehicle", _x] };
            if (_isPlayer) then {
                _crewUnit = call compile format ["%1 _veh", _crewRole];
                if (_x == _crewUnit) then {
                    _veh hideObject true;
                    _crewUnit setUnitLoadout [_playerLoadout, true];
                    moveOut _crewUnit;
                    [_crewUnit] allowGetIn false;
                };
            } else {
                // if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout %1 is in not the player. commander: %2", _x, effectiveCommander _veh] };
                //     // private _crewIndex = (crew _veh) find _x;
                //     // private _crewUnit = (crew _veh) select _crewIndex;
                //     _veh hideObject true;
                //     private _crewUnit = effectiveCommander _veh;
                //     if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _unitLoadout: %1", _unitLoadout] };
                //     _crewUnit setUnitLoadout _unitLoadout;
                //     moveOut _crewUnit;
                //     [_crewUnit] allowGetIn false;
                //     _crewUnit hideObject false;
                _veh hideObject true;
                _crewUnit = [effectiveCommander _veh] call DMORBAT_fnc_cloneUnit;
                if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _crewUnit: %1", _crewUnit] };
                _crewUnit setUnitLoadout _unitLoadout;
            };
        };
	};
} forEach _groupUnits;
if (!isNull _crewUnit) then { _groupUnits pushBackUnique _crewUnit };

// Hide the player
p1 hideObject true;

// Open the arsenal
["Open", [true, objNull, if (isNull _crewUnit) then { _unit } else { _crewUnit }]] call BIS_fnc_arsenal;
DMORBAT_arsenalOpened = true;

// Wait for the arsenal to close
while { DMORBAT_arsenalOpened } do {
	waitUntil { !DMORBAT_arsenalOpened };

    // Things to do after arsenal is closed
    cutText ["", "BLACK IN", 999];

	// Update unit's loadout
    _editedLoadout = getUnitLoadout (if (isNull _crewUnit) then { _unit } else { _crewUnit });
	_unitArr set [2, _editedLoadout];
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: editUnitLoadout _editedLoadout: %1", _editedLoadout] };

    // Add loadout to player data is unit is playable
    if (_isPlayer) then {
        _playerData set [2, _editedLoadout];
    };

	// Show the rest of the units in the group
	{
		(vehicle _x) hideObject false;
        if (_x == _unit || _x == _crewUnit) then {
            if (_inVeh) then {
                if (_isPlayer) then {
                    if (call compile format ["_x == (%1 _veh)", _crewRole]) then {
                        [_x] allowGetIn true;
                        call compile format ["_x moveIn%1 _veh", _crewRole];
                        _veh hideObject false;
                    };
                } else {
                    // [_x] allowGetIn true;
                    // _x moveInAny _veh;
                    _veh hideObject false;
                };
            };
            if (_x == _crewUnit) then {
                [_crewUnit] call DMORBAT_fnc_deleteMan;
            };
        };
	} forEach _groupUnits;

    // Show the player
    p1 hideObject false;

	// Reload page
	[] execVM format ["menuPages\page%1.sqf", DMORBAT_lastPage];

	// Show menus
	_ctrl = (_display displayCtrl IDC_GRP_NAV_BUTTONS);
	_ctrl ctrlShow true;
	_ctrl = (_display displayCtrl IDC_GRP_FACTION_GROUPS);
	_ctrl ctrlShow true;
	_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUPS);
	_ctrl ctrlShow true;
	_ctrl = (_display displayCtrl IDC_GRP_TASK_DESCRIPTION);
	_ctrl ctrlShow true;
	_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
	_ctrl ctrlShow true;
    _ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
    _ctrl ctrlShow true;
    _ctrl = (_display displayCtrl IDC_TXT_TIPS);
    _ctrl ctrlShow true;
    _ctrl = (_display displayCtrl IDC_GRP_LEFTBAR_BCKG);
    _ctrl ctrlShow true;
    _ctrl = (_display displayCtrl IDC_GRP_BOTTOMBAR_BCKG);
    _ctrl ctrlShow true;
    _ctrl = (_display displayCtrl IDC_BT_PREVIEW);
    _ctrl ctrlShow true;

	// Reselect edited unit
	sleep 1;
	switch (_groupNumber) do {
		case 0: {
			_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
		};
		case 1: {
			_ctrl = (_display displayCtrl IDC_TREE_GRP1);
		};
		case 2: {
			_ctrl = (_display displayCtrl IDC_TREE_GRP2);
		};
		case 3: {
			_ctrl = (_display displayCtrl IDC_TREE_GRP3);
		};
	};
	_ctrl tvSetCurSel _selectionPath;

    // Save task settings
    call DMORBAT_fnc_settingsSave;


    cutText ["", "BLACK IN"];

};

