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

params [["_amount", -1], ["_location", []], ["_distance", 100], ["_save", false]];

if (_amount == 0) exitWith { false };

diag_log format ["DAKKA: compositionLoad - Loading %1 compositions...", if (_amount < 0) then {"all"} else { _amount }];

DAKKA_compositionsLoaded = 0;
DAKKA_compLoadedLocs = [];

_nul = _this spawn {
    params [["_amount", -1], ["_location", []], ["_distance", 100], ["_save", false]];
    if (DAKKA_debug) then { diag_log format ["DAKKA: _amount: %1, _location: %2, _distance: %3", _amount, _location, _distance] };
    private ["_taskData", "_worldCompositionsData", "_compositionsData", "_thisCompositionData", "_hiddenObjects", "_compObjects", "_ref", "_obj", "_objClass", "_relPos", "_objDir", "_keepHorizontal", "_itemPos", "_aligned", "_refPos", "_refDir", "_nearTerrObj", "_hideDist", "_return", "_rePosOriginal"];

    _return = true;
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;

    private _trimmedCompositionsData = [];
    // Check for distance if not all compositions want to be spawned
    if (_amount >= 0) then {
        for "_i" from 0 to (count _compositionsData)-1 do
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
    } else {
        _trimmedCompositionsData = _compositionsData;
    };
    {
        // if (DAKKA_debug) then { diag_log format ["DAKKA: _trimmedCompositionsData - %1: %2", _x select 0, _x select 1] };
    } forEach _trimmedCompositionsData;


    _aligned = true;    // Align to surface

    private _compRadius = 0;
    for "_i" from 0 to (count _trimmedCompositionsData)-1 do
    {
    	_thisCompositionData = _trimmedCompositionsData select _i;
    	// if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _thisCompositionData: %1", _thisCompositionData] };
        diag_log format ["DAKKA: compositionLoad - Loading composition: %1", _thisCompositionData select 0 ];
    	_compObjects = _thisCompositionData select 1;
    	_hiddenObjects = [];
    	_ref = (_compObjects select 0) select 0;
        if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _ref 1: %1", _ref ] };

    	// Only load if composition does not exist
        if (isNil "_ref") then { _ref = objNull };
        if (typeName _ref == "STRING") then { _ref = objNull };
    	if (isNull _ref) then {
    		// Load composition objects
    		_refArr = _compObjects select 0;
            _refPos = _refArr select 1;
            if (_amount > 0) then {
                // Place the next compositions around the first one if the amount of compositions to spawn isn't all nor just one
                if (_i > 0) then {
                    private _newRefPos = [[[[_rePosOriginal, 500 + _compRadius]],[[_rePosOriginal, 200 + _compRadius, ""]], {}] call BIS_fnc_randomPos, [ 1, -1, 0.15, 100, 0, true, objNull ]] call DAKKA_fnc_isFlatEmpty;
                    if (count _newRefPos == 0) then { _newRefPos = [[[_rePosOriginal, 250 + _compRadius]],[[_rePosOriginal, 100 + _compRadius], "water"], {!isOnRoad _this && (aCos ([0,0,1] vectorCos (surfaceNormal _this)) <= 0.25) }] call BIS_fnc_randomPos };
                    if (count _newRefPos < 3) then { _newRefPos = [[[_rePosOriginal, 200 + _compRadius]],[], {}] call BIS_fnc_randomPos; };
                    if (count _newRefPos < 3) then { _newRefPos = [(_rePosOriginal select 0) + floor(random 250 + _compRadius), (_rePosOriginal select 1) + floor(random 250 + _compRadius), _refPos select 2]; };
                    if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _newRefPos: %1", _newRefPos ] };
                    _refPos = +_newRefPos;
                } else {
                    _rePosOriginal = +_refPos;
                    private _newRefPos = [_rePosOriginal, [ 1, -1, 0.15, 100, 0, true, objNull ]] call DAKKA_fnc_isFlatEmpty;
                    if (count _newRefPos == 0) then { _newRefPos = [[[_rePosOriginal, 250]],[[_rePosOriginal, 100], "water"], {!isOnRoad _this && (aCos ([0,0,1] vectorCos (surfaceNormal _this)) <= 0.25) }] call BIS_fnc_randomPos };
                    if (count _newRefPos < 3) then { _newRefPos = [[[_rePosOriginal, 100]],[], {}] call BIS_fnc_randomPos; };
                    if (count _newRefPos < 3) then { _newRefPos = [(_rePosOriginal select 0) + floor(random 50), (_rePosOriginal select 1) + floor(random 50), _refPos select 2]; };
                    _refPos = +_newRefPos;
                };
            };
            DAKKA_compLoadedLocs pushBack _refPos;
            
            _mrkr = format ["DAKKA_mrkr_Task%1_comp_%2", DAKKA_Task, _i + 1];
            _mrkr setMarkerPos _refPos;

    		_ref = "Flag_BI_F" createVehicle _refPos;
            DAKKA_spawnCompRefs pushBack _ref;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _ref 2: %1", _ref ] };
    		// Update the composition objects array with the new object
    		(_compObjects select 0) set [0, _ref];
            _refDir = _refArr select 2;
            // Place the next compositions around the first one if the amount of compositions to spawn isn't all nor just one
            if (_amount > 1 && _i > 0) then {
                private _relDir = _ref getRelDir _refPos;
                private _compDir = (_relDir + 180) mod 360;
                _refDir = _compDir;
            };
    		_ref setPos _refPos;
    		_ref hideObject true;
            // _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", format["DAKKA_mrkr_comp%1", random 999], _refPos, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 1, "Composition"] call BIS_fnc_stringToMarker;
    		private _hideDist = 2;
            _compRadius = 0;
            for "_i" from 1 to (count _compObjects)-1 do
            {
                private _objData = _compObjects select _i;
                private _objClass = _objData select 1;
                private _relPos = _objData select 2;
                private _objDir = _objData select 3;
                private _keepHorizontal = _objData select 4;
                private _vectorDir = if (count _objData > 5) then {_objData select 5} else {[]};
                private _vectorUp = if (count _objData > 6) then {_objData select 6} else {[]};
                private _simple = if (count _objData > 7) then {_objData select 7} else {false};
                private _pos = _ref modelToWorld _relPos;
                private _itemPos = [_pos select 0, _pos select 1, _relPos select 2];
                // Create the new object
                private _obj = [createVehicle [_objClass, [random 100,random 100,10000], [], 0, "CAN_COLLIDE"], createSimpleObject [_objClass, [random 100,random 100,10000], false]] select (_simple && !(_objClass isKindOf "LandVehicle"));
                // Move object to position
                _obj allowDamage false;
                _obj setDamage 0;
                _obj enableSimulation false;
                _obj setVelocity [0, 0, 0];
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

                // Update the composition objects array with the new object
                _objData set [0, _obj];
                // diag_log format ["DAKKA: compositionLoad: %1: %2", _i, _objdata];
                // sleep 0.0001;
                if ((_obj distance2D _ref) > _compRadius) then { _compRadius = _obj distance2D _ref };
            };

            // Rotate reference and wait for rotation to finish
            _ref setDir _refDir;
            sleep ((count _compObjects) * 0.001);

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
                sleep 0.0001;
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
                sleep 0.0001;
            };

            // Enable simulation
            for "_i" from 1 to (count _compObjects)-1 do
            { 
                private _objData = _compObjects select _i;
                private _obj = _objData select 0;
                _obj enableSimulation true;
                _obj allowDamage true;
                _obj setDamage 0;
                _obj setVelocity [0, 0, 0];
            };

            // {
            //     diag_log format ["DAKKA: compositionLoad - %1: %2", _forEachIndex , _x];
            // } forEach (_thisCompositionData select 1);

    		  // Update the composition objects array with the new hidden objects
    		_thisCompositionData set [2, _hiddenObjects];
    		// if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _hiddenObjects: %1", _thisCompositionData select 2] };

    		// if (DAKKA_debug) then { diag_log format ["DAKKA: compositionLoad _compObjects %2: %1", _compObjects, (_forEachIndex + 1)] };
        } else {
            _return = false;
    	};
        sleep 0.001;

        DAKKA_compositionsLoaded = DAKKA_compositionsLoaded + 1;
    };

    // Save task settings
    if (_save) then {
        call DAKKA_fnc_settingsSave;
    };

    if (count _compositionsData == 0) then {
        _return = false;
    };

    diag_log format ["DAKKA: compositionLoad - %1 compositions were loaded...", DAKKA_compositionsLoaded];

    _return
};
