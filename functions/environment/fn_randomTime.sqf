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

private ["_randomTime", "_sunriseSunsetTime", "_dawn", "_dusk", "_hour", "_minutes"];

if (DMORBAT_noNight || DMORBAT_automated) then {
    _sunriseSunsetTime = DMORBAT_customDate call BIS_fnc_sunriseSunsetTime;
    _dawn = ceil (_sunriseSunsetTime select 0);
    _dusk = floor (_sunriseSunsetTime select 1);
    _randomTime = [_dawn, _dusk - 1] call BIS_fnc_randomInt;
    _hour = floor _randomTime;
    _minutes = floor (random 59);
} else {
    // _randomTime = random 24;
    _hour = floor (random 23);
    _minutes = floor (random 59);
};

// skipTime _randomTime;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) lbSetCurSel (_hour);
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) lbSetCurSel (_minutes);

diag_log "DMORBAT: --- RANDOM TIME GENERATED ---";