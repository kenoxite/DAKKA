/*
  Author: kenoxite

  Description:
  Makes nights brighter


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

// if (true) exitWith {false};

private _currentAp = apertureParams select 3;

if ([DAKKA_customDate] call DAKKA_fnc_isNight) then {
    private _ap = (_currentAp * 0.7) max 4;
    setAperture _ap; 
    setApertureNew [_ap*0.4, _ap, _ap/0.55, 0.8];
} else {
    setAperture 0; 
    setApertureNew [0, 0, 0, 0];
};