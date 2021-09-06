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
private ["_grp", "_unit", "_unitTraits", "_indexes", "_playableUnit", "_ldrIsPlayer", "_taskData", "_playerGroupData", "_playerData", "_groupName", "_groupUnits", "_playerIndex", "_playerCrewIndex", "_isMan", "_pos", "_rank", "_units", "_leader", "_veh", "_playerCommander", "_isLeader", "_isAir", "_applyLoadout"]; 

diag_log format ["DMORBAT: Assigning new group to %1", p1];  
_grp = grpNull; 

// Task data array
_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
_playerGroupData = _playerGroupData select 0;
// Player group data
_groupName = _playerGroupData select 0;
_groupUnits = _playerGroupData select 1;
// systemChat format ["DMORBAT: _groupName: %1, _groupUnits: %2", _groupName, _groupUnits]; 
// Player data
_playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
_playerIndex = _playerData select 0;
_playerCrewIndex = _playerData select 1;
_playerLoadout = _playerData select 2;
// systemChat format ["DMORBAT: _playerIndex: %1, _playerCrewIndex: %2", _playerIndex, _playerCrewIndex]; 
_applyLoadout = true;

// Spawn player group
_unit = objNull;
_isMan = true; 
_isAir = false; 
private _emptyPos = [];
private _unitClass = "";
private _unitRank = "";
private _unitLoadout = [];
private _unitPresence = 0;
private _unitSkill = 0;
private _groupVehicles = [];
private _groupPassengers = [];
private _changeSkills = [];

// Check for presence
private _presentUnits = [];
{
  _unitPresence = _x select 3;
  if ((random 1) <= _unitPresence) then {
    _presentUnits pushBack _x;
  };
} forEach _groupUnits;

{
  _unitClass = _x select 0;
  _unitRank = _x select 1;
  _unitLoadout = _x select 2;
  _unitSkill = _x select 4;
  _isMan = [_unitClass] call DMORBAT_fnc_isMan;
  _unit = if (_isMan) then {
            ([_unitClass, _pos, if (isNull _grp) then { west } else {_grp}, [], 0, "NONE", true] call DMORBAT_fnc_spawnMan);
          } else {
            _isAir = [_unitClass] call DMORBAT_fnc_isAir;
            ([_unitClass, _pos, if (isNull _grp) then { west } else {_grp}, [], 200, if (_isAir) then { "FLY" } else { "NONE" }, true] call DMORBAT_fnc_spawnVehicle);
          };
  if (_forEachIndex == 0) then {
    _grp = group _unit;
  };
  if (!_isMan) then { _grp addVehicle _unit };
  _unit setUnitRank _unitRank;
  if (count _unitLoadout > 0) then {
    if ([_forEachIndex] call DMORBAT_fnc_checkIfSelIsPlayer) then {
        _applyLoadout = false;
    };
  };
  _unit setVelocity [0, 0, 0];
  _unit disableAI "TARGET";
  _unit disableAI "AUTOTARGET";
  _unit disableAI "AUTOCOMBAT";
  _unit disableAI "CHECKVISIBLE";
  _unit setCaptive true;
  _unit allowDamage false;
  {
    _x setCaptive true;
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "AUTOCOMBAT";
    _x disableAI "CHECKVISIBLE";
    _x allowDamage false;
  } forEach crew vehicle _unit;
  if (!_isMan) then {
    _unit enableSimulation false;
    if (!_isAir) then {
        private _unitPos = getPos _unit;
        // Reposition if objects are too close
        private _nearTerrObj = nearestTerrainObjects [_unitPos, [], 5 + (sizeOf _unitClass), false, true];
        if ((count _nearTerrObj) > 0) then {
          // Make sure vehicle has spawned in a safe spot
          // _emptyPos = [_unitPos, 0, 300, (sizeOf _unitClass) + 2, 0, 0.5] call BIS_fnc_findSafePos;
          // if (count _emptyPos < 3) then {
          _emptyPos = (getPos _unit) findEmptyPosition [5, 300, _unitClass];
          if (count _emptyPos > 0) then {
            diag_log format ["DMORBAT: setPlayerGroup - FOUND safe position for %1 (%2)", _unit, _unitClass];
            _unit setPos _emptyPos;
          } else {
            diag_log format ["DMORBAT: setPlayerGroup - NOT FOUND safe position for %1 (%2)", _unit, _unitClass];
          };
        };
    };
  };

    [_unit, _unitLoadout, _unitSkill] call DMORBAT_fnc_prepareUnit;
} forEach _presentUnits;

