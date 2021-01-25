/*
  Author: kenoxite

  Description:
  Returns an array with the real dimensions of the passed object.


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/
params ["_obj"];
private ["_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight"];
_bbr = 0 boundingBoxReal _obj;
_p1 = _bbr select 0;
_p2 = _bbr select 1;
_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
_maxLength = abs ((_p2 select 1) - (_p1 select 1));
_maxHeight = abs ((_p2 select 2) - (_p1 select 2));	

[_maxWidth, _maxLength, _maxHeight]
