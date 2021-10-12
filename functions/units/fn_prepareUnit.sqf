/*
  Author: kenoxite

  Description:
   


  Parameter (s):
  _this select 0: 
 

  Returns:
  The new waypoint

  Examples:

*/

params ["_unit", ["_unitLoadout", []], ["_unitSkill", 0]]; 

private _applyFlareFix = [DAKKA_customDate] call DAKKA_fnc_isNight;
private _veh = vehicle _unit;
if (_unit == effectiveCommander _veh) then {
    {
        // Set skill
        [_x, _unitSkill] call DAKKA_fnc_setUnitSkill;
        // Add EH that makes stop the being treated by the player when no healing order has been issued
        [_x] call DAKKA_fnc_stopAndHeal;
        // Apply flare fix
        if (_applyFlareFix) then {
            _x addEventHandler ["Fired",{private ["_al_flare"]; _al_flare = _this select 6;[[_al_flare],"AL_flare_fix\al_flare_enhance.sqf"] remoteExec ["execVM",0,true]}];
        };
    } forEach (crew _veh);
};

// Fatal Wound
FW_fnc_fatalWound = {
    params ["_unit", "_selection", "_damage", "_instigator", "_EHindex"];
    // [_unit,false]remoteExec["allowDamage",_unit];
    _unit removeEventHandler ["HandleDamage", _EHindex];
    if (!alive _unit) exitWith {false};
    if(vehicle _unit != _unit || _unit distance player > 500 || isPlayer _unit) exitWith {
        _unit setVariable ["FW_Killed",true]; 
        [_unit,true]remoteExec["allowDamage",_unit];
        _unit setHit [_selection,1, true, _instigator];
        _unit setHit ["body",1, true, _instigator];
    };
    _unit setCaptive true;

    // Drop weapon, by johnnyboy
    private _weapon = currentWeapon _unit;
    if (_weapon != "") then {    
        _magazine = currentMagazine _unit;
        _unit removeWeapon (currentWeapon _unit);
        sleep .1;
        private _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
        _weaponHolder addWeaponCargoGlobal [_weapon, 1];
        _weaponHolder addMagazineCargoGlobal [_magazine, 1];
        _weaponHolder setPos (_unit modelToWorld [0,.2,1.2]);
        _weaponHolder disableCollisionWith _unit;
        // private _wpnDir = random(360);
        private _wpnDir = getDir _unit;
        private _speed = 1 + (random 2);
        _weaponHolder setVelocity [_speed * sin(_wpnDir), _speed * cos(_wpnDir), 1.5]; 
    };
    
    _nul = [_unit, _selection, _damage, _instigator] spawn {
        params ["_unit", "_selection", "_damage", "_instigator"];
            // systemchat format ["_selection: %1", _selection];
            private _pos = getPos _unit;
            private _dir = getDir _unit;

            private _scream = !(isNil "SSD_fnc_playSound");
        
            // Ragdoll
            // systemchat "Ragdoll";
            _unit setUnconscious true;
            // Play fatal wound anim
            sleep (1 + random 2);
            if (!alive _unit) exitWith {false};
            _unit disableAI "all";
            _unit setUnconscious false;
            sleep 0.1;
            _unit setPos _pos;
            _unit setDir _dir;

        if ((_selection == "head" || _selection == "neck" || _selection == "face_hub") && random 1 <= 0.25) then {
            if (_scream) then { [selectRandom SSD_RattleHead, _unit, 0, 2] call SSD_fnc_playSound };
            private _anim = selectRandom [
                                            "Acts_CivilInjuredHead_1"
                                            ];
            systemchat format ["Head injury anim: %1", _anim];
            _unit switchMove _anim;
            sleep (10 + random 10);
        };

        if (_selection == "spine3") then {
            if (_scream) then { [selectRandom SSD_RattleHeart, _unit, 1, 2] call SSD_fnc_playSound };
            private _anim = selectRandom [
                                            "Acts_InjuredLyingRifle01",
                                            "Acts_InjuredLyingRifle02",
                                            "Acts_InjuredLookingRifle01",
                                            "Acts_InjuredLookingRifle02",
                                            "Acts_InjuredLookingRifle03",
                                            "Acts_InjuredLookingRifle04",
                                            "Acts_InjuredLookingRifle05",
                                            "Acts_InjuredAngryRifle01",
                                            "Acts_InjuredSpeakingRifle01",
                                            "Acts_InjuredCoughRifle02",
                                            "Acts_CivilInjuredChest_1"
                                            ];
            systemchat format ["Chest injury anim: %1", _anim];
            _unit switchMove _anim;
            sleep (3 + random 5);
        };


        if (_selection == "spine1" || _selection == "spine2" || _selection == "pelvis") then {
            if (_scream) then { [selectRandom SSD_RattleStomach, _unit, 2, 2] call SSD_fnc_playSound };
            private _anim = selectRandom [
                                            "Acts_InjuredLyingRifle01",
                                            "Acts_InjuredLyingRifle02",
                                            "Acts_InjuredLookingRifle01",
                                            "Acts_InjuredLookingRifle02",
                                            "Acts_InjuredLookingRifle03",
                                            "Acts_InjuredLookingRifle04",
                                            "Acts_InjuredLookingRifle05",
                                            "Acts_InjuredAngryRifle01",
                                            "Acts_InjuredSpeakingRifle01",
                                            "Acts_InjuredCoughRifle02",
                                            "passenger_flatground_leanleft"
                                            ];
            systemchat format ["Stomach injury anim: %1", _anim];
            _unit switchMove _anim;
            sleep (10 + random 10);
        };

        if (_selection == "legs") then {
            if (_scream) then { [selectRandom SSD_RattleOther, _unit, 3, 2] call SSD_fnc_playSound };
            private _anim = selectRandom [
                                            "Acts_CivilInjuredLegs_1"
                                            ];
            systemchat format ["Leg injury anim: %1", _anim];
            _unit switchMove _anim;
            sleep (10 + random 10);
        };

        if (_selection == "hands") then {
            if (_scream) then { [selectRandom SSD_RattleOther, _unit, 3, 2] call SSD_fnc_playSound };
            private _anim = selectRandom [
                                            "Acts_CivilInjuredArms_1"
                                            ];
            systemchat format ["Arm injury anim: %1", _anim];
            _unit switchMove _anim;
            sleep (10 + random 10);
        };

        if (_selection == "" || _selection == "body") then {
            if (_scream) then { [selectRandom SSD_RattleOther, _unit, 3, 2] call SSD_fnc_playSound };
            private _inBuilding = [false, true] select (count (lineIntersectsWith [ getPosASL _unit, (getPosASL _unit) vectorAdd [0, 0, 20]]) > 0);
            private _type = [ selectRandom ["still", "move"], "still"] select _inBuilding;
            // _type = "move";
            if (_type == "still") then {
                private _anim = selectRandom [
                                                "Acts_InjuredLyingRifle01",
                                                "Acts_InjuredLyingRifle02",
                                                "Acts_InjuredLookingRifle01",
                                                "Acts_InjuredLookingRifle02",
                                                "Acts_InjuredLookingRifle03",
                                                "Acts_InjuredLookingRifle04",
                                                "Acts_InjuredLookingRifle05",
                                                "Acts_InjuredAngryRifle01",
                                                "Acts_InjuredSpeakingRifle01",
                                                "Acts_InjuredCoughRifle02",
                                                "Acts_CivilInjuredGeneral_1",
                                                "passenger_flatground_leanleft"
                                                ];
                systemchat format ["Fatal injury anim: %1", _anim];
                _unit switchMove _anim;
                sleep (10 + random 10);
            };

            if (_type == "move") then {
                private _anim = selectRandom [
                                                ["AmovPpneMsprSlowWrflDf_injured", 10],
                                                ["AmovPpneMsprSnonWnonDf_injured", 12],
                                                // "ApanPpneMrunSnonWnonDfl",   // weapon proxies are wrong
                                                // "ApanPpneMsprSnonWnonDf",   // weapon proxies are wrong
                                                ["ApanPercMsprSnonWnonDf", 8],    // running scared - looks silly
                                                ["ApanPknlMsprSnonWnonDf", 8],    // running scared - looks silly
                                                ["AmovPercMstpSnonWnonDnon_Scared", 4],
                                                ["AmovPercMstpSnonWnonDnon_Scared2", 4],
                                                ["passenger_flatground_leanleft", 4]
                                                ];
                systemchat format ["crawl anim: %1", _anim select 0];
                _unit playMove (_anim select 0);
                sleep (_anim select 1)-0.1;
            };
        }; 

        if (!alive _unit) exitWith {false};
        // Kill unit
        systemchat "Death";
        _unit setUnconscious true;
        sleep 0.1;
        _unit setVariable ["FW_Killed",true]; 
        [_unit,true]remoteExec["allowDamage",_unit];
        _unit setHit [_selection,1, true, _instigator];
        _unit setHit ["body",1, true, _instigator];
        _unit setVelocity [0,0,0];
    };
};

