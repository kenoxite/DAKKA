// INIT 8
// MISSION SUMMARY

#include "..\control_defines.hpp";
#define CURRENTPAGE 8

disableSerialization;

_display = findDisplay IDC_MENU_MISSION_EDIT;

DAKKA_lastPage = CURRENTPAGE;

// Fill current saved data menu
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;


// Buttons - PAGE NAVIGATION
_ctrl = (_display displayCtrl IDC_BT_NEXT);
_ctrl ctrlSetText "START";
_ctrl ctrlSetEventHandler ["ButtonClick", ' call DAKKA_fnc_missionEditTerminate; '];
_ctrl ctrlSetTooltip "Start the selected task.\nOnce pressed you won't be able to edit the task further, but your settings will be saved.";
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
	"MISSION SUMMARY"
	];

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];

// Start intro camera
[] spawn DAKKA_fnc_cameraIntro;

// Kill fade
sleep 0.1;
cutText ["", "BLACK IN"];