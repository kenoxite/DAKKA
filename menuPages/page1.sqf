// INIT 1
// TASK SELECTION

#include "..\control_defines.hpp";
#define CURRENTPAGE 1

// Intro camera
[] spawn DAKKA_fnc_cameraIntro;

disableSerialization;

cutText ["", "BLACK IN", 999];
_display = findDisplay IDC_MENU_MISSION_EDIT;

DAKKA_lastPage = CURRENTPAGE;

DAKKA_automated = false;

// Hide saved data menus
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;

// Hide 
_ctrl = (_display displayCtrl IDC_GRP_MAINMENU);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_BACKG_MAIN);
_ctrl ctrlShow false;

// TIPS
_ctrl = (_display displayCtrl IDC_TXT_TIPS);
_ctrl ctrlEnable false;
_ctrl = (_display displayCtrl IDC_TXT_MESSAGEBOX);
_ctrl ctrlEnable false;

// SET TASKS

// Main Title
_ctrl = (_display displayCtrl IDC_MM_TITLE);
_ctrl ctrlSetText "DAKKA\nDownright\nAwesome Kit\nfor Arma";
// _ctrl = (_display displayCtrl IDC_MM_TITLE_1);
// _ctrl ctrlSetStructuredText parseText "<t size='2.8' align='center' valign='middle'>DYNAMIC</t>";
// _ctrl = (_display displayCtrl IDC_MM_TITLE_2);
// _ctrl ctrlSetStructuredText parseText "<t size='2.8' align='center' valign='middle'>ORBAT</t>";
// _ctrl = (_display displayCtrl IDC_MM_TITLE_3);
// _ctrl ctrlSetStructuredText parseText "<t size='2.8' align='center' valign='middle'>MISSION</t>";

// Task Title xlistbox
_ctrl = (_display displayCtrl IDC_XLISTBOX_TITLE);
lbClear _ctrl;
for [{private _i = 0}, {_i < count DAKKA_TasksArr}, {_i = _i + 1}] do
{
	_ctrl lbAdd toUpper (call compile format ["DAKKA_Task%1_Title", _i + 1]);
};
_ctrl lbSetCurSel (DAKKA_Task - 1);
_ctrl ctrlSetEventHandler ["LBSelChanged", ' [IDC_XLISTBOX_TITLE, _this select 1] call DAKKA_fnc_TaskSelectionCombo_selChanged; '];
ctrlSetFocus _ctrl;

// Task info
call DAKKA_fnc_displayTaskInfo;


// FACTION LISTS
// Player factions
_ctrl = (_display displayCtrl IDC_COMBO_FACTIONS_PLAYER);
[IDC_COMBO_FACTIONS_PLAYER, true] call DAKKA_fnc_updateFactionCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_FACTIONS_PLAYER, _this select 1, true, false] call DAKKA_fnc_ComboFactions_selChanged;'];
// Enemy factions
_ctrl = (_display displayCtrl IDC_COMBO_FACTIONS_ENEMY);
[IDC_COMBO_FACTIONS_ENEMY, false] call DAKKA_fnc_updateFactionCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '[IDC_COMBO_FACTIONS_ENEMY, _this select 1, false, false] call DAKKA_fnc_ComboFactions_selChanged;'];

// Buttons
_ctrl = (_display displayCtrl IDC_BT_GROUP_SEL);
_ctrl ctrlSetText "CUSTOMIZE >>";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, true] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "Choose the groups, locations, support available and time and weather settings to be used for the selected task";

_ctrl = (_display displayCtrl IDC_BT_PLAYNOW);
_ctrl ctrlSetText "PLAY NOW";
_ctrl ctrlSetEventHandler ["ButtonClick", '[] execVM "scripts\playNow.sqf";'];
_ctrl ctrlSetTooltip "Play the current task with the selected faction and randomized settings";
_ctrl ctrlEnable true;


// Process description
_ctrl = (_display displayCtrl IDC_MM_PROCESS_DESC);
_ctrl ctrlSetText format ["Welcome, %1!

1. Choose a TASK from the available ones
    above.
2. Choose the FACTIONS for you and the enemy.
3. Click one of these buttons:
    • EDIT to choose GROUPS and LOCATIONS to
      use in the mission.
    • PLAY NOW to use randomized groups and
      locations.
", profileName];

/*_ctrl ctrlSetStructuredText parseText format ["<t size='0.65' align='left' valign='middle'>
    Welcome, %1!<br/>
	1. Choose a TASK from the available ones<br/>
        above.<br/>
	2. Choose the FACTIONS for you and<br/>
        the enemy.<br/>
	3. Click one of these buttons:<br/>
        • NEXT to choose GROUPS and LOCATIONS to<br/>
		  use in the mission.<br/>
		• PLAY NOW to use randomized groups and<br/>
		  locations.<br/>
    Enjoy!
</t>", profileName];*/
_ctrl ctrlEnable false;

// Move main background to screen center
cutText ["", "BLACK IN", 2];
// Show 
_ctrl = (_display displayCtrl IDC_GRP_MAINMENU);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_BACKG_MAIN);
_ctrl ctrlShow true;

// [
// 	_display,
// 	[IDC_GRP_BACKG_MAIN, IDC_GRP_MAINMENU],
// 	[
// 		[safezoneW - (94.5 * pixelGridNoUIScale * pixelW), safezoneH],
// 		[safezoneW - (94.5 * pixelGridNoUIScale * pixelW), safezoneH]
// 	],
// 	[],
// 	[]
// ] call DAKKA_fnc_showMainMenu;


// // DIALOG POSITIONS
// // Main menu
// _ctrl = (_display displayCtrl IDC_GRP_MAINMENU);
// _ctrlx = SafeZoneX + (100 * pixelGridNoUIScale * pixelW);
// _ctrly = SafeZoneY + (58 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (25 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = safezoneH;
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;

// Tips
// _ctrl = (_display displayCtrl IDC_TXT_TIPS);
// _ctrlx = SafeZoneX + (SafeZoneW - (22 * pixelGridNoUIScale * pixelW));
// _ctrly = SafeZoneY + (SafeZoneH - (13 * pixelGridNoUIScale * pixelH));
// _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = (10 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;

