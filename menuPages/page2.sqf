// INIT 2
// PLAYER GROUP CREATION

#include "..\control_defines.hpp";
#define CURRENTPAGE 2
	
disableSerialization;

cutText ["", "BLACK IN", 999];

_display = findDisplay IDC_MENU_MISSION_EDIT;
DAKKA_lastPage = CURRENTPAGE;

// TIPS
_ctrl = (_display displayCtrl IDC_TXT_TIPS);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_TXT_MESSAGEBOX);
_ctrl ctrlShow true;

// Fill current saved data menu
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_TXT_CURRENTSAVEDDATA);
_ctrl ctrlSetText format ["Profile: %1", DAKKA_saveSlotName];
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_BT_CURRENTSAVEDDATA_OPEN);
_ctrl ctrlSetText "";
_ctrl ctrlSetEventHandler ["ButtonClick", 'if (ctrlShown ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_SAVEDDATAPROFILES)) then {
                                                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_SAVEDDATAPROFILES) ctrlShow false;
                                            } else {
                                                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_SAVEDDATAPROFILES) ctrlShow true;
                                            };
                        '];
_ctrl ctrlSetTooltip "Click to open and close the profiles menu";
ctrlSetFocus _ctrl;

// Init saved data profile menu
_ctrl = (_display displayCtrl IDC_TITLE_SAVEDDATAPROFILES);
_ctrl ctrlSetText "Saved data profiles:";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_COMBO_SAVEDDATAPROFILES);
[IDC_COMBO_SAVEDDATAPROFILES] call DAKKA_fnc_updateProfilesCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_SAVEDDATAPROFILES, _this select 1] call DAKKA_fnc_ComboProfiles_selChanged;'];
_ctrl lbSetCurSel (DAKKA_saveSlots select (DAKKA_Task - 1));

_ctrl = (_display displayCtrl IDC_BT_SAVEDDATAPROFILES_NEW);
_ctrl ctrlSetText "New";
_ctrl ctrlSetEventHandler ["ButtonClick", 'call DAKKA_fnc_settingsMenuNew;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_SAVEDDATAPROFILES_RENAME);
_ctrl ctrlSetText "Rename";
_ctrl ctrlSetEventHandler ["ButtonClick", 'call DAKKA_fnc_settingsMenuRename;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_SAVEDDATAPROFILES_DELETE);
_ctrl ctrlSetText "Delete";
_ctrl ctrlSetEventHandler ["ButtonClick", 'call DAKKA_fnc_settingsMenuDelete;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_SAVEDDATAPROFILES_IMPORT);
_ctrl ctrlSetText "Import";
_ctrl ctrlSetEventHandler ["ButtonClick", 'call DAKKA_fnc_settingsImport;'];
_ctrl ctrlSetTooltip "Create a new profile with any copied task settings";
_ctrl ctrlEnable true;

_ctrl = (_display displayCtrl IDC_BT_SAVEDDATAPROFILES_EXPORT);
_ctrl ctrlSetText "Export";
_ctrl ctrlSetEventHandler ["ButtonClick", 'call DAKKA_fnc_settingsExport;'];
_ctrl ctrlSetTooltip "Copy the task settings of the selected profile so they can be shared and imported later";
_ctrl ctrlEnable true;

// Buttons - PAGE NAVIGATION
_ctrl = (_display displayCtrl IDC_BT_NEXT);
_ctrl ctrlSetText "NEXT";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, true] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";
_ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_BT_BACK);
_ctrl ctrlSetText "BACK";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, false] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";

// UNIT EDIT CONTROLS
_ctrl = (_display displayCtrl IDC_TITLE_UNITEDIT);
_ctrl ctrlSetText format ["Edit: %1", ""];

_ctrl = (_display displayCtrl IDC_TITLE_UNITEDIT_PRESENCE);
_ctrl ctrlSetText "Probability of presence:";

_ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_PRESENCE);
[IDC_COMBO_UNITEDIT_PRESENCE] call DAKKA_fnc_updatePresenceCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", ''];

_ctrl = (_display displayCtrl IDC_TITLE_UNITEDIT_SKILL);
_ctrl ctrlSetText "Skill level:";

