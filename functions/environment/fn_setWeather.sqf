#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the weather. 
 

  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_weather", ["_updateSettings", true], ["_rain", true]];
// private ["_overcast", "_fog", "_rain", "_lightnings", "_wind", "_windStr", "_gusts", "_waves"];
private ["_overcast", "_fog"];

cutText ["Updating weather...", "PLAIN", 999];

_overcast = _weather select 0;
_fog = _weather select 1;
// _rain = _weather select 2;
// _lightnings = _weather select 3;
// _wind = _weather select 4;
// _windStr = _weather select 5;
// _gusts = _weather select 6;
// _waves = _weather select 7;

// Overcast
skipTime -24;
86400 setOvercast _overcast;
skipTime 24;
0 = [] spawn {
    sleep 0.1;
    simulWeatherSync;
};

if (!_rain) then {
    0 setRain 0;
};

// time setFog [fogValue <0..1>, fogDecay <-1..1>, fogBase <-5000..5000>] 
0 setFog [_fog, DAKKA_fogDecay, DAKKA_fogBase];

//     0 setRain _rain;
//     0 setLightnings _lightnings;
//     setWind [_wind select 0, _wind select 1];
//     0 setWindStr _windStr;
//     // 0 setWindForce _windForce;
//     0 setGusts _gusts;
//     0 setWaves _waves;


if (_updateSettings) then {
    // DAKKA_customWeather = [_overcast, _fog, _rain, _lightnings, _wind, _windStr, _gusts, _waves];
    DAKKA_customWeather = [_overcast, _fog];
    // Save settings
    if (!DAKKA_automated) then { ["Weather"] call DAKKA_fnc_globalSettingsSave };

    diag_log "DAKKA: --- WEATHER SET ---";
};

sleep 1;
cutText ["", "PLAIN", 1];