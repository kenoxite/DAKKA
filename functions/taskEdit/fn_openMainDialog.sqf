#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Opens the main menu 


  Parameter (s):
 

  Returns:


  Examples:

*/

// [] spawn DMORBAT_fnc_cameraIntro;
createdialog "DMORBAT_Menu_Mission_Edit";

private _display = findDisplay IDC_MENU_MISSION_EDIT;

// HIDE EVERYTHING
private _hide = [
	IDC_MAP_AO_SEL_T,
    IDC_MAP_AO_SEL_S,
    IDC_GRP_SAVEDDATAPROFILES,
    IDC_GRP_CURRENTSAVEDDATA,
    IDC_GRP_DATARENAME,
    IDC_GRP_NAV_BUTTONS,
	IDC_GRP_FACTION_GROUPS,
	IDC_GRP_TASK_GROUPS,
	IDC_GRP_TASK_DESCRIPTION,
	IDC_GRP_AO_SELECTION,
	IDC_GRP_AO_MAP_CONTROLS,
	IDC_GRP_CAM_CONTROLS,
	IDC_GRP_EDIT_CONTROLS,
	IDC_GRP_CAM_TYPE,
	IDC_GRP_UNITEDIT,
	IDC_GRP_VEH_CREW_SEL,
    IDC_GRP_ENVSETTINGS,
    IDC_GRP_LEFTBAR_BCKG,
    IDC_GRP_BOTTOMBAR_BCKG,
    IDC_GRP_SUPPORT,
    IDC_BT_PREVIEW,
    IDC_GRP_VEHICLEINFO,
    IDC_IMG_MAPCROSSHAIR
];
{
	_ctrl = (_display displayCtrl _x);
	_ctrl ctrlShow false;
} forEach _hide;

// SOUND
0 fadeSound 0;

[] execVM "menuPages\page1.sqf";

DMORBAT_mainDialogOpened = true;