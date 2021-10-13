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
private _seatsVarStr = format ["DAKKA_seats_%1", _class];
private _seatsVar = missionNamespace getVariable _seatsVarStr;
if (isNil "_seatsVar") then {
    private _testUnit = [_class, [0,random 500,0]] call DAKKA_fnc_spawnVehicle;
    _passengerSeats = count ((fullCrew [_testUnit, "", true]) select {isNull (_x select 0)});
    private _nul = [_testUnit] spawn { [_this select 0] call DAKKA_fnc_deleteVehicle };
    missionNamespace setVariable [_seatsVarStr, _passengerSeats];
} else {
    _passengerSeats = _seatsVar;
};

if (DAKKA_debug) then { diag_log format ["DAKKA: countPassengerSeats - %1 has %2 passenger seats", _class, _passengerSeats ] };

_passengerSeats