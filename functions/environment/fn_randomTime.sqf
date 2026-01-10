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

_sunriseSunsetTime = DAKKA_customDate call BIS_fnc_sunriseSunsetTime;
_dawn = ceil (_sunriseSunsetTime select 0);
_dusk = floor (_sunriseSunsetTime select 1);

if (DAKKA_noNight) then {
    _hour = [_dawn + 1, _dusk - 1] call BIS_fnc_randomInt;
    _minutes = floor (random 59);
} else {
    private _chanceNight = if (DAKKA_Task == 1) then { 0.5 } else { 0.25 };
    private _roll = random 1;
    if (DAKKA_debug) then { diag_log format ["DAKKA: randomTime - night roll: %1", _roll] };
    if (_roll <= _chanceNight) then {
        private _hour1 = [_dusk + 1, 23.99] call BIS_fnc_randomInt;
        private _hour2 = [0, _dawn - 1] call BIS_fnc_randomInt;
        _hour = selectRandom [_hour1, _hour2];
    } else {
        _hour = [_dawn + 1, _dusk - 1] call BIS_fnc_randomInt;
    };
    _minutes = floor (random 59);
};

_newDate = DAKKA_customDate;
_newDate set [3, _hour];
_newDate set [4, _minutes];
setDate _newDate;
DAKKA_customDate = _newDate;

// Brighter nights
// Disable if already handled by kTweaks
private _ktwk = if (isNil {KTWK_BN_opt_enabled}) then {false} else {if (KTWK_BN_opt_enabled > 0) then {true} else {false}};
if (!_ktwk) exitWith { call DAKKA_fnc_brighterNights };

DAKKA_comboNoValueUpdate = true;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) lbSetCurSel (_hour);
DAKKA_comboNoValueUpdate = true;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) lbSetCurSel (_minutes);

if (DAKKA_cameraIntroPlaying) then {
    [] spawn DAKKA_fnc_cameraIntro;
};

diag_log "DAKKA: --- RANDOM TIME GENERATED ---";