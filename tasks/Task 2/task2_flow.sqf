// TASK 2
// Flow
#include "..\..\control_defines.hpp"

disableSerialization; 
20000 cutRsc ["DAKKA_GUI_Dialog_Task", "PLAIN"];

_task_2_checks = [] spawn {
    private _display = uiNamespace getVariable "DAKKA_Dialog_Task"; 
    private _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
    private _owner = "Unknown";
    private _color = ["Map", _owner] call BIS_fnc_displayColorGet;
    private _timer = 0;
    private _timerPosition = "bottom";
    private _friendlyGroups = DAKKA_B_InfGrps + DAKKA_B_LandGrps;
    private _enemyGroups = DAKKA_O_InfGrps + DAKKA_O_LandGrps;
    private _startCountingFrly = false;
    private _startCountingEnmy = false;
    private _timeCounterFrly = 0;
    private _timeCounterEnmy = 0;
    private _maxTime = selectRandom [60, 90, 120];
    private _noFriendlies = false;
    private _noEnemies = false;
    private _defeated = false;

    // Functions
    _fnc_showTimer = {
        if (DAKKA_cinematics || Vile_HUD_HIDDEN) exitWith { false };
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_AREAHOLDER;
        _ctrl ctrlSetText "Area holder:";
        _ctrl ctrlSetBackgroundColor [0,0,0,0.5];
        _ctrl ctrlshow true;
        _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
        _ctrl ctrlshow true;
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
        _ctrl ctrlSetBackgroundColor [0,0,0,0.5];
        _ctrl ctrlshow true;
    };
    _fnc_hideTimer = {
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_AREAHOLDER;
        _ctrl ctrlshow false;
        _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
        _ctrl ctrlshow false;
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
        _ctrl ctrlSetText "";
        _ctrl ctrlSetBackgroundColor [0,0,0,0];
        _ctrl ctrlshow false;
    };
    _fnc_popupTimer = {
        // Move timer to top and enbiggen
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
        _ctrl ctrlSetPosition[
            (( safeZoneX + ( safeZoneW / 2 )) - ( pixelW * pixelGridNoUIScale * -24 )),
            safezoneY + ((0 * pixelGridNoUIScale * pixelH)),
            4 * pixelGridNoUIScale * pixelW,
            1 * pixelGridNoUIScale * pixelH 
        ];
        _ctrl ctrlSetFontHeight (((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5);
        _ctrl ctrlSetBackgroundColor [0,0,0,1];
        _ctrl ctrlCommit 0.1;
    };
    _fnc_resetTimerPos = {
        // Reset timer position
        _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
        _ctrl ctrlSetText "";
        _ctrl ctrlSetPosition[
            safezoneX + (safezoneW - (4 * pixelGridNoUIScale * pixelW)),
            safezoneY + (safezoneH - (1 * pixelGridNoUIScale * pixelH)),
            4 * pixelGridNoUIScale * pixelW,
            1 * pixelGridNoUIScale * pixelH 
        ];
        _ctrl ctrlSetFontHeight (((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5);
        _ctrl ctrlSetBackgroundColor [0,0,0,0];
        _ctrl ctrlCommit 0.1;
    };

    while { !DAKKA_Task2_done } do {
        // Remove empty groups
        _enemyGroups = _enemyGroups - [grpNull];
        
        // GUI fix
        if (DAKKA_loadedSavegame) then {
            // Mission loaded from save
            // Show timer GUI
            20000 cutRsc ["DAKKA_GUI_Dialog_Task", "PLAIN"]; 
            _display = uiNamespace getVariable "DAKKA_Dialog_Task"; 

            // Hide timer counter (it'll be updated shortly if it's actually running)
            _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
            _ctrl ctrlSetText "";

            if (_timerPosition == "top") then {
                call _fnc_popupTimer;
            };

            "DAKKA_mrkr_Task2_location_area" setMarkerColor format ["Color%1", _owner];
            // Set the bar color to the current owner
            _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
            _color = ["Map", _owner] call BIS_fnc_displayColorGet;
            _ctrl ctrlSetText format ["#(rgb,8,8,3)color(%1,%2,%3,0.5)", _color select 0, _color select 1, _color select 2];

            // Resume dynamic music
            ["initialize",
                [
                    [ // stealth
                        "LeadTrack06_F_EPC",
                        "EventTrack03_F_EPB",
                        "AmbientTrack04_F",
                        "EventTrack03a_F_EPB"
                    ],
                    [ // combat
                        "AmbientTrack01a_F_Tacops",
                        "EventTrack01a_F_Tacops",
                        "EventTrack01b_F_Tacops",
                        "EventTrack02a_F_Tacops",
                        "EventTrack02b_F_Tacops",
                        "EventTrack03a_F_Tacops",
                        "EventTrack03b_F_Tacops"
                    ],
                    [ // safe
                    ],
                    0.5, // volume
                    5, // transition
                    500, // radius
                    5, // execution rate
                    true // no repeat
                ]
            ] call BIS_fnc_jukebox;

            //
            DAKKA_loadedSavegame = false;
        };

        _missionTimePassed = time - DAKKA_missionStartTime;
        if (!DAKKA_Task2_1_done) then {
            // Reset timer settings
            call _fnc_showTimer;
            "DAKKA_mrkr_Task2_location_area" setMarkerColor format ["Color%1", _owner];
            _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
            _ctrl ctrlSetText format ["#(rgb,8,8,3)color(%1,%2,%3,0.5)", _color select 0, _color select 1, _color select 2];
            
            // Check if enemies are in contested area
            private _enemyUnits = [];
            {
                _enemyUnits append ((units _x) select {alive _x});
            } forEach _enemyGroups;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: Task 2 - _enemyUnits: %1", _enemyUnits] };
            private _inContestedArea = _enemyUnits inAreaArray "DAKKA_mrkr_Task2_location_area";
            if (_startCountingEnmy) then {
                if (count _inContestedArea == 0) then {
                    call _fnc_showTimer;
                    if (count _enemyGroups == 0) then {
                        _maxTime = 30
                    };
                    if (_timeCounterEnmy == 0) then {
                        hintSilent "All enemies are dead or retreating!";
                    };
                    if (_timeCounterEnmy == 10) then {
                        hintSilent "";
                    };
                    private _remainingTime = _maxTime - _timeCounterEnmy;
                    if (_remainingTime == 30) then {
                        _timerPosition = "top";
                        call _fnc_popupTimer;
                        2 fadeMusic 0.5;
                        //playMusic "LeadTrack05_F";
                        ["playMusic", ["LeadTrack05_F"]] call BIS_fnc_jukebox;
                    };
                    "DAKKA_mrkr_Task2_location_area" setMarkerColor "ColorWEST";
                    _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
                    _owner = "BLUFOR";
                    _color = ["Map", _owner] call BIS_fnc_displayColorGet;
                    _ctrl ctrlSetText format ["#(rgb,8,8,3)color(%1,%2,%3,0.5)", _color select 0, _color select 1, _color select 2];
                    _noEnemies = true;
                    // hintSilent format ["All enemies dead or retreating!\nRemaining time:\n%1 seconds", _maxTime - _timeCounterEnmy];
                    _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
                    private _timeLeft = [_remainingTime, "MM:SS"] call BIS_fnc_secondsToString;
                    _ctrl ctrlSetText _timeLeft;
                    if (_timeCounterEnmy >= _maxTime) then {
                        _defeated = false;
                        DAKKA_Task2_1_done = true;
                    };
                    _timeCounterEnmy = _timeCounterEnmy + 1;
                } else {
                    if (_timeCounterEnmy > 0) then {
                        DAKKA_officer sideRadio "SentGenLosing";
                        hintSilent format ["Enemies have entered the contested area!", ""];
                        _timerPosition = "bottom";
                        call _fnc_resetTimerPos;
                        2 fadeMusic 0;
                        _timeCounterEnmy = 0;
                        sleep 3;
                        hintSilent "";
                    };

                    if ((markerColor "DAKKA_mrkr_Task2_location_area") != "colorEAST") then {
                        "DAKKA_mrkr_Task2_location_area" setMarkerColor "ColorEAST";
                        call _fnc_showTimer;
                        _ctrl = _display displayCtrl IDC_IMG_TASK2_COUNTER_AREAHOLDER;
                        _owner = "OPFOR";
                        _color = ["Map", _owner] call BIS_fnc_displayColorGet;
                        _ctrl ctrlSetText format ["#(rgb,8,8,3)color(%1,%2,%3,0.5)", _color select 0, _color select 1, _color select 2];
                        _noEnemies = false;
                    };

                };
            } else {
                // Only start counting after the first enemy has entered the area or if 5 minutes have passed since the start of the mission
                if (count _inContestedArea > 0 || _missionTimePassed > 300) then {
                    _startCountingEnmy = true;
                    call _fnc_showTimer;
                };
                call _fnc_hideTimer;
            }; 

            // Check if friendlies are in the contested area
            private _friendlyUnits = [];
            {
                _friendlyUnits append ((units _x) select {alive _x});
            } forEach _friendlyGroups;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: Task 2 - _enemyUnits: %1", _enemyUnits] };
            private _inContestedArea = _friendlyUnits inAreaArray "DAKKA_mrkr_Task2_location_area";
            if (_startCountingFrly) then {
                if (count _inContestedArea == 0) then {
                    call _fnc_showTimer;
                    if (_timeCounterFrly == 0) then {
                        DAKKA_officer sideRadio "SentGenLosing";
                        hintSilent format ["The contested area is undefended!", ""];
                    };
                    private _remainingTime = _maxTime - _timeCounterFrly;
                    if (_remainingTime == 30) then {
                        _timerPosition = "top";
                        call _fnc_popupTimer;
                        2 fadeMusic 0.5;
                        // playMusic "Defcon";
                        ["playMusic", ["Defcon"]] call BIS_fnc_jukebox;
                    };
                    _noFriendlies = true;
                    // hintSilent format ["No friendlies defending the contested area!\nRemaining time:\n%1 seconds", _maxTime - _timeCounterFrly];
                    _ctrl = _display displayCtrl IDC_TXT_TASK2_COUNTER_TIMER;
                    private _timeLeft = [_remainingTime, "MM:SS"] call BIS_fnc_secondsToString;
                    _ctrl ctrlSetText _timeLeft;
                    if (_timeCounterFrly >= _maxTime) then {
                        _defeated = true;
                        DAKKA_Task2_1_done = true;
                    };
                    _timeCounterFrly = _timeCounterFrly + 1;
                } else {
                    if (_timeCounterFrly > 0) then {
                        _timerPosition = "bottom";
                        call _fnc_resetTimerPos;
                        hintSilent "";
                        2 fadeMusic 0;
                        _noFriendlies = false;
                        _timeCounterFrly = 0;
                    };
                };
            } else {
                // Only start counting after the first friendly has entered the area or 5 minutes have passed since the start of the mission
                if (count _inContestedArea > 0 || _missionTimePassed > 300) then {
                    _startCountingFrly = true;
                };
                if (_missionTimePassed > 30) then {
                    if (DAKKA_cinematics) then {
                        [DAKKA_SupportReq, "Artillery", 0] call BIS_fnc_limitSupport;
                    };
                };
            };  
        };

        // End Mission
        if (DAKKA_Task2_1_done) then {
            hintSilent "";
            // Hide timer
            call _fnc_hideTimer;
            DAKKA_Task2_done = true;
            if (!_defeated) then {
                // Friendlies won
                DAKKA_officer sideRadio "SentGenComplete"; 
                ["DAKKA_Task2_1", "SUCCEEDED"] call BIS_fnc_taskSetState;
                { _x addRating 500; } forEach (units DAKKA_PlayerNewGroup);
                ["DAKKA_Task2", "SUCCEEDED", false] call BIS_fnc_taskSetState;
                { _x addRating 1000; } forEach (units DAKKA_PlayerNewGroup);
                call DAKKA_fnc_endMission;

                sleep 3;
                ["end1"] call BIS_fnc_endMission;
            } else {
                // Enemies won
                DAKKA_officer sideRadio "SentGenLost"; 
                ["DAKKA_Task2_1", "FAILED"] call BIS_fnc_taskSetState;
                { _x addRating -500; } forEach (units DAKKA_PlayerNewGroup);
                ["DAKKA_Task2", "FAILED", false] call BIS_fnc_taskSetState;
                { _x addRating -1000; } forEach (units DAKKA_PlayerNewGroup);
                call DAKKA_fnc_endMission;

                sleep 3;
                ["end1", false] call BIS_fnc_endMission;
            };

            diag_log "DAKKA: Task 2 --- END --- ";
        };

        // Force more consistent fleeing behaviour
        if ((_timer % 5) == 0) then {
            private _deleteGrps = [];
            {   
                private _grp = _x;
                // Remove from array if all dead
                _aliveUnits = {alive _x} count (units _grp);
                if (_aliveUnits == 0) then {
                    _deleteGrps pushback _forEachIndex;
                } else {
                    if (fleeing (leader _grp)) then {  
                        // DISABLE AI MODS
                        // Vcom AI
                        _grp setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
                        // (group _x) setVariable ["VCM_DisableForm",true]; //This command will disable AI group from changing formations.
                        // (group _x) setVariable ["VCM_Skilldisable",true]; //This command will disable an AI group from being impacted by Vcom AI skill changes.
                        // (group _x) setVariable ["VCM_NOFLANK",true]; //This command will stop the AI squad from executing advanced movement maneuvers.
                        // (group _x) setVariable ["VCM_NORESCUE",true]; //This command will stop the AI squad from responding to calls for backup.
                        // (group _x) setVariable ["VCM_TOUGHSQUAD",true]; //This command will stop the AI squad from calling for backup.
                        diag_log format ["DAKKA: Group %1 is FLEEING!", _grp]; 

                        _grp setCombatBehaviour "AWARE";
                        _grp setCombatMode "WHITE";
                        _grp setSpeedMode "FULL";

                        private _destination = DAKKA_task2_locPos getPos [1000, DAKKA_task2_locDir];

                        {
                            private _veh = vehicle _x;
                            if (_x == effectiveCommander _veh) then {
                                _grp leaveVehicle _veh;

                                _x disableAI "TARGET";
                                _x disableAI "AUTOTARGET";
                                _x disableAI "FSM";
                                _x disableAI "SUPPRESSION";
                                _x disableAI "COVER";
                                _x disableAI "AUTOCOMBAT";

                                _x enableAI "MOVE";

                                unassignVehicle _x;
                                
                                _x removeAllEventHandlers "FiredNear";
                                _x forceSpeed -1;
                                _x doFollow leader _grp;

                                // _x setCaptive true;
                                
                                // DISABLE AI MODS
                                // LAMBS Danger
                                _x setVariable ["lambs_danger_disableAI", true];
                                
                                if (_veh != _x) then {
                                    {
                                        _x disableAI "TARGET";
                                        _x disableAI "AUTOTARGET";
                                        _x disableAI "FSM";
                                        _x disableAI "SUPPRESSION";
                                        _x disableAI "COVER";
                                        _x disableAI "AUTOCOMBAT";

                                        _x enableAI "MOVE";

                                        unassignVehicle _x;

                                        _x removeAllEventHandlers "FiredNear";
                                        _x forceSpeed -1;
                                        _x doFollow leader _grp;

                                        // _x setCaptive true;
                                
                                        // DISABLE AI MODS
                                        // LAMBS Danger
                                        _x setVariable ["lambs_danger_disableAI", true];
                                    } forEach (crew _veh);
                                };
                            
                                // Fix for when AI refuses to move
                                _x doMove _destination;
                            };
                        } forEach (units _grp); 
                        [_grp, _destination, 100, -1, "", "MOVE", "AWARE", "FULL" ,"WEDGE", "WHITE", 300, "", true, true, [0,0,0], ["true", "{ _x setUnitPos ""DOWN""; _x disableAI ""MOVE""; } forEach (units this);"]] call DAKKA_fnc_GroupWp;

                        _deleteGrps pushback _forEachIndex;
                    } else {
                        // Force enemies to attack player if x minutes have passed
                        private _minutes = 15;
                        if (_missionTimePassed > (_minutes * 60)) then {
                            diag_log "DAKKA: All enemies are moving towards the player group!";
                            // Reset unit (in case of being affected by occupyHouse function)
                            {
                                _x enableAI "TARGET";
                                _x removeAllEventHandlers "FiredNear";
                                _x forceSpeed -1;
                                _x doFollow leader _grp;
                            } forEach (units _grp);
                            // Move the group near the player position
                            // [_grp, position (vehicle leader DAKKA_PlayerNewGroup), 100, 30, "", "SAD", "COMBAT", "FULL", "", "RED", 50] call DAKKA_fnc_GroupWp; 
                            [_grp, DAKKA_PlayerNewGroup, 30, random 50, {fleeing (leader _stalkerGroup)}, 1] spawn BIS_fnc_stalk;
                        };

                        // Vehicles with only the driver left will flee
                        _unit = (units _grp) select 0;
                        if (_aliveUnits == 1 && {!((vehicle _unit) isKindOf "Man") && _unit == driver vehicle _unit}) then {
                            if !([vehicle _unit] call DAKKA_fnc_isVehicleArmed) then {
                                diag_log format ["DAKKA: %1 has only the driver left and is now fleeing", _grp];
                                // Flee
                                _grp allowFleeing 1;
                            };
                        };
                    };
                }; 
            } forEach _enemyGroups;
            // Remove groups
            {
                _enemyGroups deleteAt _x;
            } forEach _deleteGrps;
        };

		// Loop wait
		sleep 1;
        _timer = _timer + 1;
	};
};