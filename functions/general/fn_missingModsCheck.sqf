/*
  Author: kenoxite

  Description:
  Returns whether the mod of the item or object is present or not.


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/
params [["_class", "", ["", objNull]]];
private ["_modPresent", "_mod", "_classFilter"];

if (typeName _class == "OBJECT") then {
	_class = typeOf _class;
};

_modPresent = false;
_classFilter = "CfgVehicles";
// if (_class isKindOf "AllVehicles") then {
// 	_classFilter = "CfgVehicles";
// };

{
	_mod = configSourceMod _x;
	if (DAKKA_debug) then { diag_log format ["DAKKA: missingModsCheck _mod: %1", _mod] };
	if (_mod == "") exitWith { diag_log format ["DAKKA: missingModsCheck --- OK --- Class ""%1"" is from base game", _class]; _modPresent = true; };
	if ((modParams [_mod, ["active"]]) select 0) exitWith {
		_modPresent = true;
	};
} forEach ("(configName _x) == _class" configClasses (configFile >> _classFilter));

if (DAKKA_debug) then { diag_log format ["DAKKA: missingModsCheck class ""%1"" _modPresent: %2", _class, _modPresent] };

[_modPresent, _mod]