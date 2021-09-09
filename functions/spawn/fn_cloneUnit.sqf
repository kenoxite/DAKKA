/*
  Author: kenoxite

  Description:
  Applies identity, loadout and traits of the clone parent to the clone child


  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/

params [["_cloneParent", objNull, [objNull]], ["_cloneChild", objNull, [objNull, ""]], ["_cloneAllTraits", true], ["_cloneLoadout", true], ["_fullMagazines", true]];

private _spawnClone = false;
if (typeName _cloneChild == "OBJECT") then {
    if (isNull _cloneChild) then {
        _cloneChild = typeOf _cloneParent;
        _spawnClone = true;
    };
};
if (typeName _cloneChild == "STRING") then {
    if (_cloneChild == "") then {
        _cloneChild = typeOf _cloneParent;
    };
    _spawnClone = true;
};
// Spawn new clone if only class name or null object has been passed
if (_spawnClone) then {
   _cloneChild = [_cloneChild, position _cloneParent, side _cloneParent] call DMORBAT_fnc_spawnMan;
    if (isNull _cloneChild) exitWith { diag_log format ["DMORBAT: --- ERROR --- cloneUnit UNIT %1 COULDN'T BE SPAWNED. Class name not recognized!", _cloneChild]; objNull };
};

// Start cloning
_cloneChild setName (name _cloneParent);
_cloneChild setFace (face _cloneParent);
_cloneChild setSpeaker (speaker _cloneParent);
_cloneChild setPitch (pitch _cloneParent);
_cloneChild setUnitRank (rank _cloneParent); 
if (_cloneAllTraits) then {
    _unitTraits = getAllUnitTraits _cloneParent;   
    _indexes = [_unitTraits, "Medic"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["Medic",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "Engineer"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["Engineer",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "ExplosiveSpecialist"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["ExplosiveSpecialist",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "UavHacker"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["UavHacker",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "CamouflageCoef"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["CamouflageCoef",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "AudibleCoef"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["AudibleCoef",_unitTraits select (_indexes select 0) select 1];   
    _indexes = [_unitTraits, "LoadCoef"] call BIS_fnc_findNestedElement;   
    _cloneChild setUnitTrait ["LoadCoef",_unitTraits select (_indexes select 0) select 1];
};

if (_cloneLoadout) then {
_null = [_cloneChild, getUnitLoadout _cloneParent, _fullMagazines] spawn {
            sleep 1;
            private _unit = _this select 0;
            private _unitLoadout = _this select 1;
            private _fullMagazines = _this select 2;
            _unit setUnitLoadout [_unitLoadout, _fullMagazines];
        };
};

_cloneChild