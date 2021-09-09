/*
  Author: kenoxite

  Description:
  Searchs for an element in the first nested array and returns its index.


  Parameter (s):
  _this select 0: ARRAY - Array where it will be looked for
  _this select 1: ANY - Element to look for

  Returns:
  NUMBER - Index in the first nested array. Returns -1 if nothing is found

  Examples:
  _arr = [[1, "First element in the nested array"], [2, "Second element in the nested array"]];
  result = [_arr, 2] call DMORBAT_fnc_findFirstNested; // Returns: 1

*/
private ["_ele", "_a", "_i", "_r", "_a1"];
_a = _this select 0;
_ele = _this select 1;
_r=-1;
_i = 0; while { _i < count _a } do {
	_a1 = _a select _i;
	if (_ele in _a1) exitWith { _r = _i };
	_i = _i + 1;
};
_r
