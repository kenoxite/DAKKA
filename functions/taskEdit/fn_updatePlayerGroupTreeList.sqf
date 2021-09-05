#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the tree list displaying the player's group. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc"];
// diag_log format ["DMORBAT: updatePlayerGroupTreeList _idc:%1", _idc];
private ["_ctrl", "_indexCtrl", "_taskData", "_thisCategoryGroups", "_thisGroupData", "_groupName", "_unitsData", "_unitClass", "_unitName", "_rank", "_rankImg", "_faction", "_factionName", "_unitNameFull", "_tooltip", "_crewRole", "_isMan", "_isPlayer", "_presence", "_skill", "_thisUnitData", "_lodaout", "_groupMods", "_ctrlGrpIndex", "_ctrlUnitIndex"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc;
tvClear _ctrl;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_thisCategoryGroups = [_taskData, "Player group"] call BIS_fnc_getFromPairs;

diag_log format ["DMORBAT: updatePlayerGroupTreeList _thisCategoryGroups:%1", _thisCategoryGroups];
if (count _thisCategoryGroups > 0) then {
	for [{private _i = 0}, {_i < count _thisCategoryGroups}, {_i = _i + 1}] do
	{
        _thisGroupData = _thisCategoryGroups select _i;
        _groupName = _thisGroupData select 0;
        _unitsData = _thisGroupData select 1;
        _groupMods = _thisGroupData select 2;
        // diag_log format ["DMORBAT: updatePlayerGroupTreeList _thisGroupData:%1", _thisGroupData];
        _ctrlGrpIndex = _ctrl tvAdd [[], _groupName];
        _ctrl tvSetData [[_ctrlGrpIndex], _groupName];
        _ctrl tvExpand [_ctrlGrpIndex];
        // _ctrl tvExpand [_i];
        _tooltip = format ["%1\n\nClick to preview and set this group as the target when adding faction units", _groupName];
        // Mod dependencies
        _knownMods = +[DMORBAT_settings, "Known mods"] call BIS_fnc_getFromPairs;
        // diag_log format ["DMORBAT: updatePlayerGroupTreeList _knownMods:%1", _knownMods];
        if (count _groupMods > 0) then {
            private _noMods = true;
            private _i = 0;
          {
            _mod = (modParams [_knownMods select _x, ["name"]]) select 0;
            if (isNil "_mod") then { _mod = _knownMods select _x };
            // diag_log format ["DMORBAT: updatePlayerGroupTreeList _mod:%1", _mod];
            if (_mod != "") then {
                if (_noMods) then{
                    _tooltip = format ["%1\nGroup dependencies:\n", _tooltip];
                    _noMods = false;
                };
                _tooltip = format ["%1%2%3", _tooltip, if (_i > 0) then {", "} else {""}, _mod];
                _i = _i + 1;
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
			_isPlayer = [_j] call DMORBAT_fnc_checkIfSelIsPlayer;
			_crewRole = "";
			if (!_isMan && _isPlayer) then {
                private _playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
                private _playerCrewIndex = _playerData select 1;
				_crewRole = format ["(%1) ", DMORBAT_crewSlotRoles select _playerCrewIndex];
			};
			_unitNameFull = format ["%1. %2 [%3] %4", _j + 1, _unitName, _factionName, _crewRole select [1, 1]];
			// _rank = if (_j == 0) then { "SERGEANT" } else { "PRIVATE" };
			_rank = (_unitsData select _j) select 1;
			_rankImg = [_rank, "texture"] call BIS_fnc_rankParams;
            
			_ctrlUnitIndex = _ctrl tvAdd [[_ctrlGrpIndex], _unitName];
			_ctrl tvSetText [[_ctrlGrpIndex, _ctrlUnitIndex], _unitNameFull];
			_ctrl tvSetData [[_ctrlGrpIndex, _ctrlUnitIndex], _unitClass];
			_ctrl tvSetPicture [[_ctrlGrpIndex, _ctrlUnitIndex], _rankImg];
			if (_isPlayer) then {
				_ctrl tvSetColor [[_ctrlGrpIndex, _ctrlUnitIndex], [0.38, 0.6, 0.816, 1]];

				// Set player faction as that of the playable unit
				DMORBAT_PlayerFaction = _faction;
				// systemChat format ["DMORBAT: updatePlayerGroupTreeList DMORBAT_PlayerFaction: %1", DMORBAT_PlayerFaction]; 
			};
			_ctrl tvSetTooltip [[_ctrlGrpIndex, _ctrlUnitIndex], [format ["%1 [%2] %3", _unitName, _factionName, _crewRole select [1, 1]], _unitClass, _j, count _lodaout, _presence, _skill, _groupMods, true] call DMORBAT_fnc_createUnitTooltip];
		};
	};
};