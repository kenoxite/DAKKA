#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Random wheater. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

// private ["_weather", "_overcast", "_fog", "_rain", "_lightnings", "_wind", "_windStr", "_gusts", "_waves"];
private ["_weather", "_overcast", "_fog"];

cutText ["Updating weather...", "PLAIN", 999];

// cutText ["Updating weather...", "BLACK IN", 999];

_overcast = call DAKKA_fnc_setOvercast;
_fog = call DAKKA_fnc_setFog;

// _rain = random [0, 0.3, 1];
// _lightnings = random [0, 0.3, 1];
// _wind = [random [0, 5, 30], random [0, 5, 30]];
// _windStr = random [0, 0.3, 1];
// _gusts = random [0, 0.3, 1];
// _waves = random [0, 0.3, 1];

// _weather = [_overcast, _fog, _rain, _lightnings, _wind, _windStr, _gusts, _waves];
_weather = [_overcast, _fog];

[_weather, false] spawn DAKKA_fnc_setWeather;

diag_log "DAKKA: --- RANDOM WEATHER GENERATED ---";
