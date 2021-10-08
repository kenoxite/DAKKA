/*
  Author: kenoxite

  Description:
  Tries to place a unit at a safe place


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/

params [["_unit", objNull, [objNull]], ["_location", []], ["_fly", false]];

if (isNull _unit) exitWith { getPos player };
if (!alive _unit) exitWith { getPos _unit };

private _unitClass = typeOf _unit;
private _isMan = [_unitClass] call DAKKA_fnc_isMan;

if (_isMan) then {
    private _nul = [_unit, _location, _unitClass] spawn {
        params ["_unit", "_location", "_unitClass"];
        if (count _location == 0) then { _location = getPos _unit };
        private _nearTerrObj = nearestTerrainObjects [_location, ["ROCK", "ROCKS", "BUILDING", "HOUSE"], 15, true, true];
        private _nearestBuilding = nearestBuilding _unit;
        private _nearestBuildingPos = _nearestBuilding buildingPos 1;
        if ((count _nearTerrObj) > 0) then {
            diag_log format ["DAKKA: placeUnit - Unit %1 (%2) too close to rocks or non enterable buildings. Trying to relocate it to a safer position...", _unit, _unitClass];
            private _dist = 7;
            if !(_nearestBuilding in _nearTerrObj) then {
                _dist = _unit distance (_nearTerrObj select 0);
            } else {
                if (_nearestBuilding in _nearTerrObj && {_nearestBuildingPos isEqualTo [0,0,0]}) then {
                    _dist = _unit distance _nearestBuilding;
                };
            };
            private _safePos = [_location, 0, 50, _dist, 0, 0.5, 0] call BIS_fnc_findSafePos;
            _unit setPos _safePos;
        };
    };
} else {
    // Vehicles
    private _nul = [_unit, _location, _unitClass, _fly] spawn {
        params ["_unit", "_location", "_unitClass", "_fly"];
        private _unitType = [_unitClass] call DAKKA_fnc_vehicleType;
        private _isAir = [_unitClass] call DAKKA_fnc_isAir;
        if (count _location == 0) then { _location = ASLToAGL (getPosWorld _unit) };
        private _locationASL = AGLToASL _location;
        private _safeRadius = 1;

        _unit enableSimulation false;
        _unit allowDamage false;
        {
            _x allowDamage false;
        } forEach (crew vehicle _unit);
        
        private _safePos = [_location, [ _safeRadius, -1, -1, 1, 0, true, objNull ]] call DAKKA_fnc_isFlatEmpty;
        if (count _safePos > 0) then {
            _unit setPosASL _safePos;
            _unit setVectorUp (surfaceNormal _safePos);
        } else {
            _unit setVehiclePosition [_locationASL, [], 5, ["NONE", "FLY"] select _fly];
            _unit setVectorUp (surfaceNormal _locationASL);
        };
        private _nul = _unit spawn {
                            _this enableSimulation true;
                            _this setVelocity [0, 0, 0];
                            _this setVectorUp (surfaceNormal (position _this));
                            _this allowDamage true;
                            {
                                _x allowDamage true;
                            } forEach (crew _this);
                        };
        private _inBuilding = [false, true] select (count (lineIntersectsWith [ getPosASL _unit, (getPosASL _unit) vectorAdd [0, 0, 20], _unit]) > 0);
        if (_inBuilding) exitWith { _unit setPos _location; [_unit] call DAKKA_fnc_placeUnit };

        /*
        // Reposition if objects are too close
        private _tries = 3;
        private _distMod = 50;
        private _distCheckArr = [100, 200, 300];
        private _safeRadius = 20 + (sizeOf _unitClass);
        private _safeSpotFound = false;
        private _alowedDamage = isDamageAllowed _unit;
        // _unit hideObject true;
        _unit enableSimulation false;
        _unit allowDamage false;
        _unit setVelocity [0, 0, 0];
        {
            _x enableSimulation false;
            _x allowDamage false;
            _x setVelocity [0, 0, 0];
        } forEach (crew vehicle _unit);
         for [{private _i = 0}, {_i < _tries && !_safeSpotFound}, {_i = _i + 1}] do 
        {
            private _terrainObjType = ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "WALL", "BUSSTOP", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWER LINES", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"];
            if (_unitType ==  "Car" || _unitType ==  "Truck" || _unitType ==  "Helicopter") then { _terrainObjType append ["TREE", "SMALL TREE", "FENCE"] };
            private _nearTerrObj = nearestTerrainObjects [_location, _terrainObjType, _safeRadius, false, true];
            // _nearVeh = nearestObjects [_location, ["Land", "Air"], _safeRadius];
            private _nearVeh = _unit nearEntities _safeRadius;
            if ((count _nearTerrObj) > 0 || (count _nearVeh) > 0 || (!_isAir || (_isAir && !_fly) && (surfaceIsWater _location || (getTerrainHeightASL _location) < 0.5))) then {
                diag_log format ["DAKKA: placeUnit - Vehicle %1 - %2 (%3) is dangerously close to other objects. Trying to repositioning it to a safer place...", group _unit, _unit, _unitClass];
                // Make sure vehicle has spawned in a safe spot
                // [center, minDist, maxDist, objDist, waterMode, maxGrad, shoreMode, blacklistPos, defaultPos]
                private _emptyPos = [_location, _safeRadius, (_safeRadius + _distMod), _safeRadius, 0, 0.5, 0, [], [_location, _location]] call BIS_fnc_findSafePos;
                if (count _emptyPos < 3) then {
                    // _emptyPos = (getPos _unit) findEmptyPosition [_safeRadius, 200, _unitClass];
                    // if (count _emptyPos > 0) then {
                    diag_log format ["DAKKA: placeUnit - FOUND safe position for %1 - %2 (%3): %4", group _unit, _unit, _unitClass, _emptyPos];
                    // _unit setPos _emptyPos;
                    // _unit hideObject false;
                    // _unit setVehiclePosition [_emptyPos, [], 2, "NONE"];
                    _unit setPos [_emptyPos select 0, _emptyPos select 1, 0];
                    // _unit setVectorUp (surfaceNormal (position _unit));
                    _safeSpotFound = true;
                } else {
                    diag_log format ["DAKKA: placeUnit - %1: NOT FOUND safe position for %2 - %3 (%4)", _i + 1, group _unit, _unit, _unitClass];
                    if (_isAir && !_fly) then {
                        diag_log "DAKKA: placeUnit - Unit can fly but it wasn't spawned flying. Postioning it high so it will try to fly and stay safe.";
                        _unit setPosASL [_location select 0, _location select 1, 1000];
                    };
                };
                if (!_safeSpotFound && _i == (_tries - 1)) then {
                    diag_log format ["DAKKA: placeUnit --- WARNING --- COULDN'T FIND A SAFE POSITION for %1 - %2 (%3)!",  group _unit, _unit, _unitClass];
                    // _unit hideObject false;
                    _unit setVehiclePosition [_location, [], _safeRadius + _distMod, "NONE"];
                };
            } else {
                // _unit hideObject false;
                _location = getPosASL _unit;
                _unit setVehiclePosition [_location, [], _safeRadius + _distMod, "NONE"];
            };
            // _distMod = _distMod * (_i + 1);
            _distMod = if (_i < count _distCheckArr) then { _distCheckArr select _i } else { _distMod };
            // _unit hideObject false;
            _unit enableSimulation true;
            _unit setVectorUp (surfaceNormal (position _unit));
            _unit allowDamage _alowedDamage;
            _unit setVelocity [0, 0, 0];
            {
                _x enableSimulation true;
                _x allowDamage _alowedDamage;
            } forEach (crew vehicle _unit);
        };*/
    };
};