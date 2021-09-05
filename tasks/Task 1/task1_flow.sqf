// TASK 1
// Flow

// DMORBAT_task1_locPos = _this select 0;

_task_1_checks = [] spawn {
    private _enemyGroups = +DMORBAT_patrolGrps_task1 + DMORBAT_defendGrps_task1;
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


    {
        {
            _reinforcements pushBackUnique [(typeOf _x), getUnitLoadout _x, 1];
        } forEach (units _x);
        _x setVariable ["DMORBAT_stalking", false];
    } forEach _enemyGroups;
    private _reincorcementsArrived = false;

    // Immunity
    {
        _x setCaptive false;
    } forEach (units DMORBAT_PlayerNewGroup);

	while { !DMORBAT_Task1_End_done } do {
        _missionTimePassed = time - DMORBAT_missionStartTime;

        // Remove immunity
        if (DMORBAT_Task1_init && _missionTimePassed >= 30) then {
            {
                _x setCaptive false;
            } forEach (units DMORBAT_PlayerNewGroup);
        };

        // PATROLS
        // Remove empty groups
        DMORBAT_patrolGrps_task1 = DMORBAT_patrolGrps_task1 - [grpNull];
        // Check for dead groups
        _deleteGrps = [];
        {
            if (({alive _x} count (units _x)) == 0) then {
                _deleteGrps pushBackUnique _forEachIndex;
            };
        } forEach DMORBAT_patrolGrps_task1;
        // Remove dead groups
        {
            DMORBAT_patrolGrps_task1 deleteAt _x;
        } forEach _deleteGrps;

        // DEFENDERS
        // Remove empty groups
        DMORBAT_defendGrps_task1 = DMORBAT_defendGrps_task1 - [grpNull];
        // Check for dead groups
        _deleteGrps = [];
        {
            if (({alive _x} count (units _x)) == 0) then {
                _deleteGrps pushBackUnique _forEachIndex;
            };
        } forEach DMORBAT_defendGrps_task1;
        // Remove dead groups
        {
            DMORBAT_defendGrps_task1 deleteAt _x;
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
		if (DMORBAT_Task1_init && _missionTimePassed >= 60) then {
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
                private _nearestEnemy = (leader _x) findNearestEnemy (position vehicle leader DMORBAT_PlayerNewGroup);
                private _playerDetected = _nearestEnemy in (units DMORBAT_PlayerNewGroup);
                if (_playerDetected) then {
                    _detectors pushBackUnique _x;
                    private _knowsAbout = (leader _x) knowsAbout (vehicle leader DMORBAT_PlayerNewGroup);
                    if (_knowsAbout > 3) then {
                        // _detectedPlayerPos = position vehicle leader DMORBAT_PlayerNewGroup;
                    };
                // diag_log format ["DMORBAT: %1 knowsAbout: %2", _x, (leader _x) knowsAbout (vehicle leader DMORBAT_PlayerNewGroup)];
                };
			} forEach _enemyGroups;
                // diag_log format ["DMORBAT: _detectors: %1", _detectors];

            // Count time since last detection
            if (count _detectors > 0) then {
                // ENEMIES ARE DETECTING THE PLAYER GROUP
                if (!DMORBAT_Task1_detected) then {
                    if (_detectedTimer == 0) then {
                        diag_log format ["DMORBAT: Player was detected by %1", str _detectors];
                        // hintSilent "Your group has been spotted!\nThey will alert the rest in a few seconds!";
                        // Delay alert a bit to make it feel more natural
                        _reporter = leader (_detectors select 0);
                        [_reporter, _enemyGroups] spawn {
                            private _reporter = _this select 0;
                            private _enemyGroups = _this select 1;
                            sleep (2 + (random 2));
                            if (!alive _reporter || !([_reporter] call DMORBAT_fnc_isMan)) then {
                                _reporter = leader (selectRandom _enemyGroups);
                            };
                            _reporter globalRadio "SentContact";
                        };
                        _detectedPlayerPos = position vehicle leader DMORBAT_PlayerNewGroup;
                    };
                    if (_detectedTimer < _detectedMaxTime) then {
                        _detectedTimer = _detectedTimer + 1;
                    } else {
                        diag_log format ["DMORBAT: _detectors: %1", _detectors];
                        diag_log format ["DMORBAT: Enemies are alerted", ""];
                        DMORBAT_Task1_detected = true;
                        _timeOfDetection = time;
                        // hintSilent "Your group has been spotted!";
                        if (count _enemyGroups > 0) then {
                            _reporter = leader (selectRandom _enemyGroups);
                            diag_log format ["DMORBAT: %1 is alerting to patrols", _reporter];
                            if (!isNull _reporter) then {
                                _reporter globalRadio "SentGenCmdTargetNeutralize";
                                _alerted = DMORBAT_patrolGrps_task1 - [group _reporter];
                                {
                                    (leader _x) globalRadio "SentNotifyAttack";
                                } forEach _alerted;

                                diag_log format ["DMORBAT: %1 is alerting to defenders", _reporter];
                                _reporter globalRadio "SentGenCmdDefend";
                                _alerted = DMORBAT_defendGrps_task1 - [group _reporter];
                                {
                                    (leader _x) globalRadio "SentConfirmMove";
                                } forEach _alerted;
                            };
                        };

                        if ((leader DMORBAT_PlayerNewGroup) != p1) then {
                            DMORBAT_PlayerNewGroup setBehaviour "COMBAT";  
                            DMORBAT_PlayerNewGroup setCombatMode "RED";  
                            DMORBAT_PlayerNewGroup setFormation "WEDGE";
                        };
                    };
                };
            } else {
                // NO ENEMIES ARE DETECTING THE PLAYER GROUP
                // Enemies alerted and searching but player group not detected
                if (DMORBAT_Task1_detected && !_keepSearchingWarned) then {
                    diag_log format ["DMORBAT: Enemies are still alerted and searching, but player group remains undetected", ""];
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
                        [_reporter, _report] spawn {
                            private _reporter = _this select 0;
                            private _report = _this select 1;
                            sleep (10 + (random 30));
                            _reporter globalChat _report;
                        };
                    };
                    _keepSearchingWarned = true;

                };
                // Enemies alerted but a lot of time has passed without the player group being detected
                if (DMORBAT_Task1_detected && (time - _timeOfDetection) > 300) then {
                    diag_log format ["DMORBAT: Alerted enemies have resumed patrolling. Player group remains undetected", ""];
                    DMORBAT_Task1_detected = false;
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
                        [_reporter, _report] spawn {
                            private _reporter = _this select 0;
                            private _report = _this select 1;
                            sleep (10 + (random 30));
                            _reporter globalChat _report;
                        };
                    };
                    _keepSearchingWarned = false;
                    _timeOfDetection = 0;
                    _detectedTimer = 0;

                };
                // Player group spotted but enemies weren't alerted
                if (!DMORBAT_Task1_detected && _detectedTimer > 0) then {
                    diag_log format ["DMORBAT: Alerted enemies dead. Player group remains undetected", ""];
                    DMORBAT_Task1_detected = false;
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
                        [_reporter, _report] spawn {
                            private _reporter = _this select 0;
                            private _report = _this select 1;
                            sleep (10 + (random 30));
                            _reporter globalChat _report;
                        };
                    };
                    _keepSearchingWarned = false;
                    _timeOfDetection = 0;
                };
            };
		};

		// Outpost located check
		if (!DMORBAT_Task1_1_done) then {
			if ((_timer % 3) == 0) then {
				private _nearOutpost = false;
				{
					if (((vehicle _x) distance DMORBAT_task1_locPos) <= 100) exitWith {
						_nearOutpost = true;
					};
				} forEach (units DMORBAT_PlayerNewGroup);
				private _visCheck = [units DMORBAT_PlayerNewGroup, (AGLToASL DMORBAT_task1_locPos) vectorAdd [0, 0, 2.5], 100] call DMORBAT_fnc_targetVisible;
				if (_visCheck select 0) then {
					_outpostVisibleTimer = _outpostVisibleTimer + 1;
				} else {
					_outpostVisibleTimer = 0;
				};
				// Must be visible for 3 seconds or player group is close to outpost
				if (((_visCheck select 0) && _outpostVisibleTimer > 1) || _nearOutpost) then {
                    (_visCheck select 1) groupRadio "SentContact";
					DMORBAT_Task1_1_done = true;   
					"DMORBAT_mrkr_Task1_searchArea" setMarkerPos DMORBAT_task1_locPos;   
                    private _behaviour = ""; 
                    private _combatMode = "WHITE"; 
                    if (((vehicle leader DMORBAT_PlayerNewGroup) distance DMORBAT_task1_locPos) <= 300) then { 
                        _behaviour = "COMBAT"; 
                        _combatMode = "RED"; 
                    };
					[DMORBAT_PlayerNewGroup, DMORBAT_task1_locPos, 0, -1, "", "SAD", _behaviour, "", "WEDGE", _combatMode, 30, "CLEAR AREA"] call DMORBAT_fnc_GroupWp;
                    // [DMORBAT_PlayerNewGroup, DMORBAT_task1_locPos, 0, -1, "", "SAD", "COMBAT", "NORMAL", "WEDGE", "RED", 30, "CLEAR AREA"] call DMORBAT_fnc_GroupWp;
					["DMORBAT_Task1_1", "SUCCEEDED", true] call BIS_fnc_taskSetState;
					{ _x addRating 500; } forEach (units DMORBAT_PlayerNewGroup);
					// Task 1-2
					_title = "Eliminate hostiles";
					_description = "Eliminate all hostile presence in <marker name='DMORBAT_mrkr_Task1_searchArea'>the area</marker>.";
					_marker = "";
					_task1_2 = [DMORBAT_PlayerNewGroup, ["DMORBAT_Task1_2", "DMORBAT_Task1"], [_description, _title, _marker], objNull, "ASSIGNED", -1, true, "attack", false] call BIS_fnc_taskCreate;

					// Update location
					DMORBAT_task1_location setPosition DMORBAT_task1_locPos;
					DMORBAT_task1_location setText "Enemy Outpost";
				};
			};
		};

		// No enemies present near the outpost
		if (DMORBAT_Task1_1_done) then {
			// Player group has to be close to start the check
			if (((getPos leader DMORBAT_PlayerNewGroup) distance DMORBAT_task1_locPos) <= 100)  then {
	            private _enemyUnits = [];
	            {
	                _enemyUnits append ((units _x) select {alive _x});
	            } forEach _enemyGroups;
            	private _enemiesInOutpost = _enemyUnits inAreaArray "DMORBAT_mrkr_Task1_searchArea";
            	if (count _enemiesInOutpost == 0) then {
                    _noEnemiesInOupostTimer = _noEnemiesInOupostTimer + 1;
                    if (_noEnemiesInOupostTimer >= _maxTimeNoEnemiesInOutpost) then {
                        DMORBAT_Task1_2_done = true;
                    };
                } else {
                    _noEnemiesInOupostTimer = 0;
                };
			};
		};

		// All hostiles neutralized check
		if (DMORBAT_Task1_2_done && !DMORBAT_Task1_done) then {
			DMORBAT_officer sideRadio "SentGenComplete"; 
			DMORBAT_officer sideRadio "SentGenCmdRTB";   
			_exfilDistance = 500;
			_exfilPos = [position vehicle leader DMORBAT_PlayerNewGroup, _exfilDistance + 200, random 360] call BIS_fnc_relPos;
			["DMORBAT_Task1_End", _exfilPos] call BIS_fnc_taskSetDestination;          
			[DMORBAT_task1_locPos, [_exfilDistance, _exfilDistance], "ColorRed", "empty", "Border", "RECTANGLE", 1, ["DMORBAT_taskBoundaries"]] call BIS_fnc_markerCreate;          
			deleteMarker "DMORBAT_mrkr_Task1_searchArea";    
			// Create exfil wp    
			_exfilWp = [DMORBAT_PlayerNewGroup, _exfilPos, 0, -1, "", "MOVE", "AWARE", "NORMAL", "STAG COLUMN", "GREEN", 100, "EXFIL"] call DMORBAT_fnc_GroupWp;   
			_exfilWp setWaypointVisible false; 
			_exfilWp showWaypoint "EASY"; 
			DMORBAT_Task1_done = true;  
			["DMORBAT_Task1_2", "SUCCEEDED", false] call BIS_fnc_taskSetState;
			{ _x addRating 500; } forEach (units DMORBAT_PlayerNewGroup);
			// Task 1 End
			_title = "Exfil";
			_description = "Exfiltrate the mission area by any means available.";
			_marker = "";
			_task1_end = [DMORBAT_PlayerNewGroup, ["DMORBAT_Task1_End", "DMORBAT_Task1"], [_description, _title, _marker], objNull, "ASSIGNED", -1, true, "exit", false] call BIS_fnc_taskCreate;

			// Update location
			DMORBAT_task1_location setSide west;
			DMORBAT_task1_location setType "b_installation";
			DMORBAT_task1_location setText "Neutralized Outpost";
		};

		// End Mission - Player group has exfiltrated check
		if (DMORBAT_Task1_done) then {
			private _exfiled = false;
			{
				if (((vehicle _x) distance DMORBAT_task1_locPos) >= _exfilDistance) exitWith {
					_exfiled = true;
				};
			// } forEach (units DMORBAT_PlayerNewGroup);
            } forEach [p1];
			if (_exfiled) then {
				DMORBAT_Task1_End_done = true;
				["DMORBAT_Task1_End", "SUCCEEDED"] call BIS_fnc_taskSetState;
				{ _x addRating 500; } forEach (units DMORBAT_PlayerNewGroup);
				["DMORBAT_Task1", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				{ _x addRating 1000; } forEach (units DMORBAT_PlayerNewGroup);
				call DMORBAT_fnc_endMission;

				sleep 3;
				"end1" call BIS_fnc_endMission;

				diag_log "DMORBAT: Task 1 --- END --- ";
            } else {
                // Send reinforcements in
                if (!_reincorcementsArrived) then {
                    diag_log "DMORBAT: Enemy reinforcements have arrived!";
                    [leader DMORBAT_PlayerNewGroup, leader DMORBAT_PlayerNewGroup, east, _reinforcements, 2 + (floor (random 2)), 60 + (random 30), { if ((leader _this) == _this) then { [group _this, DMORBAT_PlayerNewGroup, 30, 50, {DMORBAT_Task1_End_done}, 1] spawn BIS_fnc_stalk; }; [_this, 1] call DMORBAT_fnc_setUnitSkill; }] spawn DMORBAT_fnc_spawnEnemy;
                    _reincorcementsArrived = true;
                    // Reveal
                    // - OPFOR
                    {
                        private _unit = _x;
                        {
                            (leader _x) reveal _unit;
                        } forEach DMORBAT_defendGrps_task1;
                        {
                            (leader _x) reveal _unit;
                        } forEach DMORBAT_patrolGrps_task1;
                    } forEach (allUnits select { side _x == east });
                };
			};
		};


		// Enemy too close check
		if (!DMORBAT_Task1_detected && (leader DMORBAT_PlayerNewGroup) != p1 && (formation (leader DMORBAT_PlayerNewGroup)) != "WEDGE") then {
			if ([DMORBAT_PlayerNewGroup, 150] call DMORBAT_fnc_enemiesClose) then {
				DMORBAT_PlayerNewGroup setBehaviour "COMBAT";  
				DMORBAT_PlayerNewGroup setCombatMode "RED";  
				DMORBAT_PlayerNewGroup setFormation "WEDGE"; 
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
                    private _stalking = _grp getVariable "DMORBAT_stalking";
					if (DMORBAT_Task1_detected && !_stalking) then { 
					   diag_log format ["DMORBAT: Group %1 is ALERTED and intercepting player group!", _grp];        
						/*  [_grp, _detectedPlayerPos, 100, 30, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED", 50, "", true, false, [60, 120, 180],
                            ["true","
                            DMORBAT_patrolGrps_task1 pushBackUnique (group this);
                            [group this, DMORBAT_task1_locPos, 200, [""true"", """"], [], false, false] call DMORBAT_fnc_patrolArea;
                            diag_log format [""DMORBAT: %1 is resuming patrolling"", group this];
                            "]] call DMORBAT_fnc_GroupWp;   */ 
                        _grp setVariable ["DMORBAT_stalking", true];
                        _grp setBehaviour "AWARE";
                        _grp setSpeedMode "NORMAL";
                        _grp setCombatMode "RED";
                        [_grp, DMORBAT_PlayerNewGroup, 60, random 50, {!DMORBAT_Task1_detected || !(_stalkerGroup getVariable "DMORBAT_stalking")}, 0] spawn BIS_fnc_stalk;
						// _deleteGrps pushBackUnique _forEachIndex;
                    }; 
                    if (!DMORBAT_Task1_detected) then {
                        _grp setVariable ["DMORBAT_stalking", false];
                    };

                    // Vehicles with only the driver left will go back to the outpost and become defenders
                    _unit = (units _grp) select 0;
                    if (_aliveUnits == 1 && {!((vehicle _unit) isKindOf "Man") && _unit == driver vehicle _unit}) then {
                        // if !([vehicle _unit] call DMORBAT_fnc_isVehicleArmed) then {
                            diag_log format ["DMORBAT: %1 has only the driver left and is now returning to outpost and become a defender", _grp];
                            _deleteGrps pushBackUnique _forEachIndex;
                            _grp setVariable ["DMORBAT_stalking", false];                        
                            // Go back to outpost
                            [_grp, DMORBAT_task1_locPos, 50, -1, "", "MOVE", "COMBAT", "FULL", "", "", 100, "", true, false, [0,0,0], ["true", "
                                (group this) setBehaviour ""COMBAT"";
                                (group this) leaveVehicle (vehicle this);
                                unassignVehicle this;
                                [DMORBAT_task1_locPos, thisList, 50, true, true, false, true] call DMORBAT_fnc_occupyHouse;
                                DMORBAT_defendGrps_task1 pushBack (group this);
                                "]] call DMORBAT_fnc_GroupWp;
                        // };
                    };
				};   
			} forEach DMORBAT_patrolGrps_task1; 
            // Remove groups
            {
                DMORBAT_patrolGrps_task1 deleteAt _x;
            } forEach _deleteGrps;
            // diag_log format ["DMORBAT: DMORBAT_patrolGrps_task1: %1", DMORBAT_patrolGrps_task1];

            _deleteGrps = [];
			{     
				// Defenders stay at outpost
				private _grp = _x;  
	            // Remove from array if all dead
	            if (({alive _x} count (units _grp)) > 0) then {
					if (DMORBAT_Task1_detected) then { 
						diag_log format ["DMORBAT: Group %1 is ALERTED and staying at oupost!", _grp];        
						[_grp, DMORBAT_task1_locPos, 0, 0, "", "HOLD", "COMBAT", "FULL", "WEDGE", "YELLOW", 50] call DMORBAT_fnc_GroupWp;      
						_deleteGrps pushBackUnique _forEachIndex; 
                        if (random 1 > 0.5) then {
                            // (leader _grp) globalRadio "SentGenCmdDefend";
                        };    
                    } else {
                        if (behaviour (leader _grp) != "COMBAT") then {
                            if (random 1 > 0.9) then {
                                (leader _grp) globalRadio "SentClear";
                            };  
                        };         
					};    
				};
			} forEach DMORBAT_defendGrps_task1; 
            // Remove groups
            {
                DMORBAT_defendGrps_task1 deleteAt _x;
            } forEach _deleteGrps;
		};

		// Loop wait
		sleep 1;
		_timer = _timer + 1;
	};
};