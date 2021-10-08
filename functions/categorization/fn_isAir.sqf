/*
  Author: kenoxite

  Description:
	Returns wether the passed class belongs to an air unit or not.


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
private _isAir = false;
if (_class isKindOf "Air") then {
	_isAir = true;
};
_isAir
