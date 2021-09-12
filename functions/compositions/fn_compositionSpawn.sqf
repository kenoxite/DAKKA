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

params ["_pos", "_dir", "_category", "_subcategory", "_className", ["_aligned", true], ["_simple", false]];
private ["_composition", "_objClass", "_relPos", "_objDir", "_itemPos", "_obj", "_ref", "_finalDir", "_nearTerrObj", "_hiddenObjects", "_hideDist", "_keepHorizontal"];
_ref = "Flag_BI_F" createVehicle _pos;
_ref setDir _dir;
_ref setPos _pos;
_ref hideObject true;
_hiddenObjects = [];
_hideDist = 2;
_composition = [[_ref, _pos, _dir]];
{
	_objClass = getText (_x >> "vehicle");
	_relPos = getArray (_x >> "position");
	_objDir = getNumber (_x >> "dir");
	_keepHorizontal = getNumber (configfile >> "CfgVehicles" >> _objClass >> "keepHorizontalPlacement");
	_itemPos = _ref modelToWorld _relPos;
	_itemPos = [_itemPos select 0, _itemPos select 1, _relPos select 2];
    _finalDir = _objDir + _dir;
	// Spawn object
	_obj = _objClass createVehicle _itemPos;
	// _obj = createVehicle [_objClass, _itemPos, [], 0 , "CAN_COLLIDE"];
    _obj enableSimulation false;
    _obj setVelocity [0, 0, 0];
    _obj allowDamage false;
    _obj setDir _finalDir;
    _obj setPos _itemPos;
    // Further adjustments to objects who still hover over ground when they should be at ground level
    if ((_itemPos select 2) <= 0.1) then {
        _posATL = getPosATL _obj;
        _obj setPosATL [(_posATL select 0), (_posATL select 1), ((getPos _obj) select 2) min 0];
    };
    // Hide nearby terrain objects - must be checked after spawning the object, otherwise it'll return zero
    _nearTerrObj = nearestTerrainObjects [_itemPos, [], _hideDist + (sizeOf _objClass), true, true];
    {
        _x hideObject true;
        _hiddenObjects pushBackUnique _x;
    } forEach _nearTerrObj;
	if (_simple) then {
		_obj= [_obj] call DAKKA_fnc_convertToSimpleObject;
	} else {
		// _obj allowDamage true;
		// _obj enableSimulation true;
	};
	// if (_keepHorizontal == 1) then { systemChat format ["DAKKA: _objClass: %1 _keepHorizontal: %2", _objClass, _keepHorizontal] };
    
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
	if (isNull _obj) exitWith { [format ["ERROR: Could not create object '%1'", _objClass]] spawn DAKKA_fnc_displayMessage;};
	_composition pushBack [_obj, _objClass, _relPos, _objDir, _keepHorizontal];
} forEach ("true" configClasses (configfile >>  "CfgGroups" >> "Empty" >> _category >> _subcategory >> _className));
// deleteVehicle _ref;


[_composition, _hiddenObjects]