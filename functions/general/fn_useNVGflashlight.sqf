/*
  Author: kenoxite

  Description:
  Checks if night, and if so it equips NVG if in inventory or gives the unit a flashlight if the flashlight slot is empty


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/
params ["_unit", ["_giveFlashlight", true]];

if !([_unit] call DMORBAT_fnc_isMan) exitWith { false };

// Exit if it isn't dark
// if (sunOrMoon == 1) exitWith { false };
private _sunriseSunsetTime = date call BIS_fnc_sunriseSunsetTime;
if (daytime > (_sunriseSunsetTime select 0) && daytime < (_sunriseSunsetTime select 1)) exitWith { false };

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

// Check for flashlight. Give one if it doesn't have one already
if (!_hasNVG && _giveFlashlight) then {
    private _knownFlashlights = [
        "acc_flashlight",
        "CUP_acc_flashlight",
        "rhsusf_acc_wmx",
        "rhsusf_acc_wmx_bk",
        "rhsusf_acc_M952V",
        "rhs_acc_2dpZenit_ris",
        "rhs_acc_2dpZenit"
        ];
    {
        private _flashlight = ((weaponsItems _unit) select 0) select 2;
        if (!isNil "_flashlight") then {
            if (_flashlight == "") then {
                _unit addPrimaryWeaponItem _x;
            };
        };
    } forEach _knownFlashlights;

    // Force activation
    _unit spawn {
        sleep 5;
        _this enableGunLights "ForceOn";
    };
};

true