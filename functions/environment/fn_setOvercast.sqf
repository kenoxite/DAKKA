/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private ["_overcast", "_overcastMin", "_overcastMed", "_overcastMax", "_month", "_rainMonths_Start", "_rainMonths_End", "_rainMonthsArr", "_rainDry", "_rainWet", "_badWeatherChance"];

// Base overcast on average precipitation of current month
_rainMonths_Start = DAKKA_rainMonths select 0;
_rainMonths_End = DAKKA_rainMonths select 1;

_rainMonthsArr = [];
for [{private _i = 1}, {_i <= 12}, {_i = _i + 1}] do {
    if (_rainMonths_Start < _rainMonths_End) then {
        if (_i >= _rainMonths_Start && _i <= _rainMonths_End) then {
            _rainMonthsArr pushBack _i;
        };
    } else {
        if (_i <= _rainMonths_End || (_i >= _rainMonths_Start && _i <= 12)) then {
            _rainMonthsArr pushBack _i;
        };
    };
};

_month = date select 1;
if (DAKKA_debug) then { diag_log format ["DAKKA: setOvercast - _rainMonthsArr: %1, month: %2", _rainMonthsArr, _month] };
_rainDry = DAKKA_rain select 0;
_rainWet = DAKKA_rain select 1;
_badWeatherChance = if (_month in _rainMonthsArr) then { 0.5 + (floor (random 0.5)) min 1 } else { 0.1 + (floor (random 0.9)) min 1 };
if (_month in _rainMonthsArr) then {
    // Rainy months
    _overcastMin = 0;
    _overcastMed = ((DAKKA_overcast / 3) + ((_rainWet / 6) min 0.5) + floor(random (_rainWet / 6))) min 0.9;
    _overcastMax = if (_badWeatherChance >= 0.9) then { 1 } else { floor random (0.5) };
} else {
    // Dry months
    _overcastMin = 0;
    _overcastMed = ((DAKKA_overcast / 4) + ((_rainDry / 4) min 0.5) + floor(random 0.5)) min 0.7;
    // _overcastMax = ((DAKKA_overcast / 4) + (_rainDry / 2) + floor(random 0.5)) min 0.9;
    _overcastMax = if (_badWeatherChance >= 0.9) then { 1 } else { floor random (DAKKA_overcast / 2) };
};

_overcast = random [_overcastMin, _overcastMed, _overcastMax];

if (DAKKA_debug) then { diag_log format ["DAKKA: setOvercast _overcast: %1 [%2, %3, %4]", _overcast, _overcastMin, _overcastMed, _overcastMax] };

_overcast