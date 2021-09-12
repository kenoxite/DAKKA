#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Previews the player's group. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

params ["_grp"];
private _pos = getMarkerPos "DAKKA_groupPreviewPos";
private _dir = 180;
private _men = [];
private _vehicles = [];
private _veh = objNull;
{
	_veh = vehicle _x;
	if (_x isKindOf "Man" && _veh == _x) then {
		_men pushBack _x;
	} else {
		_vehicles pushBack _x;
	};
} forEach (units _grp);
// if (DAKKA_debug) then { diag_log format ["DAKKA: previewGroupPosition _men: %1", _men] };
// if (DAKKA_debug) then { diag_log format ["DAKKA: previewGroupPosition _vehicles: %1", _vehicles] };

// Delete wheelchocks
private _wheelChock = objNull;
{
  deleteVehicle _x;
} forEach DAKKA_wheelChock;
DAKKA_wheelChock = []; 
  
private _cameraPos = _pos;
private _cameraDir = _dir;
private _cameraRelX = 0;
private _cameraRelY = 0;
private _cameraRelZ = 0;
private _cameraHeight = 0;
private _cameraFOV = 0;
private _cameraTarget = objNull;
private _cameraHeightCircle = 0;
private _cameraRadius = 0;

// Place infantry
private _amountMen = count _men;
private _row = 1;
private _rowMaxMen = 8;
private _rowCenterPos = _pos;
private _lor = 1;
private _dist = 0;
private _formDir = 90;
private _unitPos = _pos;
private _veh = objNull;
private _bbr = [];
private _lastUnitWidth = 0;
private _manWidth = 0;
private _watchPos = [];
private _i = 1;
private _j = 1;
{
	_dist = (1) * _i;
	if (_forEachIndex > 0) then {
		if (_forEachIndex %2 == 0) then {
			_lor = 1;
			_i = _i + 1;
		} else {
			_lor=-1;
		};
		_unitPos = [_rowCenterPos, _dist, _formDir * _lor] call BIS_fnc_relPos;
	} else {
		_cameraTarget = _x;
		_unitPos = _rowCenterPos;
	};
	if (_j > _rowMaxMen) then {
		_rowCenterPos = [(_rowCenterPos select 0) + (0.5 * _lor), (_rowCenterPos select 1) + (_row * 1.5), _rowCenterPos select 2];
		_row = _row + 1;
		_i = 1;
		_j = 1;
		_unitPos = _rowCenterPos;
	};
	// if (DAKKA_debug) then { diag_log format ["DAKKA: _dist: %1 , _formDir: %2", _dist, _formDir * _lor] };
	// if (DAKKA_debug) then { diag_log format ["DAKKA: _unitPos: %1", _unitPos] };
	_x setPos _unitPos;
	_x setDir _dir;
	_bbr = [_x] call DAKKA_fnc_boundingBoxReal;
	_manWidth = _bbr select 0;
	_watchPos = [[_unitPos select 0, _unitPos select 1, (_bbr select 2) + 3], 50, _dir] call BIS_fnc_relPos;
	_x lookAt _watchPos;
	_j = _j + 1;
	if (_row == 1 && _amountMen > _rowMaxMen) then {
		if (primaryWeapon _x =="" && secondaryWeapon _x =="" && handgunWeapon _x =="") then {
				_x switchMove "AmovPknlMstpSnonWnonDnon_gear_trans"; // Kneeling
		} else {
			if (secondaryWeapon _x !="") then {
				_x switchMove "AidlPknlMstpSrasWlnrDnon_AI"; // Kneeling Launcher
				// _x switchMove "AmovPknlMstpSrasWlnrDnon_AinvPknlMstpSrasWlnrDnon_Putdown"; // Kneeling Launcher
			} else {
				if (primaryWeapon _x !="") then {
					_x switchMove "AidlPknlMstpSlowWrflDnon_AI"; // Kneeling Rifle
				} else {
					_x switchMove "AidlPknlMstpSlowWpstDnon_AI"; // Kneeling Pistol
				};
			};
		};
	} else {
		if (primaryWeapon _x =="" && secondaryWeapon _x =="" && handgunWeapon _x =="") then {
				_x switchMove "AmovPercMstpSnonWnonDnon_Ease"; // Standing
				// _x switchMove "AmovPercMstpSnonWnonDnon"; // Standing
		} else {
			if (secondaryWeapon _x !="") then {
				// _x switchMove "AidlPercMstpSrasWlnrDnon_AI"; // Standing Launcher
				_x switchMove "AmovPercMstpSrasWlnrDnon_AmovPercMstpSlowWlnrDnon"; // Standing Launcher
			} else {
				if (primaryWeapon _x !="") then {
					_x switchMove "AidlPercMstpSlowWrflDnon_AI"; // Standing Rifle
				} else {
					_x switchMove "AidlPercMstpSlowWpstDnon_AI"; // Standing Pistol
				};
			};
		};
	};
} forEach _men;

// Place vehicles
_lastUnitWidth = 0;
_lor = 1;
private _longestLength = 0;
private _amountVeh = 0;
private _realVehicles = [];
_row = 1;
private _rowMaxVeh = 4;
_i = 1;
_j = 1;
private _k = 0;
private _pos1 = [];
private _pos2 = [];
private _middlePoint = [];
private _vehCount = 0;

