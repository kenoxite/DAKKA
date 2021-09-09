/*
  Author: kenoxite

  Description:
  Returns wether the unit or class has NVGs in its inventory or not


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/
params [["_class", "", ["", objNull]]];

private ["_gear", "_linkedItems", "_items", "_backpack", "_backpackItems", "_hasNVG", "_config"];

if (typeName _class == "OBJECT") then {
    _class = typeOf _class;
};

_gear = [];
_config = configFile >> "CfgVehicles" >> _class;
_linkedItems =  getArray (_config >> "linkedItems");
_gear append _linkedItems;
_items =  getArray (_config >> "Items");
_gear append _items;
_backpack = getText (_config >> "backpack");
if !(isNil "_Backpack") then {
    if (_backpack != "") then {
        _backpackItems = getArray (configFile >> "CfgVehicles" >> _backpack >> "TransportItems");
        _gear append _backpackItems;
    };
};

if (count _gear == 0) exitWith { false };

_hasNVG = false;
{
    if (_x isKindOf ["NVGoggles", configFile >> "CfgWeapons"]) exitWith {
        _hasNVG = true;
    };
} forEach _gear;

_hasNVG


/*
if !([_unit] call DMORBAT_fnc_isMan) exitWith { false };

// Check for equipped NVG
private _hasNVG = false;
{
    if (_x isKindOf ["NVGoggles", configFile >> "CfgWeapons"]) then {
        _hasNVG = true;
    };
} forEach (assignedItems _unit);
if (_hasNVG) exitWith { true };

// Check for stored NVG
{
    if (_x isKindOf ["NVGoggles", configFile >> "CfgWeapons"]) then {
        _unit assignItem _x;
        _hasNVG = true;
    };
} forEach (itemsWithMagazines _unit);
*/