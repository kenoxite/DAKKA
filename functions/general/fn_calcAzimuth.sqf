/*
  Author: kenoxite

  Description:
  Calculate Azimuth between 2 (objects) positions.


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/
params ["_posA", "_posB"];
private ["_Cx", "_Cy", "_Kx", "_Ky", "_dx", "_dy", "_Azimuth"];
_Cx = _posA select 0;
_Cy = _posA select 1;
_Kx = _posB select 0;
_Ky = _posB select 1;
_dx = -(_Cx - _Kx);
_dy = -(_Cy - _Ky);
// Result is: -180 < Azimuth <= 180
_Azimuth = round (_dx atan2 _dy);
// adjust to compass angle: 0 <= Azimuth < 360
if (_Azimuth < 0) then
{
	_Azimuth = 360 + _Azimuth;
};

_Azimuth; // Result
