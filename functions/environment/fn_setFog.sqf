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
if ((DMORBAT_rainMonths select 0) > (DMORBAT_rainMonths select 1)) then {
    _rainMonths_Beg = DMORBAT_rainMonths select 1;
    _rainMonths_End = DMORBAT_rainMonths select 0;
} else {
    _rainMonths_Beg = DMORBAT_rainMonths select 0;
    _rainMonths_End = DMORBAT_rainMonths select 1;
};
_month = date select 1;
if (_month <= _rainMonths_Beg || _month >= _rainMonths_End) then {
    // Rainy months
    _fogMin = 0;
    _forMed = DMORBAT_fogValue select 0;
    _fogMax = ((DMORBAT_fogValue select 1) / 2) min 1;
} else {
    // Dry months
    _fogMin = 0;
    _forMed = DMORBAT_fogValue select 0;
    _fogMax = ((DMORBAT_fogValue select 1) / 3) min 1;
};

_fog = random [_fogMin, _forMed, _fogMax];

if (DMORBAT_debug) then { diag_log format ["DMORBAT: setFog _fog: %1 [%2, %3, %4]", _fog, _fogMin, _forMed, _fogMax] };

_fog