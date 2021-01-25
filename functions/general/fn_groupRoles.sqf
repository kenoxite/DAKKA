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

if (count _unitClasses == 0) exitWith { diag_log format ["DMORBAT: groupRoles --- ERROR --- No unit classes or group has been passed"]; if (_roleCheck != "") then { false } else { [] } };

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

private _SFvehicleClasses = [
        "MenRecon",
        "rhs_vehclass_MARSOC",
        "rhs_vehclass_infantry_recon"
    ];

private _return = false;

// Array of class names
{
    if (_x isKindOf "Man") then {
        private _config = configFile >> "CfgVehicles" >> _x;
        private _name = getText (_config >> "displayName");
        private _role = getText (_config >> "role");
        private _icon = getText (_config >> "icon");
        private _hacker = getNumber (_config >> "uavHacker") == 1;
        private _vehicleClass = getText (_config >> "vehicleClass");
        if (_role == "MachineGunner" || "_ar" in _x || "autorifleman" in _x || "machinegunner" in _x) then { _hasMG = true };
        if (_role == "Grenadier" || "grenadier" in _x || "_gl" in _x) then { _hasGrenadier = true };
        if (_role == "Unarmed") then { _hasUnarmed = true };
        // if (_role == "Sapper") then { _hasEngi = true };
        // if (_role == "SpecialOperative") then { _hasSF = true };
        if (_role == "Assistant") then { _hasAssistant = true };

        if (_icon == "iconManLeader" || "_sl" in _x || "_squadleader" in _x) then { _hasLeader = true };
        if (_icon == "iconManOfficer" || "officer" in _x || "general" in _x) then { _hasOfficer = true };
        if (_icon == "iconManExplosive") then { _hasDemo = true };
        if (_icon == "iconManEngineer") then { _hasEngi = true };
        if (_icon == "iconManMedic" || _role == "CombatLifeSaver" || "medic" in _x) then { _hasMedic = true };
        if (_icon == "iconManAT" || _role == "MissileSpecialist" || "_at" in _x || "_aa" in _x || "_rpg" in _x) then {
            private _threat = getArray (_config >> "threat");
            if (count _threat > 0) then {
                if ((_threat select 2) >= 0.9 || "_aa" in _x) then {
                    _hasAA = true;
                } else {
                    _hasAT = true;
                };
            };
        };
        if (_hacker) then { _hasHacker = true };
        if (_vehicleClass == "MenDiver" || "diver" in _x) then { _hasDiver = true };
        if (_role == "Marksman" || "marksman" in _x) then {
            if (_vehicleClass == "MenSniper") then {
                _hasSniper = true;
            } else {
                _hasMarksman = true;
            };
        };
        if (_vehicleClass in _SFvehicleClasses) then { _hasSF = true };
        if (_role == "Crewman" || "crew" in _x) then { _hasCrew = true };

        if (_roleCheck != "") then {
            if (call compile format ["%1"]) exitWith { _return = true };
        };
    };
} forEach _unitClasses;

if (_roleCheck != "") then {
    _return
} else {
    [_hasAT, _hasAA, _hasMedic, _hasMG, _hasGrenadier, _hasMarksman, _hasUnarmed, _hasEngi, _hasDemo, _hasLeader, _hasOfficer, _hasHacker, _hasDiver, _hasSF, _hasSniper, _hasCrew, _hasAssistant]
}
