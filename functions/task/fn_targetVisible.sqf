/*
  Author: kenoxite

  Description:
  Checks whether the target is visible for the group


  Parameter (s):
  _this select 0: 
 

  Returns:
  BOOL with result of check and unit who detected it, if any

  Examples:

*/

params ["_units", "_target" , ["_targetArea", 0], ["_checkDist", true]]; 
private _return = [false, objNull]; 
private _normalViewDist = 300;
private _aidedViewDist = 1000;

private _targetAreaElements = [_target];
if (_targetArea > 0) then {
    // Create more targets around the main one
    private _centralPos = _target;
    private _dir = 0;
    for [{private _i = 0}, {_i < 8}, {_i = _i + 1}] do
    {
        _newTargetElement = [_centralPos, _targetArea / 2, _dir] call BIS_fnc_relPos;
        _newTargetElement vectorAdd [0, 0, 1.7];
        _targetAreaElements pushBack _newTargetElement;
        // _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", format ["_newTargetElement_%1", _i], _newTargetElement, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 1, ""] call BIS_fnc_stringToMarker;
        _dir = _dir + 45;
    };
};

{  
    private _unit = _x;
    private _zoom = call DMORBAT_fnc_trueZoom;
    private _maxDist = if ((_unit != p1 && cameraView == "Gunner") || (_unit == p1 && _zoom >= 1.9)) then {
                        _aidedViewDist;
                    } else {
                        _normalViewDist;
                    };
    private _isFacing = [ position vehicle _unit, [0,0,0] getdir getCameraViewDirection _unit, 45, _target ] call BIS_fnc_inAngleSector;
    if (((_checkDist && ((vehicle _unit) distance _target) <= _maxDist) || !_checkDist) && _isFacing) then {
        {
            _return set [0, ([objNull, "VIEW"] checkVisibility [eyePos _unit, _x]) >= 0.7];
            if (_return select 0) exitWith { true };
        } forEach _targetAreaElements;
    };

    if (_return select 0) exitWith {
        _return set [1, _unit];
    };
} forEach _units; 

_return 