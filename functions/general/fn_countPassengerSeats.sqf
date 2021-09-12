/*
  Author: kenoxite

  Description:
  Returns the number of passenger seats of a vehicle class.


  Parameter (s):
  _this select 0: 

  Returns:
  

  Examples:
  

*/

params [["_class", "", [""]]];

if (_class == "") exitWith { 0 };

private _passengerSeats = 0;
if (isNil (call compile format ["'DAKKA_seats_%1'", _class])) then {
    private _testUnit = [_class, [0,random 500,0]] call DAKKA_fnc_spawnVehicle;
    _passengerSeats = count ((fullCrew [_testUnit, "", true]) select {isNull (_x select 0)});
    private _nul = [_testUnit] spawn { [_this select 0] call DAKKA_fnc_deleteVehicle };
    missionNamespace setVariable [format ["DAKKA_seats_%1", _class], _passengerSeats];
} else {
    _passengerSeats = call compile format ["DAKKA_seats_%1", _class];
};

if (DAKKA_debug) then { diag_log format ["DAKKA: countPassengerSeats - %1 has %2 passenger seats", _class, _passengerSeats ] };

_passengerSeats