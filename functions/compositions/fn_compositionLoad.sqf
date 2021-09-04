#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Loads all compositions 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params [["_all", true], ["_location", []], ["_distance", 100]];

DMORBAT_compositionsLoaded = 0;

_nul = _this spawn {
    params [["_all", true], ["_location", []], ["_distance", 100]];
    diag_log format ["DMORBAT: _all: %1, _location: %2, _distance: %3", _all, _location, _distance];
    private ["_taskData", "_worldCompositionsData", "_compositionsData", "_thisCompositionData", "_hiddenObjects", "_compObjects", "_compObjectsCopy", "_ref", "_obj", "_objClass", "_relPos", "_objDir", "_keepHorizontal", "_itemPos", "_finalDir", "_aligned", "_refPos", "_refDir", "_nearTerrObj", "_hideDist", "_return"];

    _return = true;
    _taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
    _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

    private _trimmedCompositionsData = [];
    // Check for distance if not all compositions want to be spawned
    if (!_all) then {
        for [{private _i = 0}, {_i < count _compositionsData}, {_i = _i + 1}] do 
        {
            private _thisCompositionData = _compositionsData select _i;
            private _compObjects = _thisCompositionData select 1;
            private _refArr = _compObjects select 0;
            private _refPos = _refArr select 1;
            private _refDir = _refArr select 2;
            private _ref = "Flag_BI_F" createVehicle _refPos;
            _ref hideObject true;
            if ((_ref distance2D _location) <= _distance) then {
                _trimmedCompositionsData pushBack _thisCompositionData;
            };
        };
    };
    {
        diag_log format ["DMORBAT: _trimmedCompositionsData - %1: %2", _x select 0, _x select 1];
    } forEach _trimmedCompositionsData;


    _aligned = true;

    for [{private _i = 0}, {_i < count _trimmedCompositionsData}, {_i = _i + 1}] do 
    {
    	_thisCompositionData = _trimmedCompositionsData select _i;
    	// diag_log format ["DMORBAT: compositionLoad _thisCompositionData: %1", _thisCompositionData];
        diag_log format ["DMORBAT: compositionLoad - Loading composition: %1", _thisCompositionData select 0 ];
    	_compObjects = _thisCompositionData select 1;
    	_compObjectsCopy =+ _thisCompositionData select 1;
    	_hiddenObjects = [];
    	_ref = (_compObjects select 0) select 0;
        diag_log format ["DMORBAT: compositionLoad _ref 1: %1", _ref ];
    	// Only load if composition does not exist
        if (isNil "_ref") then { _ref = objNull };
        if (typeName _ref == "STRING") then { _ref = objNull };
    	if (isNull _ref) then {
    		// Load composition objects
    		_refArr = _compObjectsCopy select 0;
    		_refPos = _refArr select 1;
    		_refDir = _refArr select 2;
    		_ref = "Flag_BI_F" createVehicle _refPos;
            diag_log format ["DMORBAT: compositionLoad _ref 2: %1", _ref ];
    		// Update the composition objects array with the new object
    		(_compObjects select 0) set [0, _ref];
    		_ref setDir _refDir;
    		_ref setPos _refPos;
    		_ref hideObject true;
    		_compObjectsCopy deleteAt 0;
            // _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", format["DMORBAT_mrkr_comp%1", random 999], _refPos, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 1, "Composition"] call BIS_fnc_stringToMarker;
    		_hideDist = 2;
    		{
    		  _objClass = _x select 1;
    		  _relPos = _x select 2;
    		  _objDir = _x select 3;
    		  _keepHorizontal = _x select 4;
    		  _itemPos = _ref modelToWorld _relPos;
    		  _itemPos = [_itemPos select 0, _itemPos select 1, _relPos select 2];
    		  // Create the new object
    		  // _obj = _objClass createVehicle _itemPos;
              _obj = createVehicle [_objClass, _itemPos, [], 0, "CAN_COLLIDE"];
              // Move object to position
              _obj enableSimulation false;
              _obj setVelocity [0, 0, 0];
              _obj allowDamage false;
              _finalDir = _objDir + _refDir;
              _obj setDir _finalDir;
              _obj setPos _itemPos; // SetPos is the command that gives the more precise position of them all
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
    		  // Update the composition objects array with the new object
    		  (_compObjects select (_forEachIndex + 1)) set [0, _obj];
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

    		  // Update the composition objects array with the new hidden objects
    		_thisCompositionData set [2, _hiddenObjects];
    		// diag_log format ["DMORBAT: compositionLoad _hiddenObjects: %1", _thisCompositionData select 2];

    		// diag_log format ["DMORBAT: compositionLoad _compObjects %2: %1", _compObjects, (_forEachIndex + 1)];
        } else {
            _return = false;
    	};

        DMORBAT_compositionsLoaded = DMORBAT_compositionsLoaded + 1;
        sleep 0.01;
    };

    // Save task settings
    if (!DMORBAT_automated) then {
        call DMORBAT_fnc_settingsSave;
    };

    if (count _compositionsData == 0) then {
        _return = false;
    };

};

// _return