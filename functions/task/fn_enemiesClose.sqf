/*
  Author: kenoxite

  Description:
  Checks if there's enemies within the given radius. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  The new waypoint

  Examples:

*/

params["_grp", "_dist"]; 
private _return = false; 
private _enemy = (leader _grp) findNearestEnemy (getPos leader _grp); 
if (!isNull _enemy) then { 
  if (((vehicle leader _grp) distance (vehicle _enemy)) <= _dist) then { 
    _return = true; 
    diag_log format ["DMORBAT: Enemies too close to %1!", _grp];  
  }; 
}; 

_return 