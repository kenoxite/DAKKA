/*
  Author: kenoxite

  Description:
  Returns the type of class based on what type of vehicle it is. 


  Parameter (s):
  _this select 0: _class

  Returns:


  Examples:

*/
params ["_class"];
private ["_veh", "_return"];
_return = "Inf";
if (_class isKindOf "LandVehicle") then { _return = "Land" };
if (_class isKindOf "Air") then { _return = "Air" };
if (_class isKindOf "Ship") then { _return = "Ship" };
_return