_ctrl = (_display displayCtrl IDC_COMBO_UNITEDIT_SKILL);
[IDC_COMBO_UNITEDIT_SKILL] call DAKKA_fnc_updateSkillsCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", ''];

_ctrl = (_display displayCtrl IDC_BT_UNITEDIT_OK);
_ctrl ctrlSetText "Accept";
_ctrl ctrlSetEventHandler ["ButtonClick", '((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_UNITEDIT) ctrlShow false; DAKKA_editAccepted = true;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_UNITEDIT_CANCEL);
_ctrl ctrlSetText "Cancel";
_ctrl ctrlSetEventHandler ["ButtonClick", '((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_UNITEDIT) ctrlShow false; DAKKA_editAccepted = false;'];
_ctrl ctrlSetTooltip "";

// CAMERA CONTROLS
_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_ZOOMOUT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["zoomout"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Zoom Out";

_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_UP);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["up"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Move Up";

_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_ZOOMIN);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["zoomin"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Zoom In";

_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_LEFT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["left"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Move Left";

_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_DOWN);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["down"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Move Down";

_ctrl = (_display displayCtrl IDC_BT_CAM_CONTROLS_RIGHT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["right"] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetTooltip "Move Right";

// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DAKKA_Task,
	toUpper (call compile format ["DAKKA_Task%1_Title", DAKKA_Task]),
	"→      ",
	"CREATE PLAYER GROUP"
	];
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];
_ctrl ctrlEnable false;


// FACTION LISTS
_ctrl = (_display displayCtrl IDC_FACTION_TITLE);
_ctrl ctrlSetText "Faction";
_ctrl ctrlEnable false;
// Player factions
_ctrl = (_display displayCtrl IDC_COMBO_FACTIONS);
[IDC_COMBO_FACTIONS, true] call DAKKA_fnc_updateFactionCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_FACTIONS, _this select 1, true, true] call DAKKA_fnc_ComboFactions_selChanged;'];

// GROUPS LIST
_ctrl = (_display displayCtrl IDC_TITLE_FACTION_GROUPS);
_ctrl ctrlSetText "Faction Groups";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TREE_FACTION_GROUPS);
// _initTime = time;
[IDC_TREE_FACTION_GROUPS, lbData [IDC_COMBO_FACTIONS, lbCurSel IDC_COMBO_FACTIONS], true] call DAKKA_fnc_updateGroupsTreeList;
// systemChat format ["Groups data extracted in %1s", time - _initTime];
// _ctrl tvSetCurSel [0];
DAKKA_PreviewGroupName = _ctrl tvData (tvCurSel _ctrl);
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1, false] call DAKKA_fnc_TreeFactionGroups_selChanged; '];
ctrlSetFocus _ctrl;

	// Buttons
	_ctrl = (_display displayCtrl IDC_BT_ADD_GROUP);
	_ctrl ctrlSetText "Set group as Player Group";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_PLAYER_GRP1, DAKKA_previewGroup, DAKKA_PreviewGroupName] call DAKKA_fnc_addGroupToPlayerGroup; '];
	_ctrl ctrlSetTooltip "Make the selected group the group the player will spawn in";
	// ctrlEnable [IDC_BT_ADD_GROUP, false];

// FACTION UNITS
_ctrl = (_display displayCtrl IDC_TITLE_FACTION_UNITS);
_ctrl ctrlSetText "Faction Units";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TREE_FACTION_UNITS);
// _initTime = time;
[IDC_TREE_FACTION_UNITS, lbData [IDC_COMBO_FACTIONS, lbCurSel IDC_COMBO_FACTIONS], "airland"] call DAKKA_fnc_updateUnitsTreeList;
// systemChat format ["Units data extracted in %1s", time - _initTime];
// tvSetCurSel [IDC_TREE_FACTION_UNITS, [0, 0]];
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1, IDC_TREE_FACTION_GROUPS, IDC_TREE_FACTION_UNITS] call DAKKA_fnc_TreeFactionUnits_selChanged; '];

	// Buttons
	_ctrl = (_display displayCtrl IDC_BT_ADD_UNIT);
	_ctrl ctrlSetText "Add Unit to Player Group";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_PLAYER_GRP1, DAKKA_SelectedPreviewUnit] call DAKKA_fnc_addUnitToPlayerGroup; '];
	_ctrl ctrlSetTooltip "Add the selected unit to the group the player will spawn in";
	_ctrl ctrlEnable false;