// DISABLE AI MODS
// Vcom AI
_grp setVariable ["VCM_Skilldisable",true]; //This command will disable an AI group from being impacted by Vcom AI skill changes.

// Retrieve playable unit
_playableUnit = (units _grp) select _playerIndex;   
_veh = vehicle _playableUnit; 
_leader = leader _grp; 
_isLeader = _leader == _playableUnit;
_isMan = [typeOf _veh] call DMORBAT_fnc_isMan; 

// Unit Voice-overs mod: language that speaks the unit that is going to be replaced by the player
_voice = _playableUnit getVariable "UVO_voice";

// Apply identity, loadout and traits of the playable unit
[_playableUnit, p1, true, true, true] call DMORBAT_fnc_cloneUnit;
if (pitch p1 == 0) then {
    p1 setPitch 1;
    diag_log format ["DMORBAT: setPlayerGroup Player cloned badly. Something's fishy with the cloned identity... Trying again.", ""];
    [_playableUnit, p1] call DMORBAT_fnc_cloneUnit;
};

// Apply loadout
if (DMORBAT_debug) then { diag_log format ["DMORBAT: setPlayerGroup _playerLoadout: %1", _playerLoadout] };
[p1, _playerLoadout, 2] call DMORBAT_fnc_prepareUnit;

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
    ", DMORBAT_crewSlotRoles select _playerCrewIndex];
  // Set commmander
  if (_playerCommander) then {
    (vehicle p1) setEffectiveCommander p1;
  };
  // Apply sensors
  (vehicle p1) setVehicleReportRemoteTargets true;   
  (vehicle p1) setVehicleReceiveRemoteTargets true;   
  (vehicle p1) setVehicleReportOwnPosition true;
};

// Check if player is leader
if (_isLeader) then {
  if (_isMan) then {
    _ldrIsPlayer = true; 
  } else {
    if (_playerCommander) then {
      _ldrIsPlayer = true;
    } else {
      _ldrIsPlayer = false;  
    };
  };
} else {
  _ldrIsPlayer = false; 
};
// systemChat format ["DMORBAT: _ldrIsPlayer: %1, _playerCommander: %2, effectiveCommander: %3, _leader: %4, _isLeader: %5", _ldrIsPlayer, _playerCommander, effectiveCommander _veh, typeof _leader, _isLeader]; 

// Rebuild group based on leadership
if (_ldrIsPlayer) then {     
 (units _grp) joinSilent group p1; 
} else { 
 [p1] joinSilent _grp; 
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
                _this spawn DMORBAT_fnc_unstickUnit; 
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
    } else {
        // _x addEventHandler ["killed", { [_this] call DMORBAT_fnc_spectate; }];                   
        // _x addEventHandler ["respawn", {  }]; 
    };
    _x enableAI "TARGET";
    _x enableAI "AUTOTARGET";
    _x enableAI "AUTOCOMBAT";
    _x enableAI "CHECKVISIBLE";
    _x setCaptive false;
    _x allowDamage true;
    if (_veh != _x && _x == effectiveCommander _veh) then {
        {
            _x enableAI "TARGET";
            _x enableAI "AUTOTARGET";
            _x enableAI "AUTOCOMBAT";
            _x enableAI "CHECKVISIBLE";
            _x setCaptive false;
            _x allowDamage true;
            _x enableSimulation true;
        } forEach crew _veh;
        private _isAir = [_veh] call DMORBAT_fnc_isAir;
        if (!_isAir) then {
            private _actionID = _veh addAction 
            [ 
                "Unstick Vehicle", 
                { 
                    _this spawn DMORBAT_fnc_unstickUnit; 
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
    _veh enableSimulation true;
} forEach _units;

// Move passengers to vehicles
{
    _passengerSeats = (fullCrew [_x, "", true]) select {isNull (_x select 0)};
    for [{private _i = 0}, {_i < count _passengerSeats && (count _groupPassengers) > 0}, {_i = _i + 1}] do {
        (_groupPassengers select 0) moveInAny _x;
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: setPlayerGroup - %1 is moving into %2", _groupPassengers select 0, typeOf _x] };
        _groupPassengers deleteAt 0;
    };
    if ((count _groupPassengers) == 0) exitWith { false };
} forEach _groupVehicles;

// UNIT VOICE-OVERS FIX
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

group p1 