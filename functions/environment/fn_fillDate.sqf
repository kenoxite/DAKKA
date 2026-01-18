#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params [["_action", ["all"]]];
private _currentDate = DAKKA_customDate;
private _currentDay = _currentDate select 2;
private _currentMonth = _currentDate select 1;
private _currentYear = _currentDate select 0;
private _currentHour = _currentDate select 3;
private _currentMinutes = _currentDate select 4;

if ("all" in _action || "year" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_YEAR);
    lbClear _ctrl;
    for [{private _i = 1900}, {_i <= 2100}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd str _i; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentYear == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "month" in _action) then {
    private _monthNames = [
        "Jan.",
        "Feb.",
        "Mar.",
        "Apr.",
        "May",
        "Jun.",
        "Jul.",
        "Aug.",
        "Sep.",
        "Oct.",
        "Nov.",
        "Dec."
    ];
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MONTH);
    lbClear _ctrl;
    for [{private _i = 1}, {_i <= 12}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd (_monthNames select (_i - 1));
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentMonth == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "day" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_DAY);
    lbClear _ctrl;
    private _maxDays = [    
                            [30, 31] select ((_currentMonth % 2) != 0),
                            [28, 29] select (_currentYear call BIS_fnc_isLeapYear)
                        ] select (_currentMonth == 2);
    // Find moon phases days
    private _maxMoon = 0;
    private _fullMoonDay = 1;
    private _minMoon = 1;
    private _newMoonDay = 1;
    for [{private _i = 1}, {_i <= _maxDays}, {_i = _i + 1}] do 
    {
        private _tempDate = [_currentYear, _currentMonth, _i, _currentHour, _currentMinutes];
        private _moonPhase = moonPhase _tempDate;
        if (_moonPhase > _maxMoon) then { _maxMoon = _moonPhase; _fullMoonDay = _i };
        if (_moonPhase < _minMoon) then { _minMoon = _moonPhase; _newMoonDay = _i };
    };
    private _moonDays = [_newMoonDay,_fullMoonDay];

    // Fill combo box
    for [{private _i = 1}, {_i <= _maxDays}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd str _i; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentDay == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };

        private _tempDate = [_currentYear, _currentMonth, _i, _currentHour, _currentMinutes];
        private _moonPhase = moonPhase _tempDate;
        private _moonPictures = ["\a3\3den\data\attributes\date\moon_new_ca.paa", "\a3\3den\data\attributes\date\moon_full_ca.paa"];
        // private _moonPictures = ["\a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa", "\a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa"];
        private _moon = [
                            "",
                            [_moonPictures select 0, _moonPictures select 1] select (_i == _moonDays select 1)
                        ] select (_i in _moonDays);
        // if (_i in _moonDays) then { systemchat format ["%1: %2 %3", _i, ["new","full"] select (_i == _moonDays select 1), [_moonPictures select 0, _moonPictures select 1] select (_i == _moonDays select 1)] };
        _ctrl lbSetPictureRight  [_ctrlIndex, _moon];
        _ctrl lbSetPictureRightColor [_ctrlIndex, [1, 1, 1, 1]];
    };
};

if ("all" in _action || "hour" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR);
    lbClear _ctrl;
    for [{private _i = 0}, {_i <= 23}, {_i = _i + 1}] do 
    {
        // Format time display
        private _fHour = if (_i < 10) then {
            format ["0%1", _i];
        } else { 
            str _i;
        };
        private _ctrlIndex = _ctrl lbAdd _fHour; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentHour == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "minutes" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES);
    lbClear _ctrl;
    for [{private _i = 0}, {_i <= 59}, {_i = _i + 1}] do 
    {
        private _fMinutes = if (_i < 10) then {
            format ["0%1", _i];
        }else{
            str _i;
        };
        private _ctrlIndex = _ctrl lbAdd _fMinutes; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentMinutes == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};