// Apply unscheduled loadout changes so units that change loadout at init EH have time to do their thing
_null = [_unit, _unitLoadout] spawn {
    private _unit = _this select 0;
    private _unitLoadout = _this select 1;

    // Give AI real ammo for disposable launchers
    _AIDisposableLauncherFix = {
        params ["_unit"];
        private _secWep = secondaryWeapon _unit;
        if (_secWep != "" && !(isPlayer _unit)) then {
            private _singleShotLaunchers = [
                "rhs_weap_m72a7",
                "rhs_weap_M136",
                "rhs_weap_M136_hedp",
                "rhs_weap_M136_hp",
                "rhs_weap_rpg26",
                "rhs_weap_rpg18",
                "rhs_weap_rshg2"
            ];
            if (_secWep in _singleShotLaunchers) then {
                private _mag = (getArray (configFile >> "cfgWeapons" >> _secWep >> "magazines")) select 0;
                _unit removeMagazines _mag;
                _unit addMagazine _mag;
                // _unit removeSecondaryWeaponItem _mag;
            };
        };
    };

    sleep 1;

    private _veh = vehicle _unit;
    if (_unit == effectiveCommander _veh) then {
        {
            // Apply loadout
            if (count _unitLoadout > 0) then {
                _x setUnitLoadout [_unitLoadout, true];
            };
            // Give weapons if the unit still doesn't have any
            // if (DAKKA_debug) then { diag_log format ["DAKKA: %1 primary weapons: %2 handgun: %3", _unit, primaryWeapon _unit, handgunWeapon _unit] };
            if (primaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                _unit addWeapon "hgun_P07_F";
                _unit addHandgunItem "16Rnd_9x21_Mag";
                for "_i" from 1 to 3 do {_unit addItemToUniform "16Rnd_9x21_Mag";};
            };
            // if (DAKKA_debug) then { diag_log format ["DAKKA: %1 primary weapons: %2 handgun: %3", _unit, primaryWeapon _unit, handgunWeapon _unit] };
            // Replace UAV terminals with proper ones for this unit's side
            /*private _side = side _unit;
            private _assignedItems = assignedItems _unit;
            if (DAKKA_debug) then { diag_log format ["DAKKA: prepareUnit - %1 _assignedItems: %2", _unit, _assignedItems] };
            if (_side == west) then {
                {
                    if (_x == "O_UavTerminal" || _x == "I_UavTerminal" || _x == "C_UavTerminal" || _x == "I_E_UavTerminal") then {
                        _unit unassignItem _x;
                        _unit removeItem _x;
                        _unit addItem "B_UavTerminal";
                        _unit assignItem "B_UavTerminal";
                    };
                } forEach _assignedItems;
            };
            if (_side == east) then {
                {
                    if (_x == "B_UavTerminal" || _x == "I_UavTerminal" || _x == "C_UavTerminal" || _x == "I_E_UavTerminal") then {
                        _unit unassignItem _x;
                        _unit removeItem _x;
                        _unit addItem "O_UavTerminal";
                        _unit assignItem "O_UavTerminal";
                    };
                } forEach _assignedItems;
            };*/
            // Check for NVGs and flashlights
            [_x, DAKKA_forceFlashlights] spawn DAKKA_fnc_useNVGflashlight;
            // RHS single-shot launchers for AI fix
            [_x] spawn _AIDisposableLauncherFix;


            // Fatal wounds EH
            _x addEventHandler ["HandleDamage",{
                params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
                private _totalDmg = damage _unit + _damage;
                    // systemchat format ["part dmg: %1",_unit getHit _selection];
                if (_selection == "hands" || _selection == "legs") then {
                    _totalDmg = damage _unit;
                };
                if (vehicle _unit == _unit && _unit distance player < 500 && !isPlayer _unit) then {
                    if !(_unit getVariable ["FW_Killed",false]) then {
                        // systemchat format ["_totalDmg: %1",_totalDmg];
                        if(_totalDmg >= 1)then{
                                _damage = 0.99;
                                if!(_unit getVariable ["FW_fatallyWounded",false])then{
                                    [_unit, _selection, _damage, _instigator, _thisEventHandler] spawn FW_fnc_fatalWound;
                                    _unit setVariable ["FW_fatallyWounded",true];  
                                    _unit setVariable ["FW_Killed",false]; 
                                }; 
                            };
                    };  
                };
                _damage
            }]; 

            // Deploy drones
                private _backpack = unitBackpack _x;
                if (!isNull _backpack) then {
                    private _backpackClass = typeOf _backpack;
                    private _parents = [ configFile >> "CfgVehicles" >> _backpackClass, true ] call BIS_fnc_returnParents;
                    private _UVtype = [
                                ["B_UAV_01_backpack_F", "B_UAV_01_F"],
                                ["UAV_06_backpack_base_F", "B_UAV_06_F"],
                                ["UAV_06_medical_backpack_base_F", "B_UAV_06_medical_F"],
                                ["UGV_02_Demining_backpack_base_F", "B_UGV_02_Demining_F"],
                                ["UGV_02_Science_backpack_base_F", "B_UGV_02_Science_F"]
                            ];
                    private _index = _UVtype findIf { (_x select 0) in _parents };
                    if (_index >= 0) then {                
                        removeBackpack _x;
                        private _UVclass = (_UVtype select _index) select 1;
                        private _nul = [_UVclass, _x] spawn {
                            params ["_UVclass", "_unit"];
                            private _UV = createVehicle [_UVclass, getPos _unit, [], 5, ["NONE", "FLY"] select (_UVclass isKindOf "Air")];
                            createVehicleCrew _UV;
                            private _crew = crew _UV;
                            {
                                [_x] joinSilent grpNull;
                            } forEach _crew;
                            _crew joinSilent (group _unit);
                        };
                    };
                };
        } forEach (crew _veh);
    };
};