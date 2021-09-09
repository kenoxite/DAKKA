/*
  Author: kenoxite

  Description:
  Tries to unstick and re-enable a stuck AI unit. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_target", "_caller", "_actionId", ["_arguments", ""]];
private _veh = vehicle _target;
private _isMan = [_veh] call DMORBAT_fnc_isMan;
if (!_isMan) then {
    // Try to find a nearby safe position if it's a vehicle
    _veh setPos ([getPos _veh, 0, 50, 5, 1] call BIS_fnc_findSafePos);
    _veh setVectorUp (surfaceNormal (position _veh));
} else {
    // Clone if it's infantry
    private _clone = [_target, "", true, true, false] call DMORBAT_fnc_cloneUnit;
    if (isNull _clone) exitWith {
        diag_log format ["DMORBAT: --- ERROR --- unstickUnit The clone for %1 could not be created. Repositioning unit instead...", _target];
        _target setPos ([getPos _target, 0, 50, 5, 1] call BIS_fnc_findSafePos);
        false
    };

    private _behaviour = behaviour _target;
    private _combatMode = combatMode _target;
    private _speedMode = speedMode _target;
    private _damage = damage _target;
    private _team = assignedTeam _target;

    private _grp = group _target;
    private _groupIndex = (_target call DMORBAT_fnc_getUnitPositionId) - 1;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: untstickUnit _groupIndex %1", _groupIndex] }; 
    private _isLeader = false;
    if ((leader _grp) == _target) then {
        _isLeader = true;
    };
    private _waypoints = waypoints _target;
    _target removeAction _actionId;
    deleteVehicle _target;
    _clone joinAsSilent [_grp, _groupIndex];
    if (_isLeader) then {
        _grp selectLeader _clone;
        // {
        //     private _wp = _grp addWaypoint [waypointPosition _x, waypointCompletionRadius _x, _forEachIndex, waypointName _x];
        // } forEach _waypoints;
    };

    _clone setBehaviour _behaviour;
    _clone setCombatMode _combatMode;
    _clone setSpeedMode _speedMode;
    _clone assignTeam _team;
    _clone setDamage _damage;

    // Reapply actions
    private _actionID = _clone addAction 
    [ 
        "Unstick Unit", 
        { 
            _this spawn DMORBAT_fnc_unstickUnit;  
        }, 
        nil, 
        20, 
        false, 
        true, 
        "_this == _target", 
        "", 
        -1, 
        true, 
        "", 
        ""  
    ]; 
    _clone addEventHandler ["killed", format ["(_this select 0) removeAction %1;", _actionID]];
    
    [_clone, [], 2] call DMORBAT_fnc_prepareUnit;
};

diag_log format ["DMORBAT: %1 is now unstuck", _target]; 

true