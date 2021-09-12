// INIT 6
// SUPPORT

#include "..\control_defines.hpp";
#define CURRENTPAGE 6

disableSerialization;

_display = findDisplay IDC_MENU_MISSION_EDIT;

DAKKA_lastPage = CURRENTPAGE;

[""] spawn DAKKA_fnc_displayMessage;

// Fill current saved data menu
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;


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


// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DAKKA_Task,
	toUpper (call compile format ["DAKKA_Task%1_Title", DAKKA_Task]),
	"→      ",
	"AVAILABLE SUPPORT"
	];

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];



// FACTION LISTS
_ctrl = (_display displayCtrl IDC_TITLE_SUPPORT_FACTIONS);
_ctrl ctrlSetText "Faction";
_ctrl ctrlEnable false;

// Player factions
_ctrl = (_display displayCtrl IDC_COMBO_SUPPORT_FACTIONS);
[IDC_COMBO_SUPPORT_FACTIONS, true] call DAKKA_fnc_updateFactionCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_SUPPORT_FACTIONS, _this select 1, true, false, true] call DAKKA_fnc_ComboFactions_selChanged;'];


// SUPPORT TYPES
_ctrl = (_display displayCtrl IDC_TITLE_SUPPORT_TYPES);
_ctrl ctrlSetText "Support Types";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_COMBO_SUPPORT_TYPES);
[IDC_COMBO_SUPPORT_TYPES] call DAKKA_fnc_updateSupportTypesCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", ' [_this select 1] call DAKKA_fnc_SupportTypesCombo_selChanged; '];
_ctrl lbSetCurSel ((lbCurSel _ctrl) max 0); 
_ctrl ctrlEnable true;

// SUPPORT OPTIONS
_ctrl = (_display displayCtrl IDC_TITLE_SUPPORT_OPTIONS);
_ctrl ctrlSetText "Support Options";
_ctrl ctrlEnable false;

// Support limit
_ctrl = (_display displayCtrl IDC_TITLE_SUPPORT_LIMIT);
_ctrl ctrlSetText format ["%1 Request Limit", lbData [IDC_COMBO_SUPPORT_TYPES, lbCurSel IDC_COMBO_SUPPORT_TYPES]];
_ctrl ctrlEnable false;
    
    // Edit field
    _ctrl = (_display displayCtrl IDC_EDIT_SUPPORT_LIMIT);
    _ctrlChk = (_display displayCtrl IDC_CHK_SUPPORT_LIMIT);
    _ctrlBT = (_display displayCtrl IDC_BT_SUPPORT_LIMIT);
    if ((ctrlText _ctrl) == "-1") then {
        _ctrl ctrlEnable false;
        _ctrlBT ctrlEnable false;
        _ctrlChk cbSetChecked true;
    } else {
        _ctrl ctrlEnable true;
        _ctrlBT ctrlEnable true;
        _ctrlChk cbSetChecked false;
    };

    _ctrl = (_display displayCtrl IDC_BT_SUPPORT_LIMIT);
    _ctrl ctrlSetText "Set";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[] call DAKKA_fnc_changeSupportLimit;'];
    _ctrl ctrlSetTooltip "";

    // Checkbox - Unlimited
    _ctrl = (_display displayCtrl IDC_CHK_SUPPORT_LIMIT);
    _ctrl ctrlSetEventHandler ["CheckedChanged", '
        if ((_this select 1) == 1) then { 
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_EDIT_SUPPORT_LIMIT) ctrlSetText "-1";
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_EDIT_SUPPORT_LIMIT) ctrlEnable false;
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_BT_SUPPORT_LIMIT) ctrlEnable false;
        } else {
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_EDIT_SUPPORT_LIMIT) ctrlEnable true;
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_EDIT_SUPPORT_LIMIT) ctrlSetText "1";
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_BT_SUPPORT_LIMIT) ctrlEnable true;
        };
        [] call DAKKA_fnc_changeSupportLimit;
    '];
    _ctrl ctrlSetTooltip "Enable to be able to call this support type as many times as you want to";

    _ctrl = (_display displayCtrl IDC_TXT_SUPPORT_LIMIT);
    _ctrl ctrlSetText "Unlimited";
    _ctrl ctrlEnable false;

