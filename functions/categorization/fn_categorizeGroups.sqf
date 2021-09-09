/*
  Author: kenoxite

  Description:
  Categorizes groups of a given faction.


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/

params ["_faction"];
// Extract faction groups
private _factionGroups = [_faction] call DMORBAT_fnc_extractGroupsData;

private _infGroups = [];
private _SFGroups = [];
private _sniperGroups = [];
private _motGroups = [];
private _mechGroups = [];
private _artilleryGroups = [];
private _armorGroups = [];
private _airGroups = [];
private _waterGroups = [];

{
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _groupTypeData: %1", _x] };
    private _groupTypeName = _x select 0;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _groupTypeName: %1", _groupTypeName] };
    private _groupsData = _x select 1;
    {
        private _groupName = _x select 0;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _groupName: %1", _groupName] };
        private _unitsData = _x select 1;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _unitsData: %1", _unitsData] };
        _classes = [];
        {
            _classes pushBack (_x select 0);
        } forEach _unitsData;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _classes: %1", _classes] };
        private _type = [_classes, true] call DMORBAT_fnc_groupType;

        private _isInf = false;

        switch (_type) do {
            case "Inf":
            {
                _isInf = true;
                private _groupRoles = [_classes] call DMORBAT_fnc_groupRoles;
                // _groupRoles = [_hasAT, _hasAA, _hasMedic, _hasMG, _hasGrenadier, _hasMarksman, _hasUnarmed, _hasEngi, _hasDemo, _hasLeader, _hasOfficer, _hasHacker, _hasDiver, _hasSF, _hasSniper, _hasCrew, _hasAssistant, _hasRadio, _hasDriver, _hasPilot, _hasJTAC, _hasSpotter]
                // SF
                if (_isInf && {_groupRoles select 13}) then {
                    _isInf = false;
                    _SFGroups pushBack [_classes, _groupRoles];
                };
                // Sniper
                if (_isInf && {_groupRoles select 14}) then {
                    _isInf = false;
                    _sniperGroups pushBack [_classes, _groupRoles];
                };
                // Regular infantry
                if (_isInf) then {
                    _infGroups pushBack [_classes, _groupRoles];
                };
            };
            case "Motorized":
            {
                private _groupRoles = [_classes] call DMORBAT_fnc_groupRoles;
                _motGroups pushBack [_classes, _groupRoles];
            };
            case "Mechanized":
            {
                private _groupRoles = [_classes] call DMORBAT_fnc_groupRoles;
                _mechGroups pushBack [_classes, _groupRoles];

            };
            case "Artillery":
            {
                _artilleryGroups pushBack [_classes];
            };
            case "Armor":
            {
                _armorGroups pushBack [_classes];
            };
            case "Air":
            {
                _airGroups pushBack [_classes];
            };
            case "Ship":
            {
                _waterGroups pushBack [_classes];
            };
        };
    } forEach _groupsData;
} forEach _factionGroups;

[_infGroups, _SFGroups, _sniperGroups, _motGroups, _mechGroups, _artilleryGroups, _armorGroups, _airGroups, _waterGroups] 
