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

private _sunriseSunsetTime = _date call BIS_fnc_sunriseSunsetTime;
private _dawn = ceil (_sunriseSunsetTime select 0);
private _dusk = floor (_sunriseSunsetTime select 1);
private _isNight = (daytime <= _dawn || daytime >= _dusk);

_isNight