/*
  Author: kenoxite

  Description:
  Deletes a vehicle and its crew.


  Parameter (s):
  _this select 0: _grp

  Returns:


  Examples:

*/
params ["_veh"];
{ _veh deleteVehicleCrew _x } forEach crew _veh;  
deleteVehicle _veh; 
