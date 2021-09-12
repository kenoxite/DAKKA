/*
  Author: kenoxite

  Description:
  Returns the roles found in the group or array of classes or if the group has a unit that fulfils a particular role. 


  Parameter (s):
  _this select 0: group or array of classes
  _this select 1: role to be checked, if any

  Returns:
    Array or boolean

  Examples:

*/
params [["_grp", grpNull, [grpNull, []]], ["_roleCheck", ""]];

private _units = [];
private _unitClasses = [];
if (typeName _grp == "GROUP") then {
    _units = units _grp;
    {
      _unitClasses pushBackUnique (typeOf vehicle _x);
    } forEach _units;
} else {
    _unitClasses = _grp;
};

if (count _unitClasses == 0) exitWith { diag_log format ["DAKKA: groupRoles --- ERROR --- No unit classes or group has been passed"]; if (_roleCheck != "") then { false } else { [] } };

private _hasAT = false;
private _hasAA = false;
private _hasMedic = false;
private _hasMG = false;
private _hasGrenadier = false;
private _hasMarksman = false;
private _hasUnarmed = false;
private _hasEngi = false;
private _hasDemo = false;
private _hasSF = false;
private _hasLeader = false;
private _hasOfficer = false;
private _hasHacker = false;
private _hasDiver = false;
private _hasSniper = false;
private _hasCrew = false;
private _hasAssistant = false;
private _hasRadio = false;
private _hasDriver = false;
private _hasPilot = false;
private _hasJTAC = false;
private _hasSpotter = false;
private _hasAutoriflemen = false;

private _SFvehicleClasses = [
        "MenRecon",
        "rhs_vehclass_MARSOC",
        "rhs_vehclass_infantry_recon"
    ];

private _return = false;

// Array of class names
{
    if (_x isKindOf "Man") then {
        private _className = toLowerANSI _x;
        private _config = configFile >> "CfgVehicles" >> _x;
        private _name = getText (_config >> "displayName");
        private _role = getText (_config >> "role");
        private _icon = getText (_config >> "icon");
        private _hacker = getNumber (_config >> "uavHacker") == 1;
        private _vehicleClass = getText (_config >> "vehicleClass");
        private _threat = getArray (_config >> "threat");
        if ((_role == "MachineGunner" || "heavygunner" in _className || "machinegunner" in _className || "_mg" in _className) && !("support" in _className)) then { _hasMG = true };
        if (_role == "Autorifleman" || "_ar" in _className || "autorifleman" in _className) then { _hasAutoriflemen = true };
        if (_role == "Grenadier" || "grenadier" in _className || "_gl" in _className) then { _hasGrenadier = true };
        if (_role == "Unarmed" || "unarmed" in _className || "captive" in _className || "survivor" in _className || "_soldier_light" in _className) then { _hasUnarmed = true };
        if (_role == "Assistant" || "_aaa" in _className || "_aat" in _className || "_amg" in _className || "_aar" in _className || "_ahat" in _className) then { _hasAssistant = true };

        if (_icon == "iconManLeader" || "_sl" in _className || "_squadleader" in _className) then { _hasLeader = true };
        if ((_icon == "iconManOfficer" || "officer" in _className || "general" in _className || "commander" in _className) && !("parade" in _className)) then { _hasOfficer = true };
        if (_icon == "iconManExplosive" || "explosive" in _className || "sapper" in _className || "mine" in _className || "_exp" in _className) then { _hasDemo = true };
        if (_icon == "iconManEngineer" || "engineer" in _className || "repair" in _className) then { _hasEngi = true };
        if (_icon == "iconManMedic" || _role == "CombatLifeSaver" || "medic" in _className) then { _hasMedic = true };
        if ((_threat select 1) > 0.5 || (_threat select 2) > 0.5 || _icon == "iconManAT" || _role == "MissileSpecialist" || "_at" in _className || "_rpg" in _className || "_lat" in _className || "_hat" in _className) then {
            if (((_threat select 2) > 0.5 || _icon == "iconManAA" || _role == "MissileSpecialist" || "_aa" in _className) && !("_aaa" in _className) && !("_aat" in _className) && !("_ar" in _className) && !("_mg" in _className) && !("support" in _className) && !("_at" in _className) && !("_lat" in _className) && !("_hat" in _className)) then {
                _hasAA = true;
            } else {
                if ((_icon == "iconManAT" || _role == "MissileSpecialist") && !("_aa" in _className) && !("_ar" in _className) && !("_mg" in _className) && !("support" in _className)) then {
                    _hasAT = true;
                };
            };
        };
        if (_hacker || "_uav" in _className || "_ugv" in _className) then { _hasHacker = true };
        if (_vehicleClass == "MenDiver" || "diver" in _className) then { _hasDiver = true };
        if (_icon == "iconManSniper" || _role == "Marksman" || "marksman" in _className || "sniper" in _className || "spotter" in _className || "hunter" in _className) then {
            if (_vehicleClass == "MenSniper" || "sniper" in _className) then {
                _hasSniper = true;
            } else {
                if ("spotter" in _className) then {
                    _hasSpotter = true;
                } else {
                    _hasMarksman = true;
                };
            };
        };
        if (_vehicleClass in _SFvehicleClasses || "specop" in _className || "blackop" in _className || "spetsnaz" in _className || "ranger" in _className || "recon" in _className || "marsoc" in _className || "_sf" in _className || "saboteur" in _className || "_sas" in _className) then { _hasSF = true };
        if ((_role == "Crewman" || "crew" in _className) && !("deck" in _className) && !("heli" in _className) && !("driver" in _className) && !("pilot" in _className)) then { _hasCrew = true };
        if ("radio" in _className) then { _hasRadio = true };
        if ("driver" in _className) then { _hasDriver = true };
        if ("pilot" in _className && !("crew" in _className)) then { _hasPilot = true };
        if ("jtac" in _className) then { _hasJTAC = true };

        if (_roleCheck != "") then {
            if (call compile format ["%1"]) exitWith { _return = true };
        };
    };
} forEach _unitClasses;

if (_roleCheck != "") then {
    _return
} else {
    [_hasAT, _hasAA, _hasMedic, _hasMG, _hasGrenadier, _hasMarksman, _hasUnarmed, _hasEngi, _hasDemo, _hasLeader, _hasOfficer, _hasHacker, _hasDiver, _hasSF, _hasSniper, _hasCrew, _hasAssistant, _hasRadio, _hasDriver, _hasPilot, _hasJTAC, _hasSpotter, _hasAutoriflemen]
}
