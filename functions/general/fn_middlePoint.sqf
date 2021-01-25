/*
  Author: kenoxite

  Description:
  Returns the middle position between two points.


  Parameter (s):
  _this select 0: _pos1
  _this select 1: _pos2

  Returns:


  Examples:

*/
params ["_pos1", "_pos2"]; 
private _pos1x = _pos1 select 0; 
private _pos1y = _pos1 select 1; 
private _pos2x = _pos2 select 0; 
private _pos2y = _pos2 select 1; 
private _pos = [(_pos1x + _pos2x)/2, (_pos1y + _pos2y)/2];  
_pos 
