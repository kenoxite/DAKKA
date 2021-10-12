#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Controls for editing compositions. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_action", "_idc", ["_aligned", true]];
private ["_display", "_ctrl", "_selectionPath", "_ref", "_posRef", "_dirRef", "_taskData", "_worldCompositionsData", "_compositionsData", "_index", "_thisCompositionData", "_compObjects", "_obj
", "_objClass", "_relPos", "_objDir", "_itemPos", "_finalDir", "_nearTerrObj", "_hiddenObjects", "_hideDist", "_keepHorizontal"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idc);
_selectionPath = tvCurSel _ctrl;
if ((_selectionPath select 0) < 0) exitWith { systemChat format ["DAKKA: --- ERROR --- No composition was selected!"]; };

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

_index = (_selectionPath select 0);
_thisCompositionData = _compositionsData select _index;
_compObjects = _thisCompositionData select 1;
_hiddenObjects = _thisCompositionData select 2;
_hideDist = 2;
// Show hidden terrain objects
{
  _x hideObject false;
} forEach _hiddenObjects;
_thisCompositionData deleteAt 2;

_ref = DAKKA_editReference;
_posRef = getPosATL _ref;
_dirRef = getDir _ref;

if (_action == "ROTLEFT") then {
  _dirRef = _dirRef - 10;
};

if (_action == "ROTRIGHT") then {
  _dirRef = _dirRef + 10;
};

if (_action == "LEFT") then {
  _posRef set [0, (_posRef select 0) - 1];
};

if (_action == "RIGHT") then {
  _posRef set [0, (_posRef select 0) + 1];
};

if (_action == "UP") then {
  _posRef set [1, (_posRef select 1) + 1];
};

if (_action == "DOWN") then {
  _posRef set [1, (_posRef select 1) - 1];
};

// Update array with new values
(_compObjects select 0) set [1, _posRef];
(_compObjects select 0) set [2, _dirRef];
_ctrl ctrlEnable false;

cutText ["Updating composition. Please wait...", "BLACK IN", 999];

// Disable simulation
for "_i" from 1 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    // _obj setPos [random 100,random 100,10000];
    _obj enableSimulation false;
    _obj allowDamage false;
};

_hiddenObjects = [];
for "_i" from 1 to (count _compObjects)-1 do
{
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    private _objClass = _objData select 1;
    private _relPos = _objData select 2;
    private _objDir = _objData select 3;
    private _keepHorizontal = _objData select 4;
    private _vectorDir = if (count _objData > 5) then {_objData select 5} else {[]};
    private _vectorUp = if (count _objData > 6) then {_objData select 6} else {[]};
    private _simple = if (count _objData > 7) then {_objData select 7} else {false};
    private _pos = _ref modelToWorld _relPos;
    private _itemPos = [_pos select 0, _pos select 1, _relPos select 2];
    // Move object to position
    _obj enableSimulation false;
    _obj setVelocity [0, 0, 0];
    _obj allowDamage false;

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
    // sleep 0.0001;
};

// Rotate reference and wait for rotation to finish
_ref setPosATL _posRef;
_ref setDir _dirRef;
sleep ((count _compObjects) * 0.0001);

// Detach objects and set correct altitude
for "_i" from 1 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    private _objClass = _objData select 1;
    private _relPos = _objData select 2;
    private _objDir = _objData select 3;
    private _keepHorizontal = _objData select 4;
    private _vectorDir = if (count _objData > 5) then {_objData select 5} else {[]};
    private _heightATL = if (count _objData > 9) then {_objData select 9} else {_relPos select 2};
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
};

// Set pos 2nd pass
for "_i" from 1 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    private _objClass = _objData select 1;
    private _relPos = _objData select 2;
    private _keepHorizontal = _objData select 4;
    private _vectorDir = if (count _objData > 5) then {_objData select 5} else {[]};
    private _heightAGLS = if (count _objData > 8) then {_objData select 8} else {_relPos select 2};
    private _heightATL = if (count _objData > 9) then {_objData select 9} else {_relPos select 2};
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
};

// Enable simulation
sleep 0.0001;
for "_i" from 1 to (count _compObjects)-1 do
{ 
    private _objData = _compObjects select _i;
    private _obj = _objData select 0;
    // _obj enableSimulation true;
    // _obj allowDamage true;
    _obj setDamage 0;
};

cutText ["", "BLACK IN", 2];
_ctrl ctrlEnable true;

// Append the array of hidden objects at the end
_thisCompositionData pushBack _hiddenObjects;

// Save task settings
call DAKKA_fnc_settingsSave;

true