// GROUP 1 - PLAYER GROUP
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP1);
_ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
_ctrl ctrlSetText "PLAYER GROUP";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
[IDC_TREE_PLAYER_GRP1] call DAKKA_fnc_updatePlayerGroupTreeList;
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1, IDC_TREE_PLAYER_GRP1, IDC_TREE_FACTION_GROUPS, IDC_TREE_FACTION_UNITS] call DAKKA_fnc_TreePlayerGroup_selChanged; '];
_ctrl ctrlShow true;

	// Buttons
	// REMOVE
	_ctrl = (_display displayCtrl IDC_BT_1_GRP1);
	_ctrl ctrlSetText "Remove";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_PLAYER_GRP1, tvCurSel IDC_TREE_PLAYER_GRP1] call DAKKA_fnc_removeFromPlayerGroup; '];
	_ctrl ctrlSetTooltip "Removes the selected unit from the player's group";
	_ctrl ctrlEnable false;

	// ATTRIBUTES
	_ctrl = (_display displayCtrl IDC_BT_2_GRP1);
	_ctrl ctrlSetText "Attributes";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_PLAYER_GRP1, tvCurSel IDC_TREE_PLAYER_GRP1, 0, false] spawn DAKKA_fnc_editUnitAttributes; '];
	_ctrl ctrlSetTooltip "Modify the unit or group skill, probability of presence, etc.";
	_ctrl ctrlEnable false;

	// LOADOUT
	_ctrl = (_display displayCtrl IDC_BT_3_GRP1);
	_ctrl ctrlSetText "Loadout";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_PLAYER_GRP1, tvCurSel IDC_TREE_PLAYER_GRP1, 0, false] spawn DAKKA_fnc_editUnitLoadout; '];
	_ctrl ctrlSetTooltip "Edit the unit's loadout";
	_ctrl ctrlEnable false;

	// SET AS PLAYER
	_ctrl = (_display displayCtrl IDC_BT_4_GRP1);
	_ctrl ctrlSetText "Player";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [(tvCurSel IDC_TREE_PLAYER_GRP1) select 1] call DAKKA_fnc_setPlayerUnit; '];
	_ctrl ctrlSetTooltip "Set the selected unit as the one the player will play as";
	_ctrl ctrlEnable false;
	_ctrl ctrlShow true;

// GROUP 2
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP2);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP2);
_ctrl ctrlEnable false;

// GROUP 3
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP3);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP3);
_ctrl ctrlEnable false;

// POP - UP CREW SELECTION
_ctrl = (_display displayCtrl IDC_GRP_VEH_CREW_SEL);
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_TITLE_TASK_GROUPS_CREW);
_ctrl ctrlSetText "Choose crew position:";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_COMBO_TASK_GROUPS_CREW);
_ctrl lbSetCurSel 0;

_ctrl = (_display displayCtrl IDC_BT_TASK_GROUPS_CREW);
_ctrl ctrlSetText "Accept";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_COMBO_TASK_GROUPS_CREW] call DAKKA_fnc_setCrewSlot; '];


///
sleep 0.1;
_ctrl = (_display displayCtrl IDC_TREE_FACTION_GROUPS);
if ((_ctrl tvCount []) > 0) then {
    _ctrl tvSetCurSel [0, 0];
} else {
    _ctrl = (_display displayCtrl IDC_TREE_FACTION_UNITS);
    _ctrl tvSetCurSel [0, 0];
};

_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
if ((_ctrl tvCount []) > 0) then {
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _playerIndex = ([_taskData, "Player data"] call BIS_fnc_getFromPairs) select 0;
    _ctrl tvSetCurSel [0, _playerIndex];
};

