/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private ["_fog", "_month", "_rainMonths_Beg", "_rainMonths_End", "_fogMin", "_forMed", "_fogMax"];

// Base overcast on average precipitation of current month
if ((DAKKA_rainMonths select 0) > (DAKKA_rainMonths select 1)) then {
    _rainMonths_Beg = DAKKA_rainMonths select 1;
    _rainMonths_End = DAKKA_rainMonths select 0;
} else {
    _rainMonths_Beg = DAKKA_rainMonths select 0;
    _rainMonths_End = DAKKA_rainMonths select 1;
};
_month = date select 1;
if (_month <= _rainMonths_Beg || _month >= _rainMonths_End) then {
    // Rainy months
    _fogMin = 0;
    _forMed = DAKKA_fogValue select 0;
    _fogMax = ((DAKKA_fogValue select 1) / 2) min 1;
} else {
    // Dry months
    _fogMin = 0;
    _forMed = DAKKA_fogValue select 0;
    _fogMax = ((DAKKA_fogValue select 1) / 3) min 1;
};

_fog = random [_fogMin, _forMed, _fogMax];

if (DAKKA_debug) then { diag_log format ["DAKKA: setFog _fog: %1 [%2, %3, %4]", _fog, _fogMin, _forMed, _fogMax] };

_fog