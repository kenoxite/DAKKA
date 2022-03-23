// TASK 1
// Flow

// DAKKA_task1_locPos = _this select 0;

_task_1_checks = [] spawn {
    private _enemyGroups = +DAKKA_patrolGrps_task1 + DAKKA_defendGrps_task1;
	private _timer = 0;
    private _detectedTimer = 0;
    private _detectedMaxTime = 60;
    private _detectors = [];
    private _detectedPlayerPos = position p1;
    private _outpostVisibleTimer = 0;
    private _maxTimeNoEnemiesInOutpost = selectRandom [30, 60, 120];
    private _noEnemiesInOupostTimer = 0;
	private _exfilDistance = 0;
	private _exfilPos = [];
    private _globalRadio_Combat = [
                "SentNotifyAttack"
            ];

    private _reinforcements = [];
    private _keepSearchingWarned = false;
    private _timeOfDetection = 0;

    private _fnc_enemyRadio = {
        params ["_reporter","_msg", ["_isRadio", true]];
        if (_isRadio) then {
            _reporter globalRadio _msg;
        } else {
            _reporter globalChat _msg;
            _reporter setRandomLip true;
            sleep 1 + random 2;
            _reporter setRandomLip false;
        };
        playSound "radioStatic1";
    };


    {
        {
            _reinforcements pushBackUnique [(typeOf _x), getUnitLoadout _x, 1];
        } forEach (units _x);
        _x setVariable ["DAKKA_stalking", false];
    } forEach _enemyGroups;
    private _reincorcementsArrived = false;

    // Immunity On
    {
        _x setCaptive false;
    } forEach (units DAKKA_PlayerNewGroup);

	while { !DAKKA_Task1_End_done } do {
        _missionTimePassed = time - DAKKA_missionStartTime;

        // Remove immunity
        if (DAKKA_Task1_init && _missionTimePassed >= 30) then {
            {
                _x setCaptive false;
            } forEach (units DAKKA_PlayerNewGroup);
        };

        // PATROLS
        // Remove empty groups
        DAKKA_patrolGrps_task1 = DAKKA_patrolGrps_task1 - [grpNull];
        // Check for dead groups
        _deleteGrps = [];
        {
            if (({alive _x} count (units _x)) == 0) then {
                _deleteGrps pushBackUnique _forEachIndex;
            };
        } forEach DAKKA_patrolGrps_task1;
        // Remove dead groups
        {
            DAKKA_patrolGrps_task1 deleteAt _x;
        } forEach _deleteGrps;

        // DEFENDERS
        // Remove empty groups
        DAKKA_defendGrps_task1 = DAKKA_defendGrps_task1 - [grpNull];
        // Check for dead groups
        _deleteGrps = [];
        {
            if (({alive _x} count (units _x)) == 0) then {
                _deleteGrps pushBackUnique _forEachIndex;
            };
        } forEach DAKKA_defendGrps_task1;
        // Remove dead groups
        {
            DAKKA_defendGrps_task1 deleteAt _x;
        } forEach _deleteGrps;

        // ALL ENEMIES
        // Remove empty groups
        _enemyGroups = _enemyGroups - [grpNull];
        // Check for dead groups
        _deleteGrps = [];
        {
            if (({alive _x} count (units _x)) == 0) then {
                _deleteGrps pushBackUnique _forEachIndex;
            };
        } forEach _enemyGroups;
        // Remove dead groups
        {
            _enemyGroups deleteAt _x;
        } forEach _deleteGrps;


		// Player detected check
		if (DAKKA_Task1_init && _missionTimePassed >= 60) then {
            // Remove empty groups from detectors
            _detectors = _detectors - [grpNull];
            // Check for dead groups
            _deleteGrps = [];
            {
                if (({alive _x} count (units _x)) == 0) then {
                    _deleteGrps pushBackUnique _forEachIndex;
                };
            } forEach _detectors;
            // Remove dead groups
            {
                _detectors deleteAt _x;
            } forEach _deleteGrps;

            // Check enemy groups for detection
			{
                private _nearestEnemy = (leader _x) findNearestEnemy (position vehicle leader DAKKA_PlayerNewGroup);
                private _playerDetected = _nearestEnemy in (units DAKKA_PlayerNewGroup);
                if (_playerDetected) then {
                    _detectors pushBackUnique _x;
                    private _knowsAbout = (leader _x) knowsAbout (vehicle leader DAKKA_PlayerNewGroup);
                    if (_knowsAbout > 3) then {
                        // _detectedPlayerPos = position vehicle leader DAKKA_PlayerNewGroup;
                    };
                // if (DAKKA_debug) then { diag_log format ["DAKKA: %1 knowsAbout: %2", _x, (leader _x) knowsAbout (vehicle leader DAKKA_PlayerNewGroup)] };
                };
			} forEach _enemyGroups;
                // if (DAKKA_debug) then { diag_log format ["DAKKA: _detectors: %1", _detectors] };

            // Count time since last detection
            if (count _detectors > 0) then {
                // ENEMIES ARE DETECTING THE PLAYER GROUP
                if (!DAKKA_Task1_detected) then {
                    if (_detectedTimer == 0) then {
                        diag_log format ["DAKKA: Player was detected by %1", str _detectors];
                        // hintSilent "Your group has been spotted!\nThey will alert the rest in a few seconds!";
                        // Delay alert a bit to make it feel more natural
                        _reporter = leader (_detectors select 0);
                        [_reporter, _enemyGroups, _fnc_enemyRadio] spawn {
                            params ["_reporter", "_enemyGroups", "_fnc_enemyRadio"];
                            sleep (2 + (random 2));
                            if (!alive _reporter || !([_reporter] call DAKKA_fnc_isMan)) then {
                                _reporter = leader (selectRandom _enemyGroups);
                            };
                            [_reporter, "SentContact"] spawn _fnc_enemyRadio;
                        };
                        _detectedPlayerPos = position vehicle leader DAKKA_PlayerNewGroup;
                    };
                    if (_detectedTimer < _detectedMaxTime) then {
                        _detectedTimer = _detectedTimer + 1;
                    } else {
                        if (DAKKA_debug) then { diag_log format ["DAKKA: _detectors: %1", _detectors] };
                        diag_log format ["DAKKA: Enemies are alerted", ""];
                        DAKKA_Task1_detected = true;
                        _timeOfDetection = time;
                        // hintSilent "Your group has been spotted!";
                        if (count _enemyGroups > 0) then {
                            _reporter = leader (selectRandom _enemyGroups);
                            diag_log format ["DAKKA: %1 is alerting to patrols", _reporter];
                            if (!isNull _reporter) then {
                                [_reporter, "SentGenCmdTargetNeutralize"] spawn _fnc_enemyRadio;
                                _alerted = DAKKA_patrolGrps_task1 - [group _reporter];
                                {
                                    sleep (0.5 + random 1);
                                    [leader _x, "SentNotifyAttack"] spawn _fnc_enemyRadio;
                                } forEach _alerted;

                                diag_log format ["DAKKA: %1 is alerting to defenders", _reporter];
                                [_reporter, "SentGenCmdDefend"] spawn _fnc_enemyRadio;
                                _alerted = DAKKA_defendGrps_task1 - [group _reporter];
                                {
                                    sleep (0.5 + random 1);
                                    [leader _x, "SentConfirmMove"] spawn _fnc_enemyRadio;
                                } forEach _alerted;
                            };
                        };

                        if ((leader DAKKA_PlayerNewGroup) != p1) then {
                            DAKKA_PlayerNewGroup setBehaviour "COMBAT";  
                            DAKKA_PlayerNewGroup setCombatMode "RED";  
                            DAKKA_PlayerNewGroup setFormation "WEDGE";
                        };
                    };
                };
            } else {
                // NO ENEMIES ARE DETECTING THE PLAYER GROUP
                // Enemies alerted and searching but player group not detected
                if (DAKKA_Task1_detected && !_keepSearchingWarned) then {
                    diag_log format ["DAKKA: Enemies are still alerted and searching, but player group remains undetected", ""];
                    _reporter = objNull;
                    if (count _enemyGroups > 0) then {
                        _reporter = leader (selectRandom _enemyGroups);
                    };
                    _report = selectRandom [
                        "<We've lost contact! Keep alert!>",
                        "<They are hiding somewhere! Keep your eyes open!>",
                        "<Keep searching! They must be somewhere!>"
                        ];
                    if (!isNull _reporter) then {
                        [_reporter, _report, _fnc_enemyRadio] spawn {
                            params ["_reporter", "_report", "_fnc_enemyRadio"];
                            sleep (10 + (random 30));
                            [_reporter, _report, false] spawn _fnc_enemyRadio;
                        };
                    };
                    _keepSearchingWarned = true;

                };
                // Enemies alerted but a lot of time has passed without the player group being detected
                if (DAKKA_Task1_detected && (time - _timeOfDetection) > 300) then {
                    diag_log format ["DAKKA: Alerted enemies have resumed patrolling. Player group remains undetected", ""];
                    DAKKA_Task1_detected = false;
                    _reporter = objNull;
                    if (count _enemyGroups > 0) then {
                        _reporter = leader (selectRandom _enemyGroups);
                    };
                    _report = selectRandom [
                        "<They have disappeared... Keep patrolling and watch out!>",
                        "<They got away... Resume your patrols and keep your eyes open>",
                        "<They must have moved position. Resume your patrols and watch out for threats!>"
                        ];
                    if (!isNull _reporter) then {
                        [_reporter, _report, _fnc_enemyRadio] spawn {
                            params ["_reporter", "_report", "_fnc_enemyRadio"];
                            sleep (10 + (random 30));
                            [_reporter, _report, false] spawn _fnc_enemyRadio;
                        };
                    };
                    _keepSearchingWarned = false;
                    _timeOfDetection = 0;
                    _detectedTimer = 0;

                };
                // Player group spotted but enemies weren't alerted
                if (!DAKKA_Task1_detected && _detectedTimer > 0) then {
                    diag_log format ["DAKKA: Alerted enemies dead. Player group remains undetected", ""];
                    DAKKA_Task1_detected = false;
                    _detectedTimer = 0;
                    // hintSilent "Alerted enemies dead.\nYour group keeps undetected";
                    _reporter = objNull;
                    if (count _enemyGroups > 0) then {
                        _reporter = leader (selectRandom _enemyGroups);
                    };
                    _report = selectRandom [
                        "<I don't like this. Keep your eyes open.>",
                        "<People are twitchy today... Probably a rabbit.>",
                        "<Please, update the last contact report... Do you copy?>"
                        ];
                    if (!isNull _reporter) then {
                        [_reporter, _report, _fnc_enemyRadio] spawn {
                            params ["_reporter", "_report", "_fnc_enemyRadio"];;
                            sleep (10 + (random 30));
                            [_reporter, _report, false] spawn _fnc_enemyRadio;
                        };
                    };
                    _keepSearchingWarned = false;
                    _timeOfDetection = 0;
                };
            };
		};

		// Outpost located check
		if (!DAKKA_Task1_1_done) then {
			if ((_timer % 3) == 0) then {
				private _nearOutpost = false;
				{
					if (((vehicle _x) distance DAKKA_task1_locPos) <= 100) exitWith {
						_nearOutpost = true;
					};
				} forEach (units DAKKA_PlayerNewGroup);
				private _visCheck = [units DAKKA_PlayerNewGroup, (AGLToASL DAKKA_task1_locPos) vectorAdd [0, 0, 2.5], 100] call DAKKA_fnc_targetVisible;
                if (DAKKA_debug) then { systemChat format ["DAKKA: Task1 flow - _visCheck: %1", _visCheck] };
				if (_visCheck select 0) then {
					_outpostVisibleTimer = _outpostVisibleTimer + 1;
				} else {
					_outpostVisibleTimer = 0;
				};
				// Must be visible for 3 seconds or player group is close to outpost
				if (((_visCheck select 0) && _outpostVisibleTimer > 1) || _nearOutpost) then {
                    (_visCheck select 1) groupRadio "SentContact";
					DAKKA_Task1_1_done = true;   
					"DAKKA_mrkr_Task1_searchArea" setMarkerPos DAKKA_task1_locPos;   
                    private _behaviour = ""; 
                    private _combatMode = "WHITE"; 
                    if (((vehicle leader DAKKA_PlayerNewGroup) distance DAKKA_task1_locPos) <= 300) then { 
                        _behaviour = "COMBAT"; 
                        _combatMode = "RED"; 
                    };
					[DAKKA_PlayerNewGroup, DAKKA_task1_locPos, 0, -1, "", "SAD", _behaviour, "", "WEDGE", _combatMode, 30, "CLEAR AREA"] call DAKKA_fnc_GroupWp;
                    // [DAKKA_PlayerNewGroup, DAKKA_task1_locPos, 0, -1, "", "SAD", "COMBAT", "NORMAL", "WEDGE", "RED", 30, "CLEAR AREA"] call DAKKA_fnc_GroupWp;
					["DAKKA_Task1_1", "SUCCEEDED", true] call BIS_fnc_taskSetState;
					{ _x addRating 500; } forEach (units DAKKA_PlayerNewGroup);
					// Task 1-2
					_title = "Eliminate hostiles";
					_description = "Eliminate all hostile presence in <marker name='DAKKA_mrkr_Task1_searchArea'>the area</marker>.";
					_marker = "";
					_task1_2 = [DAKKA_PlayerNewGroup, ["DAKKA_Task1_2", "DAKKA_Task1"], [_description, _title, _marker], objNull, "ASSIGNED", -1, true, "attack", false] call BIS_fnc_taskCreate;

					// Update location
					DAKKA_task1_location setPosition DAKKA_task1_locPos;
					DAKKA_task1_location setText "Enemy Outpost";
				};
			};
		};

		// No enemies present near the outpost
		if (DAKKA_Task1_1_done) then {
			// Player group has to be close to start the check
			if (((getPos leader DAKKA_PlayerNewGroup) distance DAKKA_task1_locPos) <= 100)  then {
	            private _enemyUnits = [];
	            {
	                _enemyUnits append ((units _x) select {alive _x});
	            } forEach _enemyGroups;
            	private _enemiesInOutpost = _enemyUnits inAreaArray "DAKKA_mrkr_Task1_searchArea";
            	if (count _enemiesInOutpost == 0) then {
                    _noEnemiesInOupostTimer = _noEnemiesInOupostTimer + 1;
                    if (_noEnemiesInOupostTimer >= _maxTimeNoEnemiesInOutpost) then {
                        DAKKA_Task1_2_done = true;
                    };
                } else {
                    _noEnemiesInOupostTimer = 0;
                };
			};
		};

		// All hostiles neutralized check
		if (DAKKA_Task1_2_done && !DAKKA_Task1_done) then {
			DAKKA_officer sideRadio "SentGenComplete"; 
			DAKKA_officer sideRadio "SentGenCmdRTB";   
			_exfilDistance = 500;
			_exfilPos = (position vehicle leader DAKKA_PlayerNewGroup) getPos [_exfilDistance + 200, random 360];
			["DAKKA_Task1_End", _exfilPos] call BIS_fnc_taskSetDestination;          
			[DAKKA_task1_locPos, [_exfilDistance, _exfilDistance], "ColorRed", "empty", "Border", "RECTANGLE", 1, ["DAKKA_taskBoundaries"]] call BIS_fnc_markerCreate;          
			deleteMarker "DAKKA_mrkr_Task1_searchArea";    
			// Create exfil wp    
			_exfilWp = [DAKKA_PlayerNewGroup, _exfilPos, 0, -1, "", "MOVE", "AWARE", "NORMAL", "STAG COLUMN", "GREEN", 100, "EXFIL"] call DAKKA_fnc_GroupWp;   
			_exfilWp setWaypointVisible false; 
			_exfilWp showWaypoint "EASY"; 
			DAKKA_Task1_done = true;  
            ["terminate"] call BIS_fnc_jukeBox;
			["DAKKA_Task1_2", "SUCCEEDED", false] call BIS_fnc_taskSetState;
			{ _x addRating 500; } forEach (units DAKKA_PlayerNewGroup);
			// Task 1 End
			_title = "Exfil";
			_description = "Exfiltrate the mission area by any means available.";
			_marker = "";
			_task1_end = [DAKKA_PlayerNewGroup, ["DAKKA_Task1_End", "DAKKA_Task1"], [_description, _title, _marker], objNull, "ASSIGNED", -1, true, "exit", false] call BIS_fnc_taskCreate;

			// Update location
			DAKKA_task1_location setSide west;
			DAKKA_task1_location setType "b_installation";
			DAKKA_task1_location setText "Neutralized Outpost";
		};

		// End Mission - Player group has exfiltrated check
		if (DAKKA_Task1_done) then {
			private _exfiled = false;
			{
				if (((vehicle _x) distance DAKKA_task1_locPos) >= _exfilDistance) exitWith {
					_exfiled = true;
				};
			// } forEach (units DAKKA_PlayerNewGroup);
            } forEach [p1];
			if (_exfiled) then {
				DAKKA_Task1_End_done = true;
				["DAKKA_Task1_End", "SUCCEEDED"] call BIS_fnc_taskSetState;
				{ _x addRating 500; } forEach (units DAKKA_PlayerNewGroup);
				["DAKKA_Task1", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				{ _x addRating 1000; } forEach (units DAKKA_PlayerNewGroup);
				call DAKKA_fnc_endMission;

				sleep 3;
                ["end1", true, true, true, true] call BIS_fnc_endMission;

				diag_log "DAKKA: Task 1 --- END --- ";
            } else {
                // Send reinforcements in
                if (!_reincorcementsArrived) then {
                    diag_log "DAKKA: Enemy reinforcements have arrived!";
                    [leader DAKKA_PlayerNewGroup, leader DAKKA_PlayerNewGroup, east, _reinforcements, 2 + (floor (random 2)), 60 + (random 30), { if ((leader _this) == _this) then { [group _this, DAKKA_PlayerNewGroup, 30, 50, {DAKKA_Task1_End_done}, 1] spawn BIS_fnc_stalk; }; [_this, 1] call DAKKA_fnc_setUnitSkill; }] spawn DAKKA_fnc_spawnEnemy;
                    _reincorcementsArrived = true;
                    // Reveal
                    // - OPFOR
                    {
                        private _unit = _x;
                        {
                            (leader _x) reveal _unit;
                        } forEach DAKKA_defendGrps_task1;
                        {
                            (leader _x) reveal _unit;
                        } forEach DAKKA_patrolGrps_task1;
                    } forEach (allUnits select { side _x == east });
                };
			};
		};


		// Enemy too close check
		if (!DAKKA_Task1_detected && (leader DAKKA_PlayerNewGroup) != p1 && (formation (leader DAKKA_PlayerNewGroup)) != "WEDGE") then {
			if ([DAKKA_PlayerNewGroup, 150] call DAKKA_fnc_enemiesClose) then {
				DAKKA_PlayerNewGroup setBehaviour "COMBAT";  
				DAKKA_PlayerNewGroup setCombatMode "RED";  
				DAKKA_PlayerNewGroup setFormation "WEDGE"; 
			};
		};

		// Enemies alerted check
		if ((_timer % 5) == 0 && _missionTimePassed >= 60) then {
            _deleteGrps = [];
			{     
				// Patrols chase player group
				private _grp = _x;  
	            // Remove from array if all dead
                _aliveUnits = {alive _x} count (units _grp);
	            if (_aliveUnits > 0) then {
                    private _stalking = _grp getVariable "DAKKA_stalking";
					if (DAKKA_Task1_detected && !_stalking) then { 
					   diag_log format ["DAKKA: Group %1 is ALERTED and intercepting player group!", _grp];        
						/*  [_grp, _detectedPlayerPos, 100, 30, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED", 50, "", true, false, [60, 120, 180],
                            ["true","
                            DAKKA_patrolGrps_task1 pushBackUnique (group this);
                            [group this, DAKKA_task1_locPos, 200, [""true"", """"], [], false, false] call DAKKA_fnc_patrolArea;
                            diag_log format [""DAKKA: %1 is resuming patrolling"", group this];
                            "]] call DAKKA_fnc_GroupWp;   */ 
                        _grp setVariable ["DAKKA_stalking", true];
                        _grp setBehaviour "AWARE";
                        _grp setSpeedMode "NORMAL";
                        _grp setCombatMode "RED";
                        [_grp, DAKKA_PlayerNewGroup, 60, random 50, {!DAKKA_Task1_detected || !(_stalkerGroup getVariable "DAKKA_stalking")}, 0] spawn BIS_fnc_stalk;
						// _deleteGrps pushBackUnique _forEachIndex;
                    }; 
                    if (!DAKKA_Task1_detected) then {
                        _grp setVariable ["DAKKA_stalking", false];
                    };

                    // Vehicles with only the driver left will go back to the outpost and become defenders
                    _unit = (units _grp) select 0;
                    if (_aliveUnits == 1 && {!((vehicle _unit) isKindOf "Man") && _unit == driver vehicle _unit}) then {
                        // if !([vehicle _unit] call DAKKA_fnc_isVehicleArmed) then {
                            diag_log format ["DAKKA: %1 has only the driver left and is now returning to outpost and become a defender", _grp];
                            _deleteGrps pushBackUnique _forEachIndex;
                            _grp setVariable ["DAKKA_stalking", false];                        
                            // Go back to outpost
                            [_grp, DAKKA_task1_locPos, 50, -1, "", "MOVE", "COMBAT", "FULL", "", "", 100, "", true, false, [0,0,0], ["true", "
                                (group this) setBehaviour ""COMBAT"";
                                (group this) leaveVehicle (vehicle this);
                                unassignVehicle this;
                                [DAKKA_task1_locPos, thisList, 50, true, true, false, true] call DAKKA_fnc_occupyHouse;
                                DAKKA_defendGrps_task1 pushBack (group this);
                                "]] call DAKKA_fnc_GroupWp;
                        // };
                    };
				};   
			} forEach DAKKA_patrolGrps_task1; 
            // Remove groups
            {
                DAKKA_patrolGrps_task1 deleteAt _x;
            } forEach _deleteGrps;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: DAKKA_patrolGrps_task1: %1", DAKKA_patrolGrps_task1] };

            _deleteGrps = [];
			{     
				// Defenders stay at outpost
				private _grp = _x;  
	            // Remove from array if all dead
	            if (({alive _x} count (units _grp)) > 0) then {
					if (DAKKA_Task1_detected) then { 
						diag_log format ["DAKKA: Group %1 is ALERTED and staying at oupost!", _grp];        
						[_grp, DAKKA_task1_locPos, 0, 0, "", "HOLD", "COMBAT", "FULL", "WEDGE", "YELLOW", 50] call DAKKA_fnc_GroupWp;      
						_deleteGrps pushBackUnique _forEachIndex; 
                        if (random 1 > 0.5) then {
                            // (leader _grp) globalRadio "SentGenCmdDefend";
                        };    
                    } else {
                        if (behaviour (leader _grp) != "COMBAT") then {
                            if (random 1 > 0.9) then {
                                [leader _grp, "SentClear"] spawn _fnc_enemyRadio;
                            };  
                        };         
					};    
				};
			} forEach DAKKA_defendGrps_task1; 
            // Remove groups
            {
                DAKKA_defendGrps_task1 deleteAt _x;
            } forEach _deleteGrps;
		};

		// Loop wait
		sleep 1;
		_timer = _timer + 1;
	};
};