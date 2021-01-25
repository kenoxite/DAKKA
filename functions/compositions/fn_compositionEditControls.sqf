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
private ["_display", "_ctrl", "_selectionPath", "_ref", "_posRef", "_dirRef", "_taskData", "_worldCompositionsData", "_compositionsData", "_index", "_thisCompositionData", "_compObjects", "_compObjectsCopy", "_obj
", "_objClass", "_relPos", "_objDir", "_itemPos", "_finalDir", "_nearTerrObj", "_hiddenObjects", "_hideDist", "_keepHorizontal"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idc);
_selectionPath = tvCurSel _ctrl;
if ((_selectionPath select 0) < 0) exitWith { systemChat format ["DMORBAT: --- ERROR --- No composition was selected!"]; };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

_index = (_selectionPath select 0);
_thisCompositionData = _compositionsData select _index;
_compObjects = _thisCompositionData select 1;
_compObjectsCopy =+ _thisCompositionData select 1;
_compObjectsCopy deleteAt 0;
_hiddenObjects = _thisCompositionData select 2;
_hideDist = 2;
// Show hidden terrain objects
{
  _x hideObject false;
} forEach _hiddenObjects;
_thisCompositionData deleteAt 2;

_ref = DMORBAT_editReference;
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

_ref setPosATL _posRef;
_ref setDir _dirRef;
// Update array with new values
(_compObjects select 0) set [1, _posRef];
(_compObjects select 0) set [2, _dirRef];
_hiddenObjects = [];
{
  _obj = _x select 0;
  _objClass = _x select 1;
  _relPos = _x select 2;
  _objDir = _x select 3;
  _keepHorizontal = _x select 4;
  _itemPos = _ref modelToWorld _relPos;
  _itemPos = [_itemPos select 0, _itemPos select 1, _relPos select 2];
  // Move object to position
  _obj enableSimulation false;
  _obj setVelocity [0, 0, 0];
  _obj allowDamage false;
  _finalDir = _objDir + _dirRef;
  _obj setDir _finalDir;
  _obj setPos _itemPos;
    // Further adjustments to objects who still hover over ground when they should be at ground level
    if ((_itemPos select 2) <= 0.1) then {
        _posATL = getPosATL _obj;
        _obj setPosATL [(_posATL select 0), (_posATL select 1), ((getPos _obj) select 2) min 0];
    };
  // Hide nearby terrain objects
  _nearTerrObj = nearestTerrainObjects [_itemPos, [], _hideDist + (sizeOf _objClass), true, true];
  {
    _x hideObject true;
    _hiddenObjects pushBackUnique _x;
  } forEach _nearTerrObj;
  // _obj allowDamage true;
  // _obj enableSimulation true;
    
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
} forEach _compObjectsCopy;

// Append the array of hidden objects at the end
_thisCompositionData pushBack _hiddenObjects;

// Save task settings
call DMORBAT_fnc_settingsSave;

true