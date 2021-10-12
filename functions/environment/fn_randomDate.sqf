#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Random date. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params [["_fullmoon", false]];

private _date = if (isNil "DAKKA_customDate") then { date } else { DAKKA_customDate };
private _newDate = _date;
private _year = [1900, 2050] call BIS_fnc_randomInt;
private _month = _newDate select 1;
private _day = _newDate select 2;

if (_fullmoon) then {
    // Random full moon date
    private _newFullMoonDate = selectRandom (_year call DAKKA_fnc_fullMoonDates);
    _year = _newFullMoonDate select 0;
    _month = _newFullMoonDate select 1;
    _day = _newFullMoonDate select 2;
} else {
    // True random date
    _month = [1, 12] call BIS_fnc_randomInt;
    private _maxDays = [    
                            [30, 31] select ((_month % 2) != 0),
                            [28, 29] select (_year call BIS_fnc_isLeapYear)
                        ] select (_month == 2);
    _day = [1, _maxDays] call BIS_fnc_randomInt;
};

_newDate set [0, _year];
_newDate set [1, _month];
_newDate set [2, _day];
setDate _newDate;
DAKKA_customDate = _newDate;

DAKKA_comboNoValueUpdate = true;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_DAY) lbSetCurSel (_year);
DAKKA_comboNoValueUpdate = true;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MONTH) lbSetCurSel (_month);
DAKKA_comboNoValueUpdate = true;
 ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_YEAR) lbSetCurSel (_day);

if (!isNil "DAKKA_cameraIntroPlaying") then {
    if (DAKKA_cameraIntroPlaying) then {
        [] spawn DAKKA_fnc_cameraIntro;
    };
};

// Brighter nights
call DAKKA_fnc_brighterNights;

diag_log "DAKKA: --- RANDOM DATE GENERATED ---";

_newDate