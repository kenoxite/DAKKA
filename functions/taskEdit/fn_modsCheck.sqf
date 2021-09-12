/*
  Author: kenoxite

  Description:
  Returns the mods used by the class and adds it to the global known mods array


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/

params ["_unitClass"];
private ["_knownMods", "_mod", "_modIndex"];

_knownMods = [DAKKA_settings, "Known mods"] call BIS_fnc_getFromPairs;
_mod = configSourceMod (configFile >> "CfgVehicles" >> _unitClass);
if (isNil "_mod") then { _mod = "" };
_modIndex = _knownMods find _mod;
if (_modIndex >= 0) then {
    _mod = _modIndex;
} else {
    _knownMods pushBack _mod;
    _mod = (count _knownMods) - 1;
    // Save updated known mods list
    ["Known mods"] call DAKKA_fnc_globalSettingsSave;
};
// if (DAKKA_debug) then { diag_log format ["DAKKA: modsCheck _knownMods: %1", _knownMods] };
_mod