/*
  Author: kenoxite

  Description:
  Creates a series of waypoints for patrolling an area.
  Adapted from BIS function to make use of BIS_fnc_findSafePos when choosing waypoints.


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_grp", "_pos", "_maxDist", ["_statements", ["true", ""]], ["_blacklist", []], ["_teleportToNode", false], ["_changeBehaviour", true]];

private ["_angle", "_isMan", "_isAir", "_nodesAmount", "_dir", "_firstWpPos"];
_isMan = [vehicle leader _grp] call DMORBAT_fnc_isMan;
_isAir = [vehicle leader _grp] call DMORBAT_fnc_isAir;
_nodesAmount = 4 + (floor (random 3));
_angle = round (360 / _nodesAmount);
_dir = round (random 360);
for [{private _i = 0}, {_i < _nodesAmount}, {_i = _i + 1}] do
{ 
  private ["_wp", "_newPos"]; 
    private _nodeDist = _maxDist + ((random _maxDist) max (_maxDist / 2));
    private _newDir = _dir + (_angle * _i);
    _newPos = [_pos, _nodeDist, _newDir] call BIS_fnc_relPos;
    if ((!_isMan && !_isAir) || (!_isAir && surfaceIsWater _newPos)) then {
        _newPos = [_newPos, 50, _maxDist, 5, 0, 0.5, 0, _blacklist] call BIS_fnc_findSafePos;
    };

    if (_teleportToNode && _i == 0) then {
        // Only teleport if the node is far away from the player's spawning position
        if ((_newPos distance (vehicle p1)) > 200) then {
            diag_log format ["DMORBAT: Teleporting patrolling group %1 to first node", _grp];
            {
                private _veh = vehicle _x;
                if (_x == effectiveCommander _veh) then {
                    if (!_isMan) then {
                        _veh setVehiclePosition [_newPos, [], 50, if (_isAir) then { "FLY" } else { "NONE" }];
                    } else {
                        _veh setPos ([[[_newPos, 100]], [[_newPos, 50]]] call BIS_fnc_randomPos); 
                        _grp move _newPos;
                    };
                };
            } forEach (units _grp);
        } else {
            diag_log format ["DMORBAT: Patrolling group %1 not teleported to node. Too close to player spawn", _grp];
        };
    };

    _wp = _grp addWaypoint [_newPos, 0]; 
    _wp setWaypointType "MOVE"; 
    _wp setWaypointCompletionRadius (if (!_isMan) then { 50 } else { 20 }); 
    _wp setWaypointTimeout [5, 10, 20]; 
    _wp setWaypointStatements _statements;

    if (_i == 0) then 
    { 
        _firstWpPos = _newPos;
        _wp setWaypointSpeed "LIMITED"; 
        _wp setWaypointFormation "STAG COLUMN"; 

        if (_changeBehaviour) then {
            if (_isMan) then {
                _grp setBehaviour "SAFE";
            } else {
                if ([DMORBAT_customDate] call DMORBAT_fnc_isNight) then { 
                    _grp setBehaviour "AWARE";
                } else {
                    _grp setBehaviour "COMBAT";
                };
            };
        };
        _grp setCombatMode "RED";

        if (_isAir) then {
            // (vehicle leader _grp) flyInHeight 100;
        };
    }; 
}; 
private ["_wp", "_cyclePos"]; 
_wp = _grp addWaypoint [[[[_firstWpPos, 50]], []] call BIS_fnc_randomPos , 0]; 
_wp setWaypointType "CYCLE"; 
_wp setWaypointCompletionRadius (if (!_isMan) then { 50 } else { 20 }); 

true 