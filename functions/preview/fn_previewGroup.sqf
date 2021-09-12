#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Previews the player's group. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_unitsArr", ["_ranksArr", []], ["_loadoutArr", []], ["_groupMods", []]];
// if (DAKKA_debug) then { diag_log format ["DAKKA: previewGroup:[%1] [%2] ", _unitsArr, _ranksArr] };
private ["_pos", "_unit", "_grp", "_isMan", "_rank"];
if (DAKKA_debug) then { diag_log format ["DAKKA: 1 previewGroup DAKKA_previewGroup:%1", DAKKA_previewGroup] };
// waitUntil { isNull DAKKA_previewGroup };
if (isNull DAKKA_previewGroup) then {	
	cutText ["Loading Preview...", "BLACK IN", 999];
    ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];

	// if (DAKKA_debug) then { diag_log format ["DAKKA: 1 previewGroup _unitsArr:%1", _unitsArr] };
	// if (DAKKA_debug) then { diag_log format ["DAKKA: 1 previewGroup _ranksArr:%1", _ranksArr] };
	_pos = getMarkerPos "DAKKA_groupPreviewPos";
	_unit = objNull;
	_grp = grpNull;
	_isMan = true;
    private _changeLoadouts = [];
	{	
		// if (DAKKA_debug) then { diag_log format ["DAKKA: 2 previewGroup DAKKA_previewGroup:%1", DAKKA_previewGroup] };
		if(!isNull DAKKA_previewGroup) exitWith {
			diag_log format ["DAKKA: --- ERROR --- Another instance is already creating preview group (%1) ", DAKKA_previewGroup];
			diag_log format ["DAKKA: --- ERROR --- Units from group that was created: %1", units _grp];
			[_grp] call DAKKA_fnc_deleteGroup;
		};
		// if (DAKKA_debug) then { diag_log format ["DAKKA: previewGroup _x:%1", _x] };
		// if (DAKKA_debug) then { diag_log format ["DAKKA: _isMan: %1", "Man" in ([configFile >> "CfgVehicles" >> _x, true ] call BIS_fnc_returnParents)] };
		// if (DAKKA_debug) then { diag_log format ["DAKKA: 1 previewGroup _x:%1", _x] };
		_isMan = [_x] call DAKKA_fnc_isMan;
		_unit = if (_isMan) then {
				([_x, _pos] call DAKKA_fnc_spawnMan);
			} else {
				([_x, _pos] call DAKKA_fnc_spawnVehicle);
			};

		if (isNull _unit) exitWith {
			diag_log format ["DAKKA: --- ERROR --- Class ""%1"" not found and could not be spawned! ", _x];

			private _error = "ERROR: Unit class not found. ";
            private _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
            private _knownMods = [DAKKA_settings, "Known mods"] call BIS_fnc_getFromPairs;
			_groupMods = _groupMods - [""];
			if (count _knownMods > 0) then {
				private _mods = "";
				{
					private _modName = (modParams [_knownMods select _x, ["name"]]) select 0;
					if (isNil "_modName") then { _modName = _knownMods select _x };
					_mods = (format ["%1%2%3", _mods, if (_forEachIndex > 0) then {", "} else {""}, _modName]);
				} forEach _groupMods;
				_error = format ["%1It needs the following addons: %2", _error, _mods];
			};
            [_error] spawn DAKKA_fnc_displayMessage;
            // Preview empty
            call DAKKA_fnc_previewGroupDelete;
            call DAKKA_fnc_cameraPreviewTerminate;
            [getMarkerPos "DAKKA_groupPreviewPos"] spawn DAKKA_fnc_cameraPreviewStatic;
		};
		// waitUntil {!isNull _unit };
		// if (DAKKA_debug) then { diag_log format ["DAKKA: previewGroup _unit:%1", _unit] };

		if (_forEachIndex == 0) then {
			_grp = group _unit;
		} else {
			[_unit] joinSilent _grp;
		};
		_grp deleteGroupWhenEmpty true;
		if(!_isMan) then { _grp addVehicle _unit };
		// Set rank
		_rank = if ((count _ranksArr) > 0) then { (_ranksArr select _forEachIndex)} else { if (_forEachIndex == 0) then { "SERGEANT" } else { "PRIVATE" }};
		_unit setUnitRank _rank;
		// Set loadout
		if (count _loadoutArr > 0) then {
            private _unitLoadout = _loadoutArr select _forEachIndex;
            _changeLoadouts pushBack [_unit, _unitLoadout];
		};
		_unit setVelocity [0, 0, 0];
		_unit disableAI "FSM";
		_unit disableAI "MOVE";
		_unit disableAI "PATH";
		_unit disableAI "ANIM";
		_unit disableAI "RADIOPROTOCOL";
		_unit disableAI "AUTOTARGET";
		_unit disableAI "AUTOCOMBAT";
		_unit setCaptive true;
		_unit allowDamage false;
		{
			_x setCaptive true;
			_x allowDamage false;
		} forEach crew vehicle _unit;
		if(!_isMan) then { _unit enableSimulation false;};
	} forEach _unitsArr;
	DAKKA_previewGroup = _grp;
	[_grp] spawn DAKKA_fnc_previewGroupPosition;
    cutText ["", "BLACK IN", 2];

    // Apply loadouts a bit delayed to wait for units that change loadout at init EH to do their thing
    if (count _changeLoadouts > 0) then {
        _null = _changeLoadouts spawn {
            sleep 1;
            {
                private _unit = _x select 0;
                private _unitLoadout = _x select 1;
                private _isMan = [_unit] call DAKKA_fnc_isMan;
                if (_isMan) then {
                    _unit setUnitLoadout [_unitLoadout, true];
                } else {
                    {
                        _x setUnitLoadout [_unitLoadout, true];
                    } forEach (crew vehicle _unit);
                };
            } forEach _this;
        };
    };



} else {
	// call DAKKA_fnc_previewGroupDelete;
	// ["_unitsArr", "_ranksArr"] call DAKKA_fnc_previewGroup;
};