/*
  Author: kenoxite

  Description:
  Deletes all units in a group.


  Parameter (s):
  _this select 0: _grp

  Returns:


  Examples:

*/
params ["_grp"];
if (isNull _grp) exitWith { deleteGroup _grp; false };
{  
 // if (DAKKA_debug) then { diag_log format ["DAKKA: 1 deleteGroup deleting:%1", _x] };       
  private _veh = vehicle _x;       
  if (_veh != _x) then {           
    [_veh] call DAKKA_fnc_deleteVehicle;
  } else {             
    [_x] call DAKKA_fnc_deleteMan;     
  }; 
} forEach units _grp;
deleteGroup _grp; 