// SUPPORT UNITS
_ctrl = (_display displayCtrl IDC_TITLE_SUPPORT_UNITS);
_ctrl ctrlSetText "Support Units";
_ctrl ctrlEnable false;

// Tree list
_ctrl = (_display displayCtrl IDC_TREE_SUPPORT_UNITS);
[IDC_TREE_SUPPORT_UNITS, lbData [IDC_COMBO_SUPPORT_FACTIONS, lbCurSel IDC_COMBO_SUPPORT_FACTIONS], lbData [IDC_COMBO_SUPPORT_TYPES, lbCurSel IDC_COMBO_SUPPORT_TYPES]] call DAKKA_fnc_updateUnitsTreeList;
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [_this select 1] call DAKKA_fnc_TreeSupportUnits_selChanged; '];
_ctrl ctrlEnable true;

    // Buttons - Support units
    _ctrl = (_display displayCtrl IDC_BT_SUPPORT_UNITS_ADD);
    _ctrl ctrlSetText "Add support unit";
    _ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_SUPPORT_UNITS] call DAKKA_fnc_supportUnitAdd; '];
    _ctrl ctrlSetTooltip "Add the selected unit as support";
    _ctrl ctrlEnable false;


// SELECTED SUPPORT UNITS

// GROUP 1 - Selected support units
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP1);
_ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
_ctrl ctrlSetText format ["%1 GROUPS", toUpper (lbData [IDC_COMBO_SUPPORT_TYPES, lbCurSel IDC_COMBO_SUPPORT_TYPES])];

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
call DAKKA_fnc_updateSelectedSupportGroupsTreeList;
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_GRP1, _this select 1, 1, true, [IDC_BT_1_GRP1, IDC_BT_2_GRP1, IDC_BT_3_GRP1], true] call DAKKA_fnc_TreeCustomGroup_selChanged; '];
_ctrl ctrlEnable true;

    // Buttons - Selected support units
    // Remove
    _ctrl = (_display displayCtrl IDC_BT_1_GRP1);
    _ctrl ctrlSetText "Remove";
    _ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, tvCurSel IDC_TREE_GRP1, [IDC_BT_1_GRP1, IDC_BT_2_GRP1, IDC_BT_3_GRP1]] call DAKKA_fnc_supportUnitRemove; '];
    _ctrl ctrlSetTooltip "Remove the selected unit or group";
    _ctrl ctrlEnable false;

    // --
    _ctrl = (_display displayCtrl IDC_BT_2_GRP1);
    _ctrl ctrlSetText "";
    _ctrl ctrlSetEventHandler ["ButtonClick", ''];
    _ctrl ctrlSetTooltip "";
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;

    // --
    _ctrl = (_display displayCtrl IDC_BT_3_GRP1);
    _ctrl ctrlSetText "";
    _ctrl ctrlSetEventHandler ["ButtonClick", ''];
    _ctrl ctrlSetTooltip "";
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;

    // --
    _ctrl = (_display displayCtrl IDC_BT_4_GRP1);
    _ctrl ctrlSetText "";
    _ctrl ctrlSetEventHandler ["ButtonClick", ''];
    _ctrl ctrlSetTooltip "";
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;


// GROUP 2
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP2);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP2);
_ctrl ctrlSetText "";
_ctrl ctrlEnable false;

// GROUP 3
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP3);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP3);
_ctrl ctrlSetText "";
_ctrl ctrlEnable false;


// Kill fade
sleep 0.1;
call DAKKA_fnc_cameraIntroTerminate;
cutText ["", "BLACK IN", 2];

_ctrl = (_display displayCtrl IDC_COMBO_SUPPORT_TYPES);
_ctrl lbSetCurSel ((lbCurSel _ctrl) max 0); 

_ctrl = (_display displayCtrl IDC_TREE_SUPPORT_UNITS);
if ((_ctrl tvCount []) > 0) then {
    _ctrl tvSetCurSel [0, 0];
} else {
    [getMarkerPos "DAKKA_groupPreviewPos"] spawn DAKKA_fnc_cameraPreviewStatic;
};

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
if ((_ctrl tvCount []) > 1) then {
    _ctrl tvSetCurSel [1];
} else {
    _ctrl tvSetCurSel [0];
};