/*
  Author: kenoxite

  Description:
  Sets a new waypoint for the group. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  The new waypoint

  Examples:

*/

params ["_grp", "_pos", ["_radius", 0], ["_index", -1], ["_name", ""], ["_type","MOVE"], ["_beh", "AWARE"], ["_speed", "NORMAL"], ["_form", "WEDGE"], ["_combatMode", "YELLOW"], ["_completionRadius", 30], ["_description", ""], ["_delete", true], ["_setCurrent", false], ["_timeout", [0,0,0]], ["_statements", ["true", ""]]]; 

if (typeName _grp != "GROUP") exitWith { diag_log format ["DMORBAT: --- ERROR --- groupWp - %1 is not a group! Aborting assignment of waypoint...", _grp]; [group _grp, 0] };

if (_delete) then { 
	{
		deleteWaypoint [_grp, 0];
	} forEach (waypoints _grp);
}; 
private _wpParams = [_pos, _radius]; 
_wpParams pushBack (if (_index >= 0) then { _index } else { count (waypoints _grp) }); 
if(_name != "") then { _wpParams pushBack _name }; 
private _wp = _grp addWaypoint _wpParams; 
_wp setWaypointType _type; 
if (_beh != "") then { _wp setWaypointBehaviour _beh; }; 
if (_speed != "" )then { _wp setWaypointSpeed _speed; }; 
if (_form != "") then { _wp setWaypointFormation _form; }; 
if (_combatMode != "") then { _wp setWaypointCombatMode _combatMode; }; 
_wp setWaypointCompletionRadius _completionRadius; 
_wp setWaypointDescription _description; 
_wp setWaypointTimeout _timeout; 
_wp setWaypointStatements _statements; 
if (_setCurrent) then { _grp setCurrentWaypoint _wp; }; 

_wp 