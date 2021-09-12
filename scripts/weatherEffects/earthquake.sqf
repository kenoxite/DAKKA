// EARTHQUAKE

diag_log "DAKKA: Earthquake: Initializing";

_damageBuildings = if (count _this > 0) then  { _this select 0 } else { true };
_nearbyBuildings = [];
_sortedBuildings = [];
_searchRange = 1000;
_pos = ATLtoASL positionCameraToWorld [0,0,0];
_lastPos = [_searchRange*2, _searchRange*2, 0];
_firstSorting = true;
DAKKA_earthquake = true;

sleep 1;

while { DAKKA_earthquake } do {

    // Random intensity
    private _intensity = floor (random [1, 2, 4]);
    if (_intensity > 0) then {
        [_intensity] spawn BIS_fnc_earthquake;
        if (DAKKA_debug) then { diag_log format ["DAKKA: Earthquake: Starting earthquake - intensity: %1 - Damaging buildings: %2", _intensity, _damageBuildings] };
    };
    // Damage buildings while it lasts
    while { true } do {
        if !(missionNamespace getVariable "BIS_fnc_earthquake_inprogress") exitWith { false };
        if (_damageBuildings) then {
            _pos = ATLtoASL positionCameraToWorld [0,0,0];
            if ((_pos distance _lastPos) > (_searchRange / 2) || (count _nearbyBuildings) == 0) then {
                _nearbyBuildings = nearestObjects [_pos, ["House", "HouseBase", "Building"], _searchRange, true];
            };
            // if (DAKKA_debug) then { diag_log format ["_nearbyBuildings: %1", _nearbyBuildings] };
            // Sort by distance
            if ((_pos distance _lastPos) > 100 || _firstSorting) then {
                _sortedBuildings = _nearbyBuildings apply { [_x distance _pos, _x] };
                _sortedBuildings sort true;
                _firstSorting = false;
            };
            _lastPos = _pos;
            // Proceed to damage
            {
                private _building = _x select 1;
                private _damage = damage _building;
                private _damageDone = 0;
                if (_damage < 1) then {
                    // Damage building
                    _damageDone = _damage + (0.01 * _intensity) + (random 0.05);
                    _building setDamage _damageDone;

                    // Break windows
                    private _allHitPoints = getAllHitPointsDamage _building;
                    _allHitPoints = if (count _allHitPoints > 0) then { _allHitPoints select 1 } else { [] };
                    // Only check buildings with windows
                    if ("glass_1" in _allHitPoints) then {
                        for [{private _i = 1}, {_i < 100}, {_i = _i + 1}] do 
                        {
                            private _glass = format ["glass_%1", _i];
                            if !(_glass in _allHitPoints) exitWith { false };
                            private _glassDamage = _building getHit _glass;
                            if (_glassDamage < 1) then {
                                // if (DAKKA_debug) then { diag_log format ["%1 %2 %3", _building, _glass, _glassDamage] };
                                _building setHit [_glass, _glassDamage + (_damageDone * 2)];
                            };
                        };
                    };
                };
            } forEach _sortedBuildings;
        };

        sleep 1;
    };
    diag_log "DAKKA: Earthquake: Earthquake ended";

    // Wait for the next earthquake
    // private _wait = 10;
    private _wait = 10 + (random 180);
    for [{private _i = 0}, {(_i < _wait) && DAKKA_earthquake}, {_i = _i + 1}] do
    {
        sleep 1;
    };
};


diag_log "DAKKA: Earthquake: End";