#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Creates a tooltip with information about the unit. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_unitName", "_unitClass", "_index", "_loadout", "_presence", "_skill", "_mods", ["_checkPlayer", false]];
private ["_tooltip", "_isPlayer", "_isMan", "_taskData", "_playerCrewIndex", "_crewRole", "_skillLevels", "_skillTxt", "_unitTraits"];

_tooltip = "";

// Leader check
if (_index == 0) then { _tooltip = format ["GROUP LEADER\n%1", _tooltip] };

// Player and crew slot check
if (_checkPlayer) then {
  _isPlayer = [_index] call DAKKA_fnc_checkIfSelIsPlayer;
} else {
  _isPlayer = false;
};
_isMan = [_unitClass] call DAKKA_fnc_isMan;
_crewRole = "";
if (!_isMan && _isPlayer) then {
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
    _playerCrewIndex = _playerData select 1;
    _crewRole = format ["(%1) ", DAKKA_crewSlotRoles select _playerCrewIndex];
};
if (_isPlayer) then {
  _tooltip = format ["PLAYER %1\n%2", _crewRole, _tooltip];
};

// Traits
_unitTraits = [
                ["attendant", "HEAL", "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa"],
                ["engineer", "REPAIR", "a3\ui_f\data\igui\cfg\cursors\iconrepairat_ca.paa"],
                ["canDeactivateMines", "DEACTIVATE MINES", "a3\ui_f\data\igui\cfg\cursors\explosive_ca.paa"],
                ["uavHacker", "HACK DRONES", "\a3\ui_f\data\igui\cfg\holdactions\holdaction_hack_ca.paa"]
            ];
private _config = configFile >> "CfgVehicles" >> _unitClass;
private _i = 0;
{
    private _traitClass = _x select 0;
    private _traitDescription = _x select 1;
    private _traitIcon = _x select 2;
    private _trait = getNumber (_config >> _traitClass);
    if (_trait == 1) then {
        _tooltip = format ["%1%2%3", _tooltip, if (_i > 0) then { ", " } else { "Traits: " }, _traitDescription];
        _i = _i + 1;
    };
} forEach _unitTraits;
if (_i > 0) then {
    _tooltip = format ["%1\n", _tooltip];
};

// Skill and presence
_skillTxt = toUpper (DAKKA_skillLevels select _skill);
_tooltip = format ["%1%2%3 presence\nSkill %4", _tooltip, _presence * 100, "%", _skillTxt];

// Loadout
if (_loadout > 0) then {
  _tooltip = format ["%1\nLoadout edited", _tooltip];
};

// Default text
_tooltip = format ["%1\n%2\nClick to highlight in preview panel\n\n%3", _unitName, _unitClass, _tooltip];

_tooltip