// Purge non commanders from vehicles array
{
	_veh = vehicle _x;
	if (_x == effectiveCommander _veh) then {
		_realVehicles pushBack _veh;
	};
} forEach _vehicles;
_amountVeh = count _realVehicles;

{
	_veh = vehicle _x;
	// if (DAKKA_debug) then { diag_log format ["DAKKA: _x is 1st crew of: %1", _veh] };
	_bbr = [_veh] call DAKKA_fnc_boundingBoxReal;
	_dist = ((_lastUnitWidth + 2) * _i);
	if (_k > 0) then {
		if (_forEachIndex %2 == 0) then {
			_lor = 1;
			_i = _i + 1;
		} else {
			_lor=-1;
		};
		if (_amountMen > 0 && (_bbr select 1) > _longestLength) then {
			_rowCenterPos set [1, (_rowCenterPos select 1) + (_bbr select 1)];
		};
		if ((_bbr select 1) > _longestLength) then {
			_longestLength = _bbr select 1;
		};
		_unitPos = [_rowCenterPos, _dist, _formDir * _lor] call BIS_fnc_relPos;
	} else {
		_cameraTarget = _veh;
		if (_amountMen > 0) then {
			if (_amountMen == 1) then {
				_middlePoint = getPos (_men select 0);
			} else {
				if (_amountMen <= _rowMaxMen) then {
					_pos1 = getPos (_men select (_amountMen - 2));
					_pos2 = getPos (_men select (_amountMen - 1));
				} else {
					_pos1 = getPos (_men select (_rowMaxMen - 2));
					_pos2 = getPos (_men select (_rowMaxMen - 1));
				};
				_middlePoint = [_pos1, _pos2] call DAKKA_fnc_middlePoint;
			};
			_vehCount = if (_amountVeh > _rowMaxVeh) then { _rowMaxVeh } else { _amountVeh };
			_rowCenterPos set [0, (_middlePoint select 0) + (_dist * (_vehCount/2))];
			_rowCenterPos set [1, (_rowCenterPos select 1) + (_bbr select 1)];
			_longestLength = (_bbr select 1) max 2;
		};
		_unitPos = _rowCenterPos;
	};
	if (_j > _rowMaxVeh) then {
		_rowCenterPos = [(_rowCenterPos select 0) + (0.5 * _lor), (_rowCenterPos select 1) + (_row * (_longestLength + 2)), _rowCenterPos select 2];
		_row = _row + 1;
		_lastUnitWidth = 0;
		_i = 1;
		_j = 1;
		_unitPos = _rowCenterPos;
	};
    // _veh setPos [_unitPos select 0, _unitPos select 1, 0.3];
    _veh setPos _unitPos;
	_veh setDir _dir + 30;
    _veh setVectorUp (surfaceNormal (position _veh));
	// if (DAKKA_debug) then { diag_log format ["DAKKA: %4[%3] _dist: %1 , _formDir: %2", _dist, _formDir * _lor, typeof _veh, _veh] };
	// if (DAKKA_debug) then { diag_log format ["DAKKA: _unitPos: %1", _unitPos] };
	_veh enableSimulation true;
    _veh setVelocity [0, 0, 0];
	// Stop air units from taking off
	if (_veh isKindOf "Plane") then {
		_wheelChock = createVehicle ["Land_WheelChock_01_F", [getPos _veh, 3, getDir _veh] call BIS_fnc_relPos, [], 0, "CAN_COLLIDE"];
		_wheelChock setDir (getDir _veh) + 90;
		DAKKA_wheelChock pushBack _wheelChock;
	};
	if (_veh isKindOf "Helicopter") then {
		_veh setFuel 0;
	};
	_watchPos = [[_unitPos select 0, _unitPos select 1, (_bbr select 2) + 3], 10, _dir] call BIS_fnc_relPos;
	_veh doWatch _watchPos;
	// _unitPos = _rowCenterPos;
	_lastUnitWidth = _bbr select 0;
	// if (DAKKA_debug) then { diag_log format ["DAKKA: _lastUnitWidth: %1", _lastUnitWidth] };
	_j = _j + 1;
	_k = _k + 1;
} forEach _realVehicles;
// if (DAKKA_debug) then { diag_log format ["DAKKA: _amountVeh: %1", _amountVeh] };

// Camera parameters

// Auto - adjust
private _resolution = getResolution;
private _aspectRatio = _resolution select 4;
private _wideScreen = if (_aspectRatio > 1.4) then { true } else { false };
private _rowCenterPos = [];
private _previewAreaAdj = 1.7;
private _vehCheck = objNull;
DAKKA_cameraTarget = objNull;
_cameraRelX = if (_wideScreen) then { -0.3 } else { 0.2 };
_cameraRelY = 13;
_cameraRelZ = 2;
_cameraHeight = 0.5;
_cameraFOV = if (_wideScreen) then { 0.35 } else { 0.48 };
if (_amountMen > 0) then {
	_vehCheck = vehicle (_men select 0);
	_bbr = [_vehCheck] call DAKKA_fnc_boundingBoxReal;
	_cameraRelZ = ((_bbr select 2)/2) + 0.2;
	_cameraHeight = (_bbr select 2) * 0.2;
	_cameraFOV = if (_wideScreen) then { 0.3 } else { 0.43 };
	if (_amountMen == 1) then {
		_cameraFOV = if (_wideScreen) then { 0.2 } else { 0.2 };
		_previewAreaAdj = 0.5;
		_middlePoint = getPos (_men select 0);
	} else {
		if (_amountMen <= _rowMaxMen) then {
			_cameraRelY = (((_bbr select 1) * 2) + (_bbr select 2)) + _amountMen;
			_previewAreaAdj = _previewAreaAdj * (_amountMen * 0.1);
			_pos1 = getPos (_men select (_amountMen - 2));
			_pos2 = getPos (_men select (_amountMen - 1));
		} else {
			_cameraRelY = (((_bbr select 1) * 2) + (_bbr select 2)) + _rowMaxMen;
			_previewAreaAdj = _previewAreaAdj * (_rowMaxMen * 0.1);
			_pos1 = getPos (_men select (_rowMaxMen - 2));
			_pos2 = getPos (_men select (_rowMaxMen - 1));
		};
		_middlePoint = [_pos1, _pos2] call DAKKA_fnc_middlePoint;
	};
};
if (_amountVeh > 0) then {
	_vehCheck = vehicle (_realVehicles select 0);
	_bbr = [_vehCheck] call DAKKA_fnc_boundingBoxReal;
	if (_amountVeh == 1) then {
		_cameraRelY = ((_bbr select 2) * 6) max 12;
		_cameraFOV = if (_wideScreen) then { 0.25 } else { 0.38 };
		if (_amountMen == 0) then {
            _cameraRelX = if (_wideScreen) then { 0 } else { 2 };
			_cameraRelZ = (((_bbr select 2) / 2) + 0.5) max 0.1;
			_cameraHeight = ((_bbr select 2) * 0.1) max 0.3;
			if ((_bbr select 2) > 1) then {
				_previewAreaAdj = 1;
			} else {
				_previewAreaAdj = 0.3;
			};
			_middlePoint = getPos (_realVehicles select 0);
		} else {
            _cameraRelX = if (_wideScreen) then { 0 } else { 0.5 };
			_cameraRelZ = ((_bbr select 2) / 2);
			_cameraHeight = ((_bbr select 2) / 2) * 0.1;
			_cameraRelY = (_cameraRelY + (_longestLength/1.5)) max 22;
			_cameraFOV = if (_wideScreen) then { 0.22 } else { 0.31 };
		};
	} else {
		_cameraFOV = if (_wideScreen) then { 0.3 } else { 0.42 };
		if (_amountVeh <= _rowMaxVeh) then {
            _cameraRelX = if (_wideScreen) then { 0 } else { 1.5 };
			_cameraRelY = ((_bbr select 2) * ((_longestLength / 1.8) * (_amountVeh / 2))) max 25;
			_previewAreaAdj = _previewAreaAdj * (_amountVeh * 0.5);
			_pos1 = getPos (_realVehicles select (_amountVeh - 2));
			_pos2 = getPos (_realVehicles select (_amountVeh - 1));
			_cameraRelZ = ((_bbr select 2)/2) + 1.5;
			_cameraHeight = (_bbr select 2) * 0.1;
		} else {
			_cameraRelY = ((_bbr select 2) * ((_longestLength / 1.8) * (_rowMaxVeh / 2))) max 25;
			_previewAreaAdj = _previewAreaAdj * (_rowMaxVeh * 0.5);
			_pos1 = getPos (_realVehicles select (_rowMaxVeh - 2));
			_pos2 = getPos (_realVehicles select (_rowMaxVeh - 1));
			_cameraRelZ = ((_bbr select 2) / 2) + 2;
			_cameraHeight = (_bbr select 2) * 0.5;
		};
		_middlePoint = [_pos1, _pos2] call DAKKA_fnc_middlePoint;
	};
};
if (_amountMen > 0 || _amountVeh > 0) then {
	_rowCenterPos = [
		(_middlePoint select 0) - _previewAreaAdj,
		(getPos _cameraTarget) select 1,
		0.5
		];
	DAKKA_cameraTarget= createVehicle ["RoadCone_F", _rowCenterPos, [], 0, "CAN_COLLIDE"];
	DAKKA_cameraTarget setPos _rowCenterPos;
	DAKKA_cameraTarget hideObject true;
	_cameraPos = [
		((getPos _cameraTarget) select 0) - _previewAreaAdj,
		_pos select 1,
		0
	];
	_cameraTarget = DAKKA_cameraTarget;
	[_cameraPos, _cameraDir, _cameraFOV, _cameraRelX, _cameraRelY, _cameraRelZ, _cameraHeight, _cameraTarget] spawn DAKKA_fnc_cameraPreviewStatic;
	// [_cameraPos, _cameraRadius, _cameraHeightCircle] spawn DAKKA_fnc_cameraPreviewCircle;
};