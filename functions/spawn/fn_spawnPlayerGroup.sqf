/*
  Author: kenoxite

  Description:
  Moves the player to the designated player group and initializes it. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  ID of new player group

  Examples:

*/

params ["_pos"];
private ["_grp", "_unit", "_unitTraits", "_indexes", "_playableUnit", "_ldrIsPlayer", "_taskData", "_playerGroupData", "_playerData", "_groupName", "_groupUnits", "_playerIndex", "_playerCrewIndex", "_isMan", "_pos", "_rank", "_units", "_leader", "_veh", "_playerCommander", "_isLeader", "_isAir"]; 

diag_log format ["DAKKA: spawnPlayerGroup - Assigning new group to %1", p1];  

// Task data array
_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
_playerGroupData = _playerGroupData select 0;
// Player group data
_groupName = _playerGroupData select 0;
_groupUnits = _playerGroupData select 1;
// systemChat format ["DAKKA: _groupName: %1, _groupUnits: %2", _groupName, _groupUnits]; 
// Player data
_playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
_playerIndex = _playerData select 0;
_playerCrewIndex = _playerData select 1;
_playerLoadout = _playerData select 2;
// systemChat format ["DAKKA: _playerIndex: %1, _playerCrewIndex: %2", _playerIndex, _playerCrewIndex]; 

// Spawn player group
_grp = [_groupUnits, _pos, west] call DAKKA_fnc_spawnGroup;
waitUntil {sleep 0.01; _grp getVariable ["DAKKA_groupReady", false]};
_grp setVariable ["DAKKA_playerGroupReady", false];

0 = [_grp, _playerIndex, _playerCrewIndex, _playerLoadout] spawn {
    params ["_grp", "_playerIndex", "_playerCrewIndex", "_playerLoadout"];
    // Retrieve playable unit
    _playableUnit = (units _grp) select _playerIndex; 
    waitUntil {!isNil "_playableUnit"};
    diag_log format ["DAKKA: spawnPlayerGroup - _playableUnit: %1", _playableUnit];  
     
    _veh = vehicle _playableUnit; 
    _leader = leader _grp; 
    _isLeader = _leader == _playableUnit;
    _isMan = [typeOf _veh] call DAKKA_fnc_isMan; 

    // Unit Voice-overs mod: language the unit which is going to be replaced by the player speaks
    _voice = _playableUnit getVariable "UVO_voice";

    // Apply identity, loadout and traits of the playable unit
    [_playableUnit, p1, true, true, true] call DAKKA_fnc_cloneUnit;
    if (pitch p1 == 0) then {
        p1 setPitch 1;
        diag_log format ["DAKKA: spawnPlayerGroup - Player cloned badly. Something's fishy with the cloned identity... Trying again.", ""];
        [_playableUnit, p1] call DAKKA_fnc_cloneUnit;
    };

    // Apply loadout
    if (DAKKA_debug) then { diag_log format ["DAKKA: spawnPlayerGroup - _playerLoadout: %1", _playerLoadout] };
    [p1, _playerLoadout, 2] call DAKKA_fnc_prepareUnit;

    // Move player to vehicle crew slot
    _playerCommander = false;
    if (_isMan) then {
      deleteVehicle _playableUnit; 
    } else {
      call compile format ["
        _playerCommander = (effectiveCommander _veh) == (%1 _veh);
        unassignVehicle (%1 _veh);
        deleteVehicle (%1 _veh);
        p1 moveIn%1 _veh;
        p1 assignAs%1 _veh;
        ", DAKKA_crewSlotRoles select _playerCrewIndex];
      // Set commmander
      if (_playerCommander) then {
        (vehicle p1) setEffectiveCommander p1;
      };
    };

    // Check if player is leader
    private _ldrIsPlayer = [
                                false,
                                [
                                    [
                                        false,
                                        true
                                    ] select _playerCommander,
                                    true
                                ] select _isMan

                            ] select _isLeader;

    // systemChat format ["DAKKA: _ldrIsPlayer: %1, _playerCommander: %2, effectiveCommander: %3, _leader: %4, _isLeader: %5", _ldrIsPlayer, _playerCommander, effectiveCommander _veh, typeof _leader, _isLeader]; 

    // Rebuild group based on leadership
    [p1] joinSilent _grp; 
    if (_ldrIsPlayer) then { 
        _grp selectLeader p1;
    };

    // Initialize the rest of the team
    _units = (units group p1); 
    { 
        private _veh = vehicle _x;
        p1 reveal _x; 
        if (_x != p1) then {
            // Add unstick action
            private _actionID = _x addAction 
            [ 
                "Unstick Unit", 
                { 
                    _this spawn DAKKA_fnc_unstickUnit; 
                }, 
                nil, 
                20, 
                false, 
                true, 
                "_this == _target", 
                "", 
                -1, 
                true, 
                "", 
                ""  
            ];                    
            _x addEventHandler ["killed", format ["(_this select 0) removeAction %1;", _actionID]]; 
        };
        if (_veh != _x && _x == effectiveCommander _veh) then {
            private _isAir = [_veh] call DAKKA_fnc_isAir;
            if (!_isAir) then {
                private _actionID = _veh addAction 
                [ 
                    "Unstick Vehicle", 
                    { 
                        _this spawn DAKKA_fnc_unstickUnit; 
                    }, 
                    nil, 
                    20, 
                    false, 
                    true, 
                    "_this == _target", 
                    "", 
                    -1, 
                    true, 
                    "", 
                    ""  
                ]; 
                _veh addEventHandler ["killed", format ["(_this select 0) removeAction %1;", _actionID]]; 
            };
        };
    } forEach _units;


    // UNIT VOICE-OVERS FIX
    if !(isNil "_voice") then {
        _nul = [_voice] spawn {
            private ["_voice"];
            _voice = _this select 0;

            // Reset
            player setVariable ["UVO_voice",nil,true];
            // player setVariable ["UVO_speaking",nil,true];
            player setVariable ["UVO_suppressBuffer",nil,true];
            player setVariable ["UVO_allowDeathShouts",false,true];

            // Apply
            player setVariable ["UVO_voice",_voice,true];
            player setVariable ["UVO_suppressBuffer",0,true];
            player setVariable ["UVO_allowDeathShouts",missionNamespace getVariable ["uvo_main_UVO" + _voice,true],true];
        };
    };

    _grp setVariable ["DAKKA_playerGroupReady", true];
};

_grp 