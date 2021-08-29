// INIT 3
// FRIENDLY GROUPS CREATION

#include "..\control_defines.hpp";
#define CURRENTPAGE 3

disableSerialization;

_display = findDisplay IDC_MENU_MISSION_EDIT;
_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Friendly groups"] call BIS_fnc_getFromPairs;

// Skip page if there's no groups to create
if (((_groupsData select 0) select 0) == "NONE") exitWith {
	[CURRENTPAGE, if (DMORBAT_lastPage < CURRENTPAGE) then { true } else { false }] call DMORBAT_fnc_buttonChangePage;
};
DMORBAT_lastPage = CURRENTPAGE;

// Fill current saved data menu
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;

// Buttons - PAGE NAVIGATION
_ctrl = (_display displayCtrl IDC_BT_NEXT);
_ctrl ctrlSetText "NEXT";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, true] call DMORBAT_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";
_ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_BT_BACK);
_ctrl ctrlSetText "BACK";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, false] call DMORBAT_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";

// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DMORBAT_Task,
	toUpper (call compile format ["DMORBAT_Task%1_Title", DMORBAT_Task]),
	"→      ",
	"CREATE FRIENDLY GROUPS"
	];

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DMORBAT_Task%1_Desc_Editor", DMORBAT_Task];


// FACTION LISTS
_ctrl = (_display displayCtrl IDC_FACTION_TITLE);
_ctrl ctrlSetText "Faction";
_ctrl ctrlEnable false;
// Friendly factions
_ctrl = (_display displayCtrl IDC_COMBO_FACTIONS);
[IDC_COMBO_FACTIONS, true] call DMORBAT_fnc_updateFactionCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_FACTIONS, _this select 1, true, true] call DMORBAT_fnc_ComboFactions_selChanged;'];

// GROUPS LIST
_ctrl = (_display displayCtrl IDC_TITLE_FACTION_GROUPS);
_ctrl ctrlSetText "Faction Groups";

_ctrl = (_display displayCtrl IDC_TREE_FACTION_GROUPS);
[IDC_TREE_FACTION_GROUPS, lbData [IDC_COMBO_FACTIONS, lbCurSel IDC_COMBO_FACTIONS], true] call DMORBAT_fnc_updateGroupsTreeList;
ctrlSetFocus _ctrl;
DMORBAT_PreviewGroupName = _ctrl tvData (tvCurSel _ctrl);
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1, false] call DMORBAT_fnc_TreeFactionGroups_selChanged; '];

	// Buttons
	_ctrl = (_display displayCtrl IDC_BT_ADD_GROUP);
	_ctrl ctrlSetText "Add group to Friendly Groups";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [false] call DMORBAT_fnc_addGroupToGroup; '];
	if (DMORBAT_Task == 2) then {
		_ctrl ctrlSetTooltip "Automatically adds the group to its corresponding friendly group area";
	} else {
		_ctrl ctrlSetTooltip "Adds the unit to the selected friendly group";
	};
	// ctrlEnable [IDC_BT_ADD_GROUP, false];

// FACTION UNITS
_ctrl = (_display displayCtrl IDC_TITLE_FACTION_UNITS);
_ctrl ctrlSetText "Faction Units";

_ctrl = (_display displayCtrl IDC_TREE_FACTION_UNITS);
[IDC_TREE_FACTION_UNITS, lbData [IDC_COMBO_FACTIONS, lbCurSel IDC_COMBO_FACTIONS], "airland"] call DMORBAT_fnc_updateUnitsTreeList;
// tvSetCurSel [IDC_TREE_FACTION_UNITS, [0, 0]];
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1, IDC_TREE_FACTION_GROUPS, IDC_TREE_FACTION_UNITS, false] call DMORBAT_fnc_TreeFactionUnits_selChanged; '];

	// Buttons
	_ctrl = (_display displayCtrl IDC_BT_ADD_UNIT);
	_ctrl ctrlSetText "Add Unit to Friendly Groups";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [false] call DMORBAT_fnc_addUnitToGroup; '];
	if (DMORBAT_Task == 2) then {
		_ctrl ctrlSetTooltip "Adds the unit to the selected friendly group.\nIf the group isn't valid for this unit type, a new group will be created in the corresponding group area";
	} else {
		_ctrl ctrlSetTooltip "Adds the unit to the selected friendly group";
	};
	_ctrl ctrlEnable false;


// GROUP 1
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP1);
_ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
_ctrl ctrlShow false;

	_grp1Name = format ["Friendly %1", (_groupsData select 0) select 0];
	_ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
	_ctrl ctrlSetText toUpper (_grp1Name);

	_ctrl = (_display displayCtrl IDC_TREE_GRP1);
	[IDC_TREE_GRP1, 1, false] call DMORBAT_fnc_updateCustomGroupsTreeList;
	_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_GRP1, _this select 1, 1, false, [IDC_BT_1_GRP1, IDC_BT_2_GRP1, IDC_BT_3_GRP1]] call DMORBAT_fnc_TreeCustomGroup_selChanged; '];
	_ctrl ctrlShow true;

		// Buttons
		// REMOVE
		_ctrl = (_display displayCtrl IDC_BT_1_GRP1);
		_ctrl ctrlSetText "Remove";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, tvCurSel IDC_TREE_GRP1, 1, false, [IDC_BT_1_GRP1, IDC_BT_2_GRP1, IDC_BT_3_GRP1]] call DMORBAT_fnc_removeFromGroup; '];
		_ctrl ctrlSetTooltip "Removes the selected unit or group";
		_ctrl ctrlEnable false;

		// ATTRIBUTES
		_ctrl = (_display displayCtrl IDC_BT_2_GRP1);
		_ctrl ctrlSetText "Attributes";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, tvCurSel IDC_TREE_GRP1, 1, false] spawn DMORBAT_fnc_editUnitAttributes; '];
		_ctrl ctrlSetTooltip "Modify the unit or group skill, probability of presence, etc.";
		_ctrl ctrlEnable false;

		// LOADOUT
		_ctrl = (_display displayCtrl IDC_BT_3_GRP1);
		_ctrl ctrlSetText "Loadout";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, tvCurSel IDC_TREE_GRP1, 1, false] spawn DMORBAT_fnc_editUnitLoadout; '];
		_ctrl ctrlSetTooltip "Edit the unit's loadout";
		_ctrl ctrlEnable false;

		// --
		_ctrl = (_display displayCtrl IDC_BT_4_GRP1);
		_ctrl ctrlSetText "";
		_ctrl ctrlSetEventHandler ["ButtonClick", ''];
		_ctrl ctrlSetTooltip "";
		_ctrl ctrlEnable false;
		_ctrl ctrlShow false;


// GROUP 2
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP2);
_ctrl ctrlShow (if ((count _groupsData) >= 2) then { true } else { false });

if (ctrlVisible IDC_GRP_TASK_GROUP2) then {
	_grp2Name = format ["Friendly %1", (_groupsData select 1) select 0];
	_ctrl = (_display displayCtrl IDC_TITLE_GROUP2);
	_ctrl ctrlSetText toUpper (_grp2Name);

	_ctrl = (_display displayCtrl IDC_TREE_GRP2);
	[IDC_TREE_GRP2, 2, false] call DMORBAT_fnc_updateCustomGroupsTreeList;
	_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_GRP2, _this select 1, 2, false, [IDC_BT_1_GRP2, IDC_BT_2_GRP2, IDC_BT_3_GRP2]] call DMORBAT_fnc_TreeCustomGroup_selChanged; '];
	_ctrl ctrlShow true;

		// Buttons
		// REMOVE
		_ctrl = (_display displayCtrl IDC_BT_1_GRP2);
		_ctrl ctrlSetText "Remove";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP2, tvCurSel IDC_TREE_GRP2, 2, false, [IDC_BT_1_GRP2, IDC_BT_2_GRP2, IDC_BT_3_GRP2]] call DMORBAT_fnc_removeFromGroup; '];
		_ctrl ctrlSetTooltip "Removes the selected unit or group";
		_ctrl ctrlEnable false;

		// ATTRIBUTES
		_ctrl = (_display displayCtrl IDC_BT_2_GRP2);
		_ctrl ctrlSetText "Attributes";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP2, tvCurSel IDC_TREE_GRP2, 2, false] spawn DMORBAT_fnc_editUnitAttributes; '];
		_ctrl ctrlSetTooltip "Modify the unit or group skill, probability of presence, etc.";
		_ctrl ctrlEnable false;

		// LOADOUT
		_ctrl = (_display displayCtrl IDC_BT_3_GRP2);
		_ctrl ctrlSetText "Loadout";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP2, tvCurSel IDC_TREE_GRP2, 2, false] spawn DMORBAT_fnc_editUnitLoadout; '];
		_ctrl ctrlSetTooltip "Edit the unit's loadout";
		_ctrl ctrlEnable false;

		// --
		_ctrl = (_display displayCtrl IDC_BT_4_GRP2);
		_ctrl ctrlSetText "";
		_ctrl ctrlSetEventHandler ["ButtonClick", ''];
		_ctrl ctrlSetTooltip "";
		_ctrl ctrlEnable false;
		_ctrl ctrlShow false;
};

// GROUP 3
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP3);
_ctrl ctrlShow (if ((count _groupsData) >= 3) then { true } else { false });

if (ctrlVisible IDC_GRP_TASK_GROUP3) then {
	_grp3Name = format ["Friendly %1", (_groupsData select 2) select 0];
	_ctrl = (_display displayCtrl IDC_TITLE_GROUP3);
	_ctrl ctrlSetText toUpper (_grp3Name);

	_ctrl = (_display displayCtrl IDC_TREE_GRP3);
	[IDC_TREE_GRP3, 3, false] call DMORBAT_fnc_updateCustomGroupsTreeList;
	_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_GRP3, _this select 1, 3, false, [IDC_BT_1_GRP3, IDC_BT_2_GRP3, IDC_BT_3_GRP3]] call DMORBAT_fnc_TreeCustomGroup_selChanged; '];
	_ctrl ctrlShow true;

		// Buttons
		// REMOVE
		_ctrl = (_display displayCtrl IDC_BT_1_GRP3);
		_ctrl ctrlSetText "Remove";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP3, tvCurSel IDC_TREE_GRP3, 3, false, [IDC_BT_1_GRP3, IDC_BT_2_GRP3, IDC_BT_3_GRP3]] call DMORBAT_fnc_removeFromGroup; '];
		_ctrl ctrlSetTooltip "Removes the selected unit or group";
		_ctrl ctrlEnable false;

		// ATTRIBUTES
		_ctrl = (_display displayCtrl IDC_BT_2_GRP3);
		_ctrl ctrlSetText "Attributes";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP3, tvCurSel IDC_TREE_GRP3, 3, false] spawn DMORBAT_fnc_editUnitAttributes; '];
		_ctrl ctrlSetTooltip "Modify the unit or group skill, probability of presence, etc.";
		_ctrl ctrlEnable false;

		// LOADOUT
		_ctrl = (_display displayCtrl IDC_BT_3_GRP3);
		_ctrl ctrlSetText "Loadout";
		_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP3, tvCurSel IDC_TREE_GRP3, 3, false] spawn DMORBAT_fnc_editUnitLoadout; '];
		_ctrl ctrlSetTooltip "Edit the unit's loadout";
		_ctrl ctrlEnable false;

		// --
		_ctrl = (_display displayCtrl IDC_BT_4_GRP3);
		_ctrl ctrlSetText "";
		_ctrl ctrlSetEventHandler ["ButtonClick", ''];
		_ctrl ctrlSetTooltip "";
		_ctrl ctrlEnable false;
		_ctrl ctrlShow false;
};

// POP - UP CREW SELECTION
_ctrl = (_display displayCtrl IDC_GRP_VEH_CREW_SEL);
_ctrl ctrlShow false;


// ACTIONS AFTER MENU IS LOADED
sleep 0.1;
_ctrl = (_display displayCtrl IDC_TREE_FACTION_GROUPS);
if ((_ctrl tvCount []) > 0) then {
    _ctrl tvSetCurSel [0, 0];
} else {
    _ctrl = (_display displayCtrl IDC_TREE_FACTION_UNITS);
    _ctrl tvSetCurSel [0, 0];
};

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
if ((_ctrl tvCount []) > 1) then {
    _ctrl tvSetCurSel [1];
} else {
    _ctrl tvSetCurSel [0];
};