#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Get groups from faction

  Array format: 
	_factionGroups = [
                	    [GroupType1,
                            [
                    	        [Group1,
                    	            [[unitClass1, unitRank1], [unitClass2, unitRank2],...]
                    	        ],
                    	        [Group2,
                                    [[unitClass1, unitRank1], [unitClass2, unitRank2],...]
                    	        ],...
                            ]
                	    ], 
                	    [GroupType2,
                            [
                                [Group1,
                                    [[unitClass1, unitRank1], [unitClass2, unitRank2],...]
                                ],
                                [Group2,
                                    [[unitClass1, unitRank1], [unitClass2, unitRank2],...]
                                ],...
                            ]
                	    ],...
                	]

  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/

params ["_faction"];

private _factionGroups = [];
{
    private _groupSideClass = _x;
    {
        private _groupCategoryClass = _x;
        {
            private _groupTypeClass = _x;
            {
	            private _groupClass = _x;
	            if (getText (_groupClass >> "faction") == _faction) then {
                    private _groupTypeName = getText (_groupTypeClass >> "name");
                    private _groupName = getText (_groupClass >> "name");
                    private _unitsData = [];
                    {
                        private _unitClass = getText (_x >> "vehicle");
                        private _rank = getText (_x >> "rank");
                        _unitsData pushBack [_unitClass, _rank];
                    } forEach ("true" configClasses _groupClass);

                    private _groupTypeInd = [_factionGroups, _groupTypeName] call DAKKA_fnc_findFirstNested;
                    if (_groupTypeInd < 0) then {
                        _factionGroups pushBack [_groupTypeName, [[_groupName, _unitsData]]];
                    } else {
                        private _groupTypeData = (_factionGroups select _groupTypeInd) select 1;
                        _groupTypeData pushBack [_groupName, _unitsData];
                    };
                };
            } forEach ("true" configClasses _groupTypeClass);
        } forEach ("true" configClasses _groupCategoryClass);
    } forEach ("true" configClasses _groupSideClass);
} forEach ("true" configClasses (configFile >> "CfgGroups"));

_factionGroups