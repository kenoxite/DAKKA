/*
  Author: kenoxite

  Description:
  Returns wether is night time or not


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_date"];

// private _sunriseSunsetTime = _date call BIS_fnc_sunriseSunsetTime;
// private _dawn = _sunriseSunsetTime select 0;
// private _dusk = _sunriseSunsetTime select 1;
// private _isNight = (daytime < (_dawn) || daytime > (_dusk));
// _isNight

// private _sunElev = call DAKKA_fnc_sunElev;
// private _darkAngle = [-12,-1.5] select ((_date select 3) > 12);
// [false, true] select (_sunElev < _darkAngle)

(apertureParams select 0) <= 5.1