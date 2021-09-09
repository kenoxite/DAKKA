/*
  Author: kenoxite

  Description:
  Categorizes infantry units based on their role


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/

params [["_infGroups", []], ["_isRegular", true], ["_editorSubCat", ""]];

if (count _infGroups == 0) exitWith { [] };

private _squadLeaders = [];
private _squadLeaders_SF = [];
private _teamLeaders = [];
private _teamLeaders_SF = [];
private _riflemen = [];
private _riflemen_SF = [];
private _riflemenAT = [];
private _riflemenAT_SF = [];
private _riflemenHAT = [];
private _riflemenAA = [];
private _riflemenAA_SF = [];
private _grenadiers = [];
private _grenadiers_SF = [];
private _autoriflemen = [];
private _autoriflemen_SF = [];
private _medics = [];
private _medics_SF = [];
private _marksmen = [];
private _marksmen_SF = [];
private _officers = [];
private _officers_SF = [];
private _crewmen = [];
private _crewmen_SF = [];
private _snipers = [];
private _snipers_SF = [];
private _spotters = [];
private _spotters_SF = [];
private _JTACs = [];
private _JTACs_SF = [];
private _explosiveSpecialists = [];
private _explosiveSpecialists_SF = [];
private _heavyGunners = [];
private _heavyGunners_SF = [];
private _drivers = [];
private _drivers_SF = [];
private _engineers = [];
private _engineers_SF = [];
private _pilots = [];
private _pilots_SF = [];
{
    private _assigned = false;
    private _unit = _x select 0;
    private _unitLC = toLowerANSI (_x select 0);
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - Checking unit %1", _unit] };
    // [0:_hasAT, 1:_hasAA, 2:_hasMedic, 3:_hasMG, 4:_hasGrenadier, 5:_hasMarksman, 6:_hasUnarmed, 7:_hasEngi, 8:_hasDemo, 9:_hasLeader, 10:_hasOfficer, 11:_hasHacker, 12:_hasDiver, 13:_hasSF, 14:_hasSniper, 15:_hasCrew, 16:_hasAssistant, 17:_hasRadio, 18:_hasDriver, 19:_hasPilot, 20:_hasJTAC, 21:_hasSpotter, 22:_hasAutoriflemen]
    private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
    if (!_assigned && _roles select 0) then { if !(_roles select 13) then { _riflemenAT pushBackUnique _unit } else { _riflemenAT_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 1) then { if !(_roles select 13) then { _riflemenAA pushBackUnique _unit } else { _riflemenAA_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 2) then { if !(_roles select 13) then { _medics pushBackUnique _unit } else { _medics_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 22) then { if !(_roles select 13) then { _autoriflemen pushBackUnique _unit } else { _autoriflemen_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 5) then { if !(_roles select 13) then { _marksmen pushBackUnique _unit } else { _marksmen_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 9 && !(_roles select 10) && !(_roles select 15) && (_roles select 4)) then { if !(_roles select 13) then { _teamLeaders pushBackUnique _unit } else { _teamLeaders_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 9 && !(_roles select 10) && !(_roles select 15)) then { if !(_roles select 13) then { _squadLeaders pushBackUnique _unit } else { _squadLeaders_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 4) then { if !(_roles select 13) then { _grenadiers pushBackUnique _unit } else { _grenadiers_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 10) then { if !(_roles select 13) then { _officers pushBackUnique _unit } else { _officers_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 15) then { if !(_roles select 13) then { _crewmen pushBackUnique _unit } else { _crewmen_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 14) then { if !(_roles select 13) then { _snipers pushBackUnique _unit } else { _snipers_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 21) then { if !(_roles select 13) then { _spotters pushBackUnique _unit } else { _spotters_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 20) then { if !(_roles select 13) then { _JTACs pushBackUnique _unit } else { _JTACs_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 8) then { if !(_roles select 13) then { _explosiveSpecialists pushBackUnique _unit } else { _explosiveSpecialists_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 18) then { if !(_roles select 13) then { _drivers pushBackUnique _unit } else { _drivers_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 3) then { if !(_roles select 13) then { _heavyGunners pushBackUnique _unit } else { _heavyGunners_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 7) then { if !(_roles select 13) then { _engineers pushBackUnique _unit } else { _engineers_SF pushBackUnique _unit }; _assigned = true; };
    if (!_assigned && _roles select 19) then { if !(_roles select 13) then { _pilots pushBackUnique _unit } else { _pilots_SF pushBackUnique _unit }; _assigned = true; };
    // Regular infantry
    if (!_assigned && !(_roles select 6) && !(_roles select 11) && !(_roles select 12) && !(_roles select 16) && !(_roles select 17) && !("angelina" in _unitLC) && !("_aa" in _unitLC) && !("support" in _unitLC) && !("crew" in _unitLC) && !("_a_" in _unitLC) && !("parade" in _unitLC)) then { if !(_roles select 13) then { _riflemen pushBackUnique _unit } else { _riflemen_SF pushBackUnique _unit }; _assigned = true; };
} forEach _infGroups;

if !(_isRegular) then {
    _squadLeaders = +_squadLeaders_SF;
    _teamLeaders = +_teamLeaders_SF;
    _riflemen = +_riflemen_SF;
    _riflemenAT = +_riflemenAT_SF;
    _riflemenAA = +_riflemenAA_SF;
    _grenadiers = +_grenadiers_SF;
    _autoriflemen = +_autoriflemen_SF;
    _medics = +_medics_SF;
    _marksmen = +_marksmen_SF;
    _officers= +_officers_SF;
    _snipers = +_snipers_SF;
    _spotters = +_spotters_SF;
    _JTACs = +_JTACs_SF;
    _explosiveSpecialists = +_explosiveSpecialists_SF;
    _drivers = +_drivers_SF;
    _heavyGunners = +_heavyGunners_SF;
    _engineers = +_engineers_SF;
    _pilots = +_pilots_SF;
};

// If there's no riflemen, everyone is a rifleman
if (count _riflemen == 0) then {
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - No riflemen found. Everybody is now a %2 rifleman for faction %1", _faction, if (_isRegular) then { "regular" } else { "SF" }] };
    _riflemen append _squadLeaders; 
    _riflemen append _teamLeaders; 
    _riflemen append _riflemenAT; 
    _riflemen append _riflemenAA; 
    _riflemen append _grenadiers; 
    _riflemen append _autoriflemen; 
    _riflemen append _medics; 
    _riflemen append _marksmen; 
    _riflemen append _snipers;
    _spotters append _spotters;
    _riflemen append _JTACs;
    _riflemen append _explosiveSpecialists;
    _riflemen append _engineers;
    _riflemen append _drivers;
    _riflemen append _heavyGunners;
};

// Pick the editor subcategory all units will belong to
if (_editorSubCat == "") then { _editorSubCat = getText (configFile >> "CfgVehicles" >> (selectRandom _riflemen) >> "editorSubcategory") };

if (isNil "_editorSubCat") exitWith { [] };

private _fnc_trimUnits = {
    params ["_arr", "_editorSubCat"];
    if (count _arr == 0) exitWith { [] };
    
    private _excludedUnits = [
        "cwr3_b_soldier_at_carlgustaf",
        "cwr3_b_soldier_aat_carlgustaf",
        "cwr3_b_soldier_hg",
        "cwr3_b_soldier_g36",
        "cwr3_b_soldier_steyr",
        "cwr3_b_soldier_xms",
        "cwr3_b_soldier_m14",
        "cwr3_b_soldier_backpack",
        "cwr3_b_soldier_light",
        "cwr3_o_soldier_at_at4",
        "cwr3_o_soldier_aat_at4",
        "cwr3_o_vdv_soldier_at_at4",
        "cwr3_o_vdv_soldier_aat_at4",
        "cwr3_o_spetsnaz_at_at4",
        "cwr3_o_spetsnaz_aat_at4",
        "cwr3_o_soldier_hg",
        "cwr3_o_soldier_backpack",
        "cwr3_o_soldier_light"
        ];
    private _excludedSubCats = [
        "CUP_EdSubcat_Personel_Chedaki_ArmedCiv"
        ];
    _arr select { 
        private _thisESubCat = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
        (_thisESubCat == _editorSubCat && !(_thisESubCat in _excludedSubCats) && !(_x in _excludedUnits))
    }
};
_squadLeaders = [_squadLeaders, _editorSubCat] call _fnc_trimUnits;
_teamLeaders = [_teamLeaders, _editorSubCat] call _fnc_trimUnits;
_riflemen = [_riflemen, _editorSubCat] call _fnc_trimUnits;
_riflemenAT = [_riflemenAT, _editorSubCat] call _fnc_trimUnits;
_riflemenAA = [_riflemenAA, _editorSubCat] call _fnc_trimUnits;
_grenadiers = [_grenadiers, _editorSubCat] call _fnc_trimUnits;
_autoriflemen = [_autoriflemen, _editorSubCat] call _fnc_trimUnits;
_medics = [_medics, _editorSubCat] call _fnc_trimUnits;
_marksmen = [_marksmen, _editorSubCat] call _fnc_trimUnits;
_officers = [_officers, _editorSubCat] call _fnc_trimUnits;
_snipers = [_snipers, _editorSubCat] call _fnc_trimUnits;
_spotters = [_spotters, _editorSubCat] call _fnc_trimUnits;
_JTACs = [_JTACs, _editorSubCat] call _fnc_trimUnits;
_explosiveSpecialists = [_explosiveSpecialists, _editorSubCat] call _fnc_trimUnits;
// _crewmen = [_crewmen, _editorSubCat] call _fnc_trimUnits;
_engineers = [_engineers, _editorSubCat] call _fnc_trimUnits;
// _drivers = [_drivers, _editorSubCat] call _fnc_trimUnits;
_heavyGunners = [_heavyGunners, _editorSubCat] call _fnc_trimUnits;
// _pilots = [_pilots, _editorSubCat] call _fnc_trimUnits;

// Separate Light AT units from Heavy AT ones
if (count _riflemenAT > 0) then {
    _riflemenATfiltered = [_riflemenAT] call DMORBAT_fnc_categorizeATunits;
    if (count _riflemenATfiltered > 0) then {
        _riflemenAT = _riflemenATfiltered select 0;
        _riflemenHAT = _riflemenATfiltered select 1;
    };
};

// Exit if no units where found
if (count _riflemen == 0) exitWith { diag_log format ["DMORBAT: --- ERROR --- Couldn't create groups for faction %1. No infantry units found!", _faction]; [] };

if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _squadLeaders: %1", _squadLeaders] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _teamLeaders: %1", _teamLeaders] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _riflemen: %1", _riflemen] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _riflemenAT: %1", _riflemenAT] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _riflemenHAT: %1", _riflemenHAT] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _riflemenAA: %1", _riflemenAA] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _grenadiers: %1", _grenadiers] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _autoriflemen: %1", _autoriflemen] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _medics: %1", _medics] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _marksmen: %1", _marksmen] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _officers: %1", _officers] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _drivers: %1", _drivers] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _crewmen: %1", _crewmen] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _snipers: %1", _snipers] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _spotters: %1", _spotters] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _JTACs: %1", _JTACs] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _engineers: %1", _engineers] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _explosiveSpecialists: %1", _explosiveSpecialists] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _heavyGunners: %1", _heavyGunners] };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeInf - _pilots: %1", _pilots] };


[_squadLeaders, _teamLeaders, _riflemen, _riflemenAT, _riflemenHAT, _riflemenAA, _grenadiers, _autoriflemen, _medics, _marksmen, _officers, _drivers, _crewmen, _snipers, _spotters, _JTACs, _engineers, _explosiveSpecialists, _heavyGunners, _pilots]