// PREVIEW AREA
_ctrl = (_display displayCtrl IDC_BT_PREVIEW);
_ctrl ctrlSetEventHandler ["MouseZChanged", ' ["scrollwheel", _this] call DAKKA_fnc_cameraControls; '];
_ctrl ctrlSetEventHandler ["MouseButtonDown", ' DAKKA_mouseButtonPressed = _this select 1; '];
_ctrl ctrlSetEventHandler ["MouseButtonUp", ' DAKKA_mouseButtonPressed = -1; '];
_ctrl ctrlSetEventHandler ["MouseMoving", ' if (DAKKA_mouseButtonPressed == 0) then { ["leftBtnMouse", _this] call DAKKA_fnc_cameraControls; }; if (DAKKA_mouseButtonPressed == 1) then { ["rightBtnMouse", _this] call DAKKA_fnc_cameraControls; };'];


// DIALOG POSITIONS

// Left bar background
/*_ctrl = (_display displayCtrl IDC_GRP_LEFTBAR_BCKG);
_ctrlx = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
_ctrly = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
_ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
_ctrlHeight = safezoneH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Bckg vertical strip 2
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_VSTRIP2);
    _ctrlx = (19.499 * pixelGridNoUIScale * pixelW);
    _ctrly = 5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = safezoneH - (20.5 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Bckg main
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG1);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = safezoneH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Bckg horizontal strip 1
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_HSTRIP1);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 3 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Bckg horizontal strip 2
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_HSTRIP2);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 0.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Bckg vertical strip 1
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_VSTRIP1);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 2 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = safezoneH - (5 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetText "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
    _ctrl ctrlCommit 0;

    // Bckg bottom
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_BOTTOM);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
    _ctrlWidth = 18 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = (16 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetText "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
    _ctrl ctrlCommit 0;

    // Bckg msg
    _ctrl = (_display displayCtrl IDC_BCKG_LEFTBAR_BCKG_MSG);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = (SafeZoneH - (8 * pixelGridNoUIScale * pixelH));
    _ctrlWidth = 17 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = (5.4 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetText "#(rgb,8,8,3)color(0.3,0.3,0.3,0.5)";
    _ctrl ctrlCommit 0;
*/
// Faction groups and units selection
// _ctrl = (_display displayCtrl IDC_GRP_FACTION_GROUPS);
// _ctrlx = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
// _ctrly = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = safezoneH - (10 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;


/*
    // Faction title strip 1
    _ctrl = (_display displayCtrl IDC_BCKG_FACTION_TITLE_HSTRIP1);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 5.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 2 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction title strip 2
    _ctrl = (_display displayCtrl IDC_BCKG_FACTION_TITLE_HSTRIP2);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 5.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction title strip 3
    _ctrl = (_display displayCtrl IDC_BCKG_FACTION_TITLE_HSTRIP3);
    _ctrlx = 18 * pixelGridNoUIScale * pixelW;
    _ctrly = 5.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction combo title
    _ctrl = (_display displayCtrl IDC_FACTION_TITLE);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 5.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
    _ctrl ctrlSetBackgroundColor [1, 0.5, 0, 0];
    _ctrl ctrlCommit 0;

    // Faction combo
    _ctrl = (_display displayCtrl IDC_COMBO_FACTIONS);
    _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 8 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    // _ctrl ctrlSetBackgroundColor [0.3,0.3,0.3,1];
    _ctrl ctrlCommit 0;

    // Faction groups title
    _ctrl = (_display displayCtrl IDC_TITLE_FACTION_GROUPS);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 11.1 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
    _ctrl ctrlSetBackgroundColor [1, 0.5, 0, 0];
    _ctrl ctrlCommit 0;

    // Faction groups
    _ctrl = (_display displayCtrl IDC_TREE_FACTION_GROUPS);
    _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 13.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction groups button
    _ctrl = (_display displayCtrl IDC_BT_ADD_GROUP);
    _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
    _ctrly = 24.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 14 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction units title
    _ctrl = (_display displayCtrl IDC_TITLE_FACTION_UNITS);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 27.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
    _ctrl ctrlSetBackgroundColor [1, 0.5, 0, 0];
    _ctrl ctrlCommit 0;

    // Faction units
    _ctrl = (_display displayCtrl IDC_TREE_FACTION_UNITS);
    _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 30.1 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Faction groups button
    _ctrl = (_display displayCtrl IDC_BT_ADD_UNIT);
    _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
    _ctrly = 41.1 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 14 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;
*/
/*
// Navigation buttons
_ctrl = (_display displayCtrl IDC_GRP_NAV_BUTTONS);
_ctrlx = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
_ctrly = SafeZoneY + (SafeZoneH - (2 * pixelGridNoUIScale * pixelH));
_ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
_ctrlHeight = (2 * pixelGridNoUIScale * pixelH);
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Back
    _ctrl = (_display displayCtrl IDC_BT_BACK);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 6 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Next
    _ctrl = (_display displayCtrl IDC_BT_NEXT);
    _ctrlx = 13.9 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 6 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;
*/

