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

private _applyFlareFix = [DMORBAT_customDate] call DMORBAT_fnc_isNight;
private _veh = vehicle _unit;
if (_unit == effectiveCommander _veh) then {
    {
        // Set skill
        [_x, _unitSkill] call DMORBAT_fnc_setUnitSkill;
        // Add EH that makes stop the being treated by the player when no healing order has been issued
        [_x] call DMORBAT_fnc_stopAndHeal;
        // Apply flare fix
        if (_applyFlareFix) then {
            _x addEventHandler ["Fired",{private ["_al_flare"]; _al_flare = _this select 6;[[_al_flare],"AL_flare_fix\al_flare_enhance.sqf"] remoteExec ["execVM",0,true]}];
        };
    } forEach (crew _veh);
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
            // if (DMORBAT_debug) then { diag_log format ["DMORBAT: %1 primary weapons: %2 handgun: %3", _unit, primaryWeapon _unit, handgunWeapon _unit] };
            if (primaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                _unit addWeapon "hgun_P07_F";
                _unit addHandgunItem "16Rnd_9x21_Mag";
                for "_i" from 1 to 3 do {_unit addItemToUniform "16Rnd_9x21_Mag";};
            };
            // if (DMORBAT_debug) then { diag_log format ["DMORBAT: %1 primary weapons: %2 handgun: %3", _unit, primaryWeapon _unit, handgunWeapon _unit] };
            // Replace UAV terminals with proper ones for this unit's side
            /*private _side = side _unit;
            private _assignedItems = assignedItems _unit;
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: prepareUnit - %1 _assignedItems: %2", _unit, _assignedItems] };
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
            [_x, DMORBAT_forceFlashlights] call DMORBAT_fnc_useNVGflashlight;
            // RHS single-shot launchers for AI fix
            [_x] call _AIDisposableLauncherFix;
        } forEach (crew _veh);
    };
};