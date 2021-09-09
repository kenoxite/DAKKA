#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Random time. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private ["_randomTime", "_sunriseSunsetTime", "_dawn", "_dusk", "_hour", "_minutes", "_newDate"];

_sunriseSunsetTime = DMORBAT_customDate call BIS_fnc_sunriseSunsetTime;
_dawn = ceil (_sunriseSunsetTime select 0);
_dusk = floor (_sunriseSunsetTime select 1);

if (DMORBAT_noNight) then {
    _hour = floor ([_dawn + 1, _dusk - 1] call BIS_fnc_randomInt);
    _minutes = floor (random 59);
} else {
    private _chanceNight = if (DMORBAT_Task == 1) then { 0.7 } else { 0.3 };
    if (floor (random 1) <= _chanceNight) then {
        // _hour = floor (random 23);
        _hour = floor ([0, _dusk] call BIS_fnc_randomInt);
    } else {
        _hour = floor ([_dawn + 1, _dusk - 1] call BIS_fnc_randomInt);
    };
    _minutes = floor (random 59);
};

_newDate = DMORBAT_customDate;
_newDate set [3, _hour];
_newDate set [4, _minutes];
setDate _newDate;

// skipTime _randomTime;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) lbSetCurSel (_hour);
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) lbSetCurSel (_minutes);

diag_log "DMORBAT: --- RANDOM TIME GENERATED ---";