// Task description
/*_ctrl = (_display displayCtrl IDC_GRP_TASK_DESCRIPTION);
_ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
_ctrly = safezoneY + (0 * pixelGridNoUIScale * pixelH);
_ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
_ctrlHeight = (11 * pixelGridNoUIScale * pixelH);
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Task description
    _ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
    _ctrlx = 1 * pixelGridNoUIScale * pixelW;
    _ctrly = 1 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (safezoneW - (45 * pixelGridNoUIScale * pixelW));
    _ctrlHeight = (4 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Task description
    _ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
    _ctrlx = 1 * pixelGridNoUIScale * pixelW;
    _ctrly = 6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (safezoneW - (22 * pixelGridNoUIScale * pixelW));
    _ctrlHeight = (5 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;*/

// Profiles
// _ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
// _ctrlx = SafeZoneX + (SafeZoneW - (20 * pixelGridNoUIScale * pixelW));
// _ctrly = SafeZoneY + (1 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = (2 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;

// Saved data profiles menu
// _ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
// _ctrlx = SafeZoneX + (SafeZoneW - (20 * pixelGridNoUIScale * pixelW));
// _ctrly = SafeZoneY + (3 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = (13 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;

/*// Custom groups
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUPS);
_ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
_ctrly = SafeZoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
_ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
_ctrlHeight = safezoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Custom group 1
    _ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP1);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 20 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

        // Custom group 1 - Title
        _ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 0.35 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 18 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
        _ctrl ctrlCommit 0;

        // Custom group 1 - Player Tree list
        _ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 2.5 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 19 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

        // Custom group 1 - Tree list
        _ctrl = (_display displayCtrl IDC_TREE_GRP1);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 2.5 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 19 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

        // Custom group 1 - Button 1
        _ctrl = (_display displayCtrl IDC_BT_1_GRP1);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 13 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 4.5 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

        // Custom group 1 - Button 2
        _ctrl = (_display displayCtrl IDC_BT_2_GRP1);
        _ctrlx = 5.3 * pixelGridNoUIScale * pixelW;
        _ctrly = 13 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 4.5 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

        // Custom group 1 - Button 3
        _ctrl = (_display displayCtrl IDC_BT_3_GRP1);
        _ctrlx = 10.1 * pixelGridNoUIScale * pixelW;
        _ctrly = 13 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 4.5 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

        // Custom group 1 - Button 4
        _ctrl = (_display displayCtrl IDC_BT_4_GRP1);
        _ctrlx = 14.9 * pixelGridNoUIScale * pixelW;
        _ctrly = 13 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 4.5 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

    // Custom group 2
    _ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP2);
    _ctrlx = 20 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 20 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

        // Custom group 2 - Tree list
        _ctrl = (_display displayCtrl IDC_TREE_GRP2);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 2.5 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 19 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;

    // Custom group 3
    _ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP3);
    _ctrlx = 40 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 20 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 20 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

        // Custom group 3 - Tree list
        _ctrl = (_display displayCtrl IDC_TREE_GRP3);
        _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
        _ctrly = 2.5 * pixelGridNoUIScale * pixelH;
        _ctrlWidth = 19 * pixelGridNoUIScale * pixelW;
        _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
        _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
        _ctrl ctrlCommit 0;


// Camera controls
_ctrl = (_display displayCtrl IDC_GRP_CAM_CONTROLS);
_ctrlx = SafeZoneX + (SafeZoneW - (5.8 * pixelGridNoUIScale * pixelW));
_ctrly = SafeZoneY + (SafeZoneH - (20 * pixelGridNoUIScale * pixelH));
_ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
_ctrlHeight = 5 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

_ctrl = (_display displayCtrl IDC_GRP_CAM_TYPE);
_ctrlx = SafeZoneX + (SafeZoneW - (8.7 * pixelGridNoUIScale * pixelW));
_ctrly = SafeZoneY + (SafeZoneH - (15 * pixelGridNoUIScale * pixelH));
_ctrlWidth = 4 * pixelGridNoUIScale * pixelW;
_ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

_ctrl = (_display displayCtrl IDC_GRP_EDIT_CONTROLS);
_ctrlx = SafeZoneX + (SafeZoneW - (12 * pixelGridNoUIScale * pixelW));
_ctrly = SafeZoneY + (SafeZoneH - (10 * pixelGridNoUIScale * pixelH));
_ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
_ctrlHeight = 7 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

// Tips
_ctrl = (_display displayCtrl IDC_TXT_TIPS);
_ctrlx = SafeZoneX + ((2 * pixelGridNoUIScale * pixelW));
_ctrly = SafeZoneY + (SafeZoneH - (15.5 * pixelGridNoUIScale * pixelH));
_ctrlWidth = (17 * pixelGridNoUIScale * pixelW);
_ctrlHeight = (7 * pixelGridNoUIScale * pixelH);
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlSetBackgroundColor [1, 0.3, 0.3, 0];
_ctrl ctrlCommit 0;

// Message box
_ctrl = (_display displayCtrl IDC_TXT_MESSAGEBOX);
_ctrlx = SafeZoneX + ((2.25 * pixelGridNoUIScale * pixelW));
_ctrly = SafeZoneY + (SafeZoneH - (7.8 * pixelGridNoUIScale * pixelH));
_ctrlWidth = (16.5 * pixelGridNoUIScale * pixelW);
_ctrlHeight = (5 * pixelGridNoUIScale * pixelH);
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlSetBackgroundColor [1, 0.3, 0.3, 0];
_ctrl ctrlCommit 0;

// Rename popup
_ctrl = (_display displayCtrl IDC_GRP_DATARENAME_POPUP);
_ctrlx = (safeZoneX + (safeZoneWAbs / 2));
_ctrly = (30 * pixelGridNoUIScale * pixelH);
_ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
_ctrlHeight = (9 * pixelGridNoUIScale * pixelH);
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Title
    _ctrl = (_display displayCtrl IDC_TITLE_DATARENAME);
    _ctrlx = (1 * pixelGridNoUIScale * pixelW);
    _ctrly = (1 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (18 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (1 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Text
    _ctrl = (_display displayCtrl IDC_TXT_DATARENAME);
    _ctrlx = (1 * pixelGridNoUIScale * pixelW);
    _ctrly = (3 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (18 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (2 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Button
    _ctrl = (_display displayCtrl IDC_BT_DATARENAME_OK);
    _ctrlx = (4 * pixelGridNoUIScale * pixelW);
    _ctrly = (5.5 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (4 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (2 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Button
    _ctrl = (_display displayCtrl IDC_BT_DATARENAME_CANCEL);
    _ctrlx = (11 * pixelGridNoUIScale * pixelW);
    _ctrly = (5.5 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (4 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (2 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;


// Attributes popup
_ctrl = (_display displayCtrl IDC_GRP_UNITEDIT);
_ctrlx = safezoneX;
_ctrly = safezoneY;
_ctrlWidth = safezoneW;
_ctrlHeight = safezoneH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Attributes popup
    _ctrl = (_display displayCtrl IDC_GRP_UNITEDIT_POPUP);
    _ctrlx = (safeZoneX + (safeZoneWAbs / 2));
    _ctrly = 30 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (12 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;


// Crew selection popup
_ctrl = (_display displayCtrl IDC_GRP_VEH_CREW_SEL);
_ctrlx = safezoneX;
_ctrly = safezoneY;
_ctrlWidth = safezoneW;
_ctrlHeight = safezoneH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Crew selection popup
    _ctrl = (_display displayCtrl IDC_GRP_VEH_CREW_SEL_POPUP);
    _ctrlx = (safeZoneX + (safeZoneWAbs / 2));
    _ctrly = 30 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = (9 * pixelGridNoUIScale * pixelH);
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;
*/