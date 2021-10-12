/*
	Author: kenoxite

	Description:
	Spawns a composition defined in cfgGroups and returns an array with its components.

    Vanilla compositions found in: \a3\data_f_curator\config.cpp


	Parameter (s):
	_this select 0: _pos
	_this select 1: _dir
	_this select 2: _category
	_this select 3: _className
	_this select 4: _aligned
	_this select 5: _simple

	Returns:


	Examples:
	[position player, getDir player, "Guerrilla", "Camps", "CampA"] call DAKKA_fnc_compositionSpawn;
*/

params ["_pos", "_refDir", "_category", "_subcategory", "_className", ["_aligned", true], ["_simple", false]];
private ["_composition", "_objClass", "_relPos", "_objDir", "_itemPos", "_obj", "_ref", "_finalDir", "_nearTerrObj", "_hiddenObjects", "_hideDist", "_keepHorizontal"];

diag_log format ["DAKKA: compositionSpawn - Spawning composition...", ""];

["Spawning composition... This might take a good while!"] spawn DAKKA_fnc_displayMessage;


DAKKA_compositionsSpawned = false;
DAKKA_compSpawned = [];

_ref = "Flag_BI_F" createVehicle _pos;
_ref setPos _pos;
_ref hideObject true;
_hiddenObjects = [];
_hideDist = 2;
_composition = [[_ref, _pos, _refDir]];
#include "..\..\compositions_steam.hpp";
private _isCustom = _category == "Steam";
private _customData = if (_category == "Steam") then { (_compositions_steam select (_compositions_steam findIf {(_x select 0) select 0 == _className})) select 1 } else {[]};
_compObjects = ["true" configClasses (configfile >>  "CfgGroups" >> "Empty" >> _category >> _subcategory >> _className), _customData] select _isCustom;
if (_isCustom) then {_compObjects deleteAt 0};
{
	private _objClass = if (_isCustom) then { _x select 1 } else { getText (_x >> "vehicle") };
	private _relPos = if (_isCustom) then { _x select 2 } else { getArray (_x >> "position") };
	private _objDir = if (_isCustom) then { _x select 3 } else { getNumber (_x >> "dir") };
	private _keepHorizontal = if (_isCustom) then { _x select 4 } else { getNumber (configfile >> "CfgVehicles" >> _objClass >> "keepHorizontalPlacement") };
    private _vectorDir = if (_isCustom) then {_x select 5} else {[]};
    private _vectorUp = if (_isCustom) then {_x select 6} else {[]};
    private _simple = if (_isCustom) then {_x select 7} else {false};
    private _heightAGLS = if (_isCustom) then {_x select 8} else {_relPos select 2};
    private _heightATL = if (_isCustom) then {_x select 9} else {_relPos select 2};
    private _objPos = _ref modelToWorld _relPos;
    private _itemPos = [_objPos select 0, _objPos select 1, _relPos select 2];

    // Create the new object
    private _obj = [createVehicle [_objClass, [random 100,random 100,10000], [], 0, "CAN_COLLIDE"], createSimpleObject [_objClass, [random 100,random 100,10000], false]] select (_simple && !(_objClass isKindOf "LandVehicle"));
    // Move object to position
    _obj enableSimulation false;
    _obj setVelocity [0, 0, 0];
    _obj allowDamage false;
    _obj setDamage 0;
    _obj setDir _objDir;

    _obj attachTo [_ref, _relPos];

    // Apply vectors
    if (count _vectorDir > 0 && count _vectorUp > 0) then {
        _obj setVectorDirAndUp [_vectorDir, _vectorUp];
    };

    // Hide nearby terrain objects - must be checked after spawning the object, otherwise it'll return zero
    _nearTerrObj = nearestTerrainObjects [_itemPos, [], _hideDist + (sizeOf _objClass), true, true];
    {
      _x hideObject true;
      _hiddenObjects pushBackUnique _x;
    } forEach _nearTerrObj;

	if (isNull _obj) exitWith { [format ["ERROR: Could not create object '%1'", _objClass]] spawn DAKKA_fnc_displayMessage;};
	_composition pushBack [_obj, _objClass, _relPos, _objDir, _keepHorizontal, _vectorDir, _vectorUp, _simple, _heightAGLS, _heightATL];

    sleep 0.0001;
} forEach _compObjects;
// deleteVehicle _ref;

private _compObjects = +_composition;
_compObjects deleteAt 0;

{
    diag_log format ["DAKKA: compositionSpawn - %1: %2", _forEachIndex, _x];
} forEach _compObjects;


["Rotating composition..."] spawn DAKKA_fnc_displayMessage;
_ref setDir _refDir;
sleep ((count _compObjects) * 0.0001);

["Positioning objects (first pass)..."] spawn DAKKA_fnc_displayMessage;

// Detach objects and set correct altitude
for "_i" from 0 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    private _objClass = _objData select 1;
    private _relPos = _objData select 2;
    private _objDir = _objData select 3;
    private _keepHorizontal = _objData select 4;
    private _vectorDir = if (_isCustom) then {_objData select 5} else {[]};
    private _heightATL = if (_isCustom) then {_objData select 9} else {_relPos select 2};
    private _itemPos = _ref modelToWorld _relPos;
    private _itemPosATL = [_itemPos select 0, _itemPos select 1, _heightATL];
    detach _obj;
    
    if (count _vectorDir == 0) then {
        _obj setDir (_objDir + _refDir);
        _obj setPos _itemPosATL;

        // Fix for CUP compositions
        if ((configSourceMod (configFile >> "CfgVehicles" >> _objClass)) == "@CUP Terrains - Core") then {
            if (_obj isKindOf "House") then {
                _keepHorizontal = 1;
            };
        };

        if (!_aligned || _keepHorizontal == 1) then {
            _obj setVectorUp [0, 0, 1];
        } else {
            _obj setVectorUp (surfaceNormal (position _obj));
        };
    } else {
        _obj setPosATL _itemPosATL;
    };
    _obj setDamage 0;
};

["Positioning objects (second pass)..."] spawn DAKKA_fnc_displayMessage;

// Set pos 2nd pass
for "_i" from 0 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    private _objClass = _objData select 1;
    private _relPos = _objData select 2;
    private _keepHorizontal = _objData select 4;
    private _vectorDir = if (_isCustom) then {_objData select 5} else {[]};
    private _heightAGLS = if (_isCustom) then {_objData select 8} else {_relPos select 2};
    private _heightATL = if (_isCustom) then {_objData select 9} else {_relPos select 2};
    private _itemPos = getPos _obj;
    private _itemPosAGLS = [_itemPos select 0, _itemPos select 1, _heightAGLS];
    private _itemPosATL = [_itemPos select 0, _itemPos select 1, _heightATL];
    private _itemPosATLmod = [_itemPos select 0, _itemPos select 1, _heightATL - _heightAGLS];
    
    if (count _vectorDir > 0) then {
        if (!(_objClass isKindOf "House" || _objClass isKindOf "Thing") && _heightATL <= 0.1) then {
            _obj setPos _itemPosAGLS;
        } else {
            if (_heightATL > 0.1 && !(_objClass isKindOf "Thing")) then { _obj setPos _itemPosATL; };
        };
        if (_obj isKindOf "StaticWeapon") then { _obj setPosATL _itemPosATLmod; };
        if ((_keepHorizontal == 1 || _obj isKindOf "StaticWeapon" || {"fence" in toLowerAnsi _objClass && _heightATL > 0.1}) && {!("Decal" in _objClass) && !("Plank" in _objClass) && !("ConcretePanels" in _objClass) && !("DomeParts" in _objClass)}) then {
            _obj setVectorUp [0, 0, 1];
        };
        if (_obj isKindOf "LandVehicle" && !(_obj isKindOf "StaticWeapon")) then {_obj setVectorUp (surfaceNormal (position _obj)) };
    };
    _obj setDamage 0;
};

// Enable simulation
for "_i" from 0 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    _obj enableSimulation true;
    _obj allowDamage true;
    _obj setDamage 0;
    _obj setVelocity [0, 0, 0];
};

diag_log format ["DAKKA: compositionSpawn - Compositions spawned...", ""];


DAKKA_compSpawned = [_composition, _hiddenObjects];
DAKKA_compositionsSpawned = true;

["Composition spawned!"] spawn DAKKA_fnc_displayMessage;