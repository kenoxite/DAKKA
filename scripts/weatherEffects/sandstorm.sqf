

sleep 1;

_location = nearestLocation [ATLtoASL positionCameraToWorld [0,0,0], ""];
_location = player;

_sandstorm = [_location, 0.01, 0.3, false] call BIS_fnc_sandstorm;
if (DAKKA_debug) then { diag_log format ["_sandstorm: %1", _sandstorm] };