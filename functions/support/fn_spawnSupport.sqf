/*
Author: kenoxite

Description:
    Spawn support units. 


Parameter (s):
    _this select 0: 


Returns:


Examples:

*/


_nul = _this spawn {
    params ["_supportData"];
    
    private ["_taskData", "_groupsData", "_pos", "_supportLeader", "_magType", "_isInRange", "_minRange", "_maxRange", "_supportProviderType", "_fly", "_spawnRadius"];

    _basepos = position DAKKA_officer;

    // Create requester module
    _supportLogicGroup = createGroup sideLogic;
    DAKKA_SupportReq = _supportLogicGroup createUnit ["SupportRequester", _basepos, [], 50, "CAN_COLLIDE"];
    if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport DAKKA_SupportReq: %1", DAKKA_SupportReq] };

    //Setup requester limit values
    {
        [DAKKA_SupportReq, _x, 0] call BIS_fnc_limitSupport;
    } forEach [
        "Artillery",
        "CAS_Heli",
        "CAS_Bombing",
        "UAV",
        "Drop",
        "Transport"
    ];
    // Enable activation
    DAKKA_SupportReq setVariable [ "BIS_fnc_initModules_disableAutoActivation", false ];

    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;

    {
        _supportType = _x select 0;
        _supportLocation = if (count _x > 1) then { _x select 1 } else { position DAKKA_officer };
        _supportRadius = if (count _x > 2) then { _x select 2 } else { 300 };
        _blacklist = if (count _x > 3) then { _x select 3 } else { [] };
        _catIndex = [_groupsData, _supportType] call BIS_fnc_findInPairs;
        if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport _catIndex: %1", _catIndex] };
        if (_catIndex < 0) exitWith { diag_log format ["DAKKA: spawnSupport Suppport type ""%1"" not found!", _supportType]; false };

        _groupsCategoryData = _groupsData select _catIndex; 
        _thisCategoryName = _groupsCategoryData select 0;
        _thisCategoryData = _groupsCategoryData select 1;
        _supportLimit = (_thisCategoryData select 0) select 0;
        _thisCategoryGroups = _thisCategoryData select 1;
        if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport _thisCategoryGroups: %1", _thisCategoryGroups] };


        // Create support units
        _supportProviderType = [];
        if (_supportType == "Artillery") then {
            _supportProviderType pushBack "Artillery";
            _minRange = _supportRadius * 2;
            _maxRange = 3000;
            _spawnRadius = 50;  
            _fly = false;   
        };
        if (_supportType == "CAS") then {
            _supportProviderType pushBack "CAS_Heli";
            _minRange = 100;
            _maxRange = 500;  
            _spawnRadius = 300;   
            _fly = true;   
        };
        if (_supportType == "Air Transport") then {
            _supportProviderType pushBack "Transport";
            // _minRange = _supportRadius;
            // _maxRange = _supportRadius * 3; 
            _minRange = _supportRadius * 2;
            _maxRange = 3000;
            _spawnRadius = 300;  
            _fly = true;  
        };

        _artilleryGroups = [];
        _CAS_HeliGroups = [];
        _CAS_BombingGroups = [];
        _TransportGroups = [];
        // Spawn and add support groups
        {
            // Find suitable positions
            // _pos = [_supportLocation, _minRange, _maxRange, 50, 0, 0.2, 0, _blacklist] call BIS_fnc_findSafePos;
            // Spawn support unit leader
            // _grp = [_x select 1, _pos, west, _spawnRadius, _fly] call DAKKA_fnc_spawnGroup;
            _pos = [_supportLocation, _maxRange, random 360] call BIS_fnc_relPos;
            private _i = 0;
            while { (surfaceIsWater _pos || (getTerrainHeightASL _pos) < 0.5)  && _i < 30} do {
                diag_log format ["DAKKA: --- WARNING --- %1: Position for support group ""%2"" is over water. Trying again.", _i, _supportType];
                _pos = [_supportLocation, (_maxRange / 2) + (random (_maxRange / 2)), random 360] call BIS_fnc_relPos;
                _i = _i + 1;
            };
            _grp = [_x select 1, _pos, west, _spawnRadius, _fly] call DAKKA_fnc_spawnGroup;
            if (isNull _grp) exitWith { diag_log format ["DAKKA: --- ERROR --- %1 group could not be spawned!", _supportType]; grpNull };
                
            _supportLeader =  vehicle leader _grp;
            if (_supportType != "Artillery") then {
                // DAKKA_martaHide pushBack _grp;
            };
            // if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport _supportLeader: %1", _supportLeader] };

            // Add to support groups array
            {
                call compile format ["_%1Groups pushBack _supportLeader", _x];
            } forEach _supportProviderType;

            if (_supportType == "CAS" && _supportLeader isKindOf "Plane") then {
                _pylonLoadout = getPylonMagazines _supportLeader;
                _isBomb = false;
                {
                    _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
                    _ammoParents = [configFile >> "CfgAmmo" >> _ammo, true] call BIS_fnc_returnParents;
                    _isBomb = "BombCore" in _ammoParents;
                    if (_isBomb) exitWith { if (DAKKA_debug) then { diag_log format ["%1 - %2 is a bomb? %3", typeOf _supportLeader, _x, _isBomb] }; };
                } forEach _pylonLoadout;
                if (_isBomb) then {
                    _supportProviderType pushBack "CAS_Bombing";
                    _CAS_BombingGroups pushBack _supportLeader;
                };
            };

            if (_supportType == "Artillery") then {
                _supportLeader setPilotLight false;
                _supportLeader disableAI "LIGHTS";
                _supportLeader engineOn false;
                // Check range
                _magType = (getArtilleryAmmo [_supportLeader]) select 0;
                if (!isNil _magType) then {
                    _isInRange = _supportLocation inRangeOfArtillery [[_supportLeader], _magType];
                    private _i = 0;
                    private _maxTries = 10;
                    while { !_isInRange && _i < _maxTries && (_maxRange - 200) > _minRange } do {
                        // Try closer
                        _maxRange = _maxRange - 200;
                        _pos = [_supportLocation, _minRange, _maxRange - 200, 5, 0, 0.4, 0, _blacklist] call BIS_fnc_findSafePos;
                        _supportLeader setPos _pos;
                        _isInRange = _supportLocation inRangeOfArtillery [[_supportLeader], _magType];
                        _i = _i + 1;
                    };
                    if (!_isInRange) then { diag_log format ["DAKKA: spawnSupport Artillery could not be placed in range!", ""]; };
                };
            };

            // Do stuff with support units
            {
                private _veh = vehicle _x;

                if (_supportType == "Artillery") then {
                    if (_x == effectiveCommander _veh) then {
                        _veh setPilotLight false;
                        _veh disableAI "LIGHTS";
                        _veh engineOn false;
                        // Apply flare fix
                        if (DAKKA_flares) then {
                            if !([DAKKA_customDate] call DAKKA_fnc_isNight) exitWith { false };
                            _veh addEventHandler ["Fired",{private ["_al_flare"]; _al_flare = _this select 6;[[_al_flare],"AL_flare_fix\al_flare_enhance.sqf"] remoteExec ["execVM",0,true]}];
                        };
                    };
                };

                if (_supportType == "CAS") then {
                    if (_x == effectiveCommander _veh) then {
                        {
                            _x setSkill 1;
                        } forEach (crew _veh);
                        if (_veh isKindOf "Helicopter") then {
                                // waitUntil {unitReady _veh};
                                // _veh land 'land';
                        } else {
                            deleteWaypoint [_grp, 0];
                            _wp = _grp addWaypoint [_supportLocation, 100, 0];
                            _wp setWaypointType "LOITER";
                        };
                    };
                };

                if (_supportType == "Transport") then {
                    if (_x == effectiveCommander _veh) then {
                        deleteWaypoint [_grp, 0];
                        _veh allowDamage false;
                        {
                            _x setSkill 1;
                            _x allowDamage false;
                            // _x disableAI "TARGET";
                            // _x disableAI "AUTOTARGET";
                        } forEach (crew _veh);
                        // waitUntil {unitReady _veh};
                       // _veh land 'land';
                   };
                };

            } forEach (units _grp);

        } forEach _thisCategoryGroups;

        {
            // Create support provider module
            _supportLogicGroup = createGroup sideLogic;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport _supportLogicGroup: %1, _supportProviderType: %2, _basepos; %3", _supportLogicGroup, _supportProviderType, _basepos] };
            _supportProvider = _supportLogicGroup createUnit [format ["SupportProvider_%1", _x], _basepos, [], 30, "CAN_COLLIDE"];
            if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport _supportProvider: %1", _supportProvider] };
            // Sync provider to requester module
            _supportProvider synchronizeObjectsAdd [DAKKA_SupportReq];
            DAKKA_SupportReq synchronizeObjectsAdd [_supportProvider];

            // Link leader support unit to support module
            _supportGroups = call compile format ["_%1Groups", _x];
            {
                _supportProvider synchronizeObjectsAdd [_x];
                if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport - _supportProvider sync objects: %1", synchronizedObjects _supportProvider] };
                _x synchronizeObjectsAdd [_supportProvider];
                if (DAKKA_debug) then { diag_log format ["DAKKA: spawnSupport - %1 sync objects: %2", _x, synchronizedObjects _x] };
            } forEach _supportGroups;

            // Setup provider values
            {
                _supportProvider setVariable [(_x select 0), (_x select 1)];
            } forEach [
                ["BIS_SUPP_vehicles", []],          // types of vehicles to use
                ["BIS_SUPP_vehicleinit", ""],       // init code for vehicle
                ["BIS_SUPP_filter", "SIDE"]         // whether default vehicles comes from "SIDE" or "FACTION"
            ];

            // Enable activation
            _supportProvider setVariable [ "BIS_fnc_initModules_disableAutoActivation", false ];

            // Link player to support
            // {
            //     [_x, DAKKA_SupportReq, _supportProvider] call BIS_fnc_addSupportLink;
            // } forEach (units DAKKA_PlayerNewGroup);
            [p1, DAKKA_SupportReq, _supportProvider] call BIS_fnc_addSupportLink;

            // Apply support limits
            [DAKKA_SupportReq, _x, _supportLimit] call BIS_fnc_limitSupport;
        } forEach _supportProviderType;

    } forEach _supportData;

};