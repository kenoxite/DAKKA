/*
  Author: kenoxite

  Description:
	Returns wether the passed class belongs to an infantry unit or not.


  Parameter (s):
  _this select 0: _class

  Returns:
	BOOL with result of check

  Examples:

*/
params [["_class", "", ["", objNull]]];
if (typeName _class == "OBJECT") then {
	_class = typeOf _class;
};
private _isMan = false;
if (_class isKindOf "CAManBase") then {
	_isMan = true;
};
_isMan
