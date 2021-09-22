/*
  Author: Killzone Kid

  Description:
  Gives more accurate results than BIS isFlatEmpty


  Parameter (s):
    position: Array - position in format PositionAGL
    [minDistance, mode, maxGradient, maxGradientRadius, overLandOrWater, shoreLine, ignoreObject]: Array
    minDistance: Number - (Optional, default -1) minimum (2D) distance from other objects (range 0..50). -1 to ignore proximity check
    mode: Number - (Optional, default -1) position check mode (ALWAYS USE DEFAULT VALUE)
    maxGradient: Number - (Optional, default -1) maximum terrain steepness allowed. -1 to ignore
    maxGradientRadius: Number - (Optional, default 1) how far to extend gradient check
    overLandOrWater: Number - (Optional, default 0)
    0: position cannot be over water
    2: position cannot be over land
    -1 to ignore
    shoreLine: Boolean - (Optional, default false)
    true: position is over shoreline (< ~25 m from water)
    false to ignore
    ignoreObject: Object - (Optional, default objNull) object to ignore in proximity checks. objNull to ignore
  Returns:


  Examples:
    [[4274.66,12113,0.00139618], [1, -1, 0.1, 1, -1, false, objNull]] call DAKKA_fnc_isFlatEmpty; // [4274.53,12113,48.3175]
*/
params ["_pos", "_params"];
_pos = _pos findEmptyPosition [0, _params select 0];
if (_pos isEqualTo []) exitWith {[]};
_params = +_params;
_params set [0, -1];
_pos = _pos isFlatEmpty _params;
if (_pos isEqualTo []) exitWith {[]};
_pos
