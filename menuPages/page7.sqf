// INIT 7
// GLOBAL SETTINGS

#include "..\control_defines.hpp";
#define CURRENTPAGE 7

disableSerialization;
_initTime = time;
_display = findDisplay IDC_MENU_MISSION_EDIT;

DAKKA_lastPage = CURRENTPAGE;

[false] call DAKKA_fnc_displayVehicleInfo;

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

// _ctrl = (_display displayCtrl IDC_BT_NEXT);
// _ctrl ctrlSetText "NEXT";
// _ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, true] call DAKKA_fnc_buttonChangePage; '];
// _ctrl ctrlSetTooltip "";
// _ctrl ctrlShow true;

_ctrl = (_display displayCtrl IDC_BT_BACK);
_ctrl ctrlSetText "BACK";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, false] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";
if (DAKKA_automated) then {
    _ctrl ctrlShow false;
};


// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DAKKA_Task,
	toUpper (call compile format ["DAKKA_Task%1_Title", DAKKA_Task]),
	"→      ",
	"GLOBAL SETTINGS"
	];

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];

// Start intro camera
[] spawn DAKKA_fnc_cameraIntro;


// TIME AND DATE
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_TIMEDATE);
_ctrl ctrlSetText "Date & Time";
_ctrl ctrlEnable false;

// DATE
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_DATE);
_ctrl ctrlSetText "Date Settings";
_ctrl ctrlEnable false;

// Update date
setDate DAKKA_customDate;
// Update weather
[DAKKA_customWeather] spawn DAKKA_fnc_setWeather;

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_DAY);
_ctrl ctrlSetEventHandler ["LBSelChanged", format ['["day", %1] call DAKKA_fnc_setDate;', _initTime]];

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MONTH);
_ctrl ctrlSetEventHandler ["LBSelChanged", format ['["month", %1] call DAKKA_fnc_setDate;', _initTime]];

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_YEAR);
_ctrl ctrlSetEventHandler ["LBSelChanged", format ['["year", %1] call DAKKA_fnc_setDate;', _initTime]];

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR);
_ctrl ctrlSetEventHandler ["LBSelChanged", format ['["hour", %1] call DAKKA_fnc_setDate;', _initTime]];
if (DAKKA_randomTime) then {
    _ctrl ctrlEnable false;
    [] spawn DAKKA_fnc_randomTime;
} else {
    _ctrl ctrlEnable true;
};

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES);
_ctrl ctrlSetEventHandler ["LBSelChanged", format ['["minutes", %1] call DAKKA_fnc_setDate;', _initTime]];
if (DAKKA_randomTime) then {
    _ctrl ctrlEnable false;
} else {
    _ctrl ctrlEnable true;
};

[] call DAKKA_fnc_fillDate;

// TIME
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_TIME);
_ctrl ctrlSetText "Time Settings";
_ctrl ctrlEnable false;

// Time combos
_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES);
_ctrl ctrlShow true;


// Random time
_ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_RANDOMTIME);
_ctrl ctrlSetEventHandler ["CheckedChanged", '
    if ((_this select 1) == 1) then { 
        DAKKA_randomTime = true;
        [] spawn DAKKA_fnc_randomTime;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_TXT_ENVSETTINGS_EXCLUDENIGHT) ctrlShow true;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_CHK_ENVSETTINGS_EXCLUDENIGHT) ctrlShow true;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) ctrlEnable false;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) ctrlEnable false;
    } else { 
        DAKKA_randomTime = false; 
        setDate DAKKA_customDate;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) lbSetCurSel ((DAKKA_missionStart select 3)); 
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) lbSetCurSel ((DAKKA_missionStart select 4)); 
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_TXT_ENVSETTINGS_EXCLUDENIGHT) ctrlShow false;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_CHK_ENVSETTINGS_EXCLUDENIGHT) ctrlShow false; 
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_HOUR) ctrlEnable true;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES) ctrlEnable true;
    }; 
    ["Random Time"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl cbSetChecked  DAKKA_randomTime;
_ctrl ctrlSetTooltip "Enable random mission time\n\nPlease note that the previewed random time you see here\nwill be different from the one generated for the task";

_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_RANDOMTIME);
_ctrl ctrlSetText "Random time";
_ctrl ctrlEnable false;

// No night times
_ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_EXCLUDENIGHT);
_ctrl ctrlSetEventHandler ["CheckedChanged", '
    if ((_this select 1) == 1) then {
        DAKKA_noNight = true;
    } else {
        DAKKA_noNight = false;
    };
    [] spawn DAKKA_fnc_randomTime;
    ["No night"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl cbSetChecked  DAKKA_noNight;
_ctrl ctrlSetTooltip "Enable if you only want to play during the day.\n\nThis setting is recommended if the player group doesn't have night vision capabilities.";
if (DAKKA_randomTime) then {
    _ctrl ctrlShow true;
} else {
    _ctrl ctrlShow false;
};

_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_EXCLUDENIGHT);
_ctrl ctrlSetText "Exclude night";
_ctrl ctrlSetTooltip "";
_ctrl ctrlEnable false;
if (DAKKA_randomTime) then {
    _ctrl ctrlShow true;
} else {
    _ctrl ctrlShow false;
};

// ENVIRONMENT
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHERMAIN);
_ctrl ctrlSetText "Environment";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHER);
_ctrl ctrlSetText "Weather Settings";
_ctrl ctrlEnable false;

DAKKA_fnc_overcastChange = {
    params ["_ctrl"];
    private _overcast = sliderPosition _ctrl;
    DAKKA_customWeather set [0, _overcast];
    [DAKKA_customWeather] spawn DAKKA_fnc_setWeather; 
    diag_log format ["DAKKA: --- Changing overcast to %1", DAKKA_customWeather select 0];
};

DAKKA_fnc_fogChange = {
    params ["_ctrl"];
    private _fog = sliderPosition _ctrl;
    DAKKA_customWeather set [1, _fog];
    [DAKKA_customWeather] spawn DAKKA_fnc_setWeather; 
    diag_log format ["DAKKA: --- Changing fog to %1", DAKKA_customWeather select 1];
};

// Overcast
_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_OVERCAST);
_ctrl ctrlSetText "Overcast";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST);
_ctrl sliderSetRange [0, 1];
_ctrl ctrlSetEventHandler ["MouseButtonUp", '[_this select 0] spawn DAKKA_fnc_overcastChange;'];
_ctrl sliderSetPosition (DAKKA_customWeather select 0);
if (DAKKA_randomWeather) then {
    _ctrl ctrlEnable false;
    [] spawn DAKKA_fnc_randomWeather; 
} else {
    _ctrl ctrlEnable true;
};

// systemChat format ["DAKKA: --- overcast: %1", (DAKKA_customWeather select 0)];

// Fog
_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FOG);
_ctrl ctrlSetText "Fog";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_SLIDER_ENVSETTINGS_FOG);
_ctrl sliderSetRange [DAKKA_fogValue select 0, DAKKA_fogValue select 1];
_ctrl ctrlSetEventHandler ["MouseButtonUp", '[_this select 0] spawn DAKKA_fnc_fogChange;'];
_ctrl sliderSetPosition (DAKKA_customWeather select 1);
if (DAKKA_randomWeather) then {
    _ctrl ctrlEnable false;
} else {
    _ctrl ctrlEnable true;
};

// Random weather
_ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_RANDOMWEATHER);
_ctrl ctrlSetEventHandler ["CheckedChanged", '
    if ((_this select 1) == 1) then { 
        DAKKA_randomWeather = true; 
        [] spawn DAKKA_fnc_randomWeather; 
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST) ctrlEnable false;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_FOG) ctrlEnable false;
    } else { 
        DAKKA_randomWeather = false; 
        [DAKKA_customWeather] spawn DAKKA_fnc_setWeather; 
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST) ctrlEnable true;
        ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_FOG) ctrlEnable true;
    }; 
    ["Random Weather"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl cbSetChecked  DAKKA_randomWeather;
_ctrl ctrlSetTooltip "Enable random weather\n\nPlease note that the previewed random weather you see here\nwill be different from the one generated for the task";

_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_RANDOMWEATHER);
_ctrl ctrlSetText "Random weather";
_ctrl ctrlEnable false;

// WEATHER EFFECTS
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHEREFFECTS);
_ctrl ctrlSetText "Environmental Effects";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_WEATHEREFFECTS);
[] call DAKKA_fnc_updateWeatherEffectsCombo;
_ctrl ctrlSetEventHandler ["LBSelChanged", '
        DAKKA_weatherEffect = ((_this select 0) lbData (_this select 1));
        if (DAKKA_weatherEffect == "None" || DAKKA_weatherEffect == "earthquake") then {
            call DAKKA_fnc_resetWeatherEffects;
            if (DAKKA_weatherEffect != "None") then {
                call compile format ["DAKKA_%1 = true", DAKKA_weatherEffect];
                if (DAKKA_weatherEffect in DAKKA_weatherEffectPreviews) then { call DAKKA_fnc_startWeatherEffect };
            };
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_CHK_ENVSETTINGS_RANDOMWEATHER) ctrlEnable true;
            if (DAKKA_randomWeather) then {
                [] spawn DAKKA_fnc_randomWeather; 
                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST) ctrlEnable false;
                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_FOG) ctrlEnable false;
            } else {
                [DAKKA_customWeather] spawn DAKKA_fnc_setWeather;
                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST) ctrlEnable true;
                ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_FOG) ctrlEnable true;
            };
        } else {
            call DAKKA_fnc_resetWeatherEffects;
            call compile format ["DAKKA_%1 = true", DAKKA_weatherEffect];
            if (DAKKA_weatherEffect in DAKKA_weatherEffectPreviews) then { call DAKKA_fnc_startWeatherEffect };
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST) ctrlEnable false;
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_SLIDER_ENVSETTINGS_FOG) ctrlEnable false;
            ((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_CHK_ENVSETTINGS_RANDOMWEATHER) ctrlEnable false;
        };
        ["Weather Effect"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl lbSetCurSel ([DAKKA_weatherEffectsList, DAKKA_weatherEffect] call BIS_fnc_findInPairs);


// MISC SETTINGS
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_MISC);
_ctrl ctrlSetText "Other";
_ctrl ctrlEnable false;

// Force flashlights
_ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_FORCEFLASHLIGHTS);
_ctrl ctrlSetEventHandler ["CheckedChanged", '
    if ((_this select 1) == 1) then { 
        DAKKA_forceFlashlights = true; 
    } else { 
        DAKKA_forceFlashlights = false; 
    }; 
    ["Forced Flashlights"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl cbSetChecked  DAKKA_forceFlashlights;
_ctrl ctrlSetTooltip "Enable to assign and activate default flashlights to units who don't have neither NVG nor flashlight\nand when the task happens near night-time.\n\nPlease note that the unit needs to have a primary weapon with a slot compatible\nwith the flashlight in order to equip it";

_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FORCEFLASHLIGHTS);
_ctrl ctrlSetText "Force flashlights";
_ctrl ctrlEnable false;

// Enhanced flares
_ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_FLARES);
_ctrl ctrlSetEventHandler ["CheckedChanged", '
    if ((_this select 1) == 1) then { 
        DAKKA_flares = true; 
    } else { 
        DAKKA_flares = false; 
    }; 
    ["Flares"] call DAKKA_fnc_globalSettingsSave;
    '];
_ctrl cbSetChecked  DAKKA_flares;
_ctrl ctrlSetTooltip "Enable to improve the range and intensity of the lighting provided by flares,\nonly when the task happens near night-time.\nDisable this if you are already using mods that enhance the flares.\n\nThis feature makes use of the ""Flare Fix"" script by Alias";

_ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FLARES);
_ctrl ctrlSetText "Enhanced flares";
_ctrl ctrlEnable false;


// Kill fade
sleep 0.1;
// cutText ["", "BLACK IN"];
0 fadeSound 1;
2 fadeMusic 0.1;


// DIALOG POSITIONS
/*
// DATE
// Title
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_TIMEDATE);
_ctrlx = 2 * pixelGridNoUIScale * pixelW;
_ctrly = 5.6 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

_ctrl = (_display displayCtrl IDC_GRP_ENVSETTINGS_TIMEDATE);
_ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
_ctrly = 8 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // DATE
    // Time background
    _ctrl = (_display displayCtrl IDC_BCKG_ENVSETTINGS_DATE);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 0 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 3.7 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Date title
    _ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_DATE);
    _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 0.2 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (12 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Day
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_DAY);
    _ctrlx = 1.9 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.7 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 3.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Month
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MONTH);
    _ctrlx = 5.8 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.7 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 4 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Year
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_YEAR);
    _ctrlx = 10.2 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.7 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 4.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;


    // TIME
    // Time background
    _ctrl = (_display displayCtrl IDC_BCKG_ENVSETTINGS_TIME);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 4.3 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Time title
    _ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_TIME);
    _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 4.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (12 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Hour
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR);
    _ctrlx = 4 * pixelGridNoUIScale * pixelW;
    _ctrly = 6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 3.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 1.2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Minutes
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES);
    _ctrlx = 7.9 * pixelGridNoUIScale * pixelW;
    _ctrly = 6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = 3.5 * pixelGridNoUIScale * pixelW;
    _ctrlHeight = 1.2 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Random time checkbox
    _ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_RANDOMTIME);
    _ctrlx = 1.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 7.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (1.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Random time text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_RANDOMTIME);
    _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 7.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (6 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Exclude night checkbox
    _ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_EXCLUDENIGHT);
    _ctrlx = 8.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 7.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (1.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Exclude night txt
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_EXCLUDENIGHT);
    _ctrlx = 9.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 7.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (6 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;


// WEATHER

// Title
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHERMAIN);
_ctrlx = 2 * pixelGridNoUIScale * pixelW;
_ctrly = 18.1 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

_ctrl = (_display displayCtrl IDC_GRP_ENVSETTINGS_WEATHER);
_ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
_ctrly = 19 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 12 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Background
    _ctrl = (_display displayCtrl IDC_BCKG_ENVSETTINGS_WEATHER);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Weather text
    _ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHER);
    _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.7 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (12 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Overcast text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_OVERCAST);
    _ctrlx = 4.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 3 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (6 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.25 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Overcast slider
    _ctrl = (_display displayCtrl IDC_SLIDER_ENVSETTINGS_OVERCAST);
    _ctrlx = 1 * pixelGridNoUIScale * pixelW;
    _ctrly = 4.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (14 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Fog text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FOG);
    _ctrlx = 4.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (6.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.25 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Fog slider
    _ctrl = (_display displayCtrl IDC_SLIDER_ENVSETTINGS_FOG);
    _ctrlx = 1 * pixelGridNoUIScale * pixelW;
    _ctrly = 7.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (14 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Random weather checkbox
    _ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_RANDOMWEATHER);
    _ctrlx = 4 * pixelGridNoUIScale * pixelW;
    _ctrly = 9.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (1.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Random weather text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_RANDOMWEATHER);
    _ctrlx = 5 * pixelGridNoUIScale * pixelW;
    _ctrly = 9.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (8 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;


// WEATHER EFFECTS
_ctrl = (_display displayCtrl IDC_GRP_ENVSETTINGS_WEATHEREFFECTS);
_ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
_ctrly = 29.5 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 5.5 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Background
    _ctrl = (_display displayCtrl IDC_BCKG_ENVSETTINGS_WEATHEREFFECTS);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 3.8 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Weather effects text
    _ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_WEATHEREFFECTS);
    _ctrlx = 0.5 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.7 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (12 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Weather effects combo
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_WEATHEREFFECTS);
    _ctrlx = 1 * pixelGridNoUIScale * pixelW;
    _ctrly = 3.2 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (14 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

// MISC SETTINGS

// Title
_ctrl = (_display displayCtrl IDC_TITLE_ENVSETTINGS_MISC);
_ctrlx = 2 * pixelGridNoUIScale * pixelW;
_ctrly = 35.51 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

_ctrl = (_display displayCtrl IDC_GRP_ENVSETTINGS_MISC);
_ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
_ctrly = 36.5 * pixelGridNoUIScale * pixelH;
_ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
_ctrlHeight = 7 * pixelGridNoUIScale * pixelH;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
_ctrl ctrlCommit 0;

    // Background
    _ctrl = (_display displayCtrl IDC_BCKG_ENVSETTINGS_MISC);
    _ctrlx = 0 * pixelGridNoUIScale * pixelW;
    _ctrly = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (16 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Force flashlights checkbox
    _ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_FORCEFLASHLIGHTS);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 2.5 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (1.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Force flashlights text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FORCEFLASHLIGHTS);
    _ctrlx = 3 * pixelGridNoUIScale * pixelW;
    _ctrly = 2.6 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (8 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;

    // Flares checkbox
    _ctrl = (_display displayCtrl IDC_CHK_ENVSETTINGS_FLARES);
    _ctrlx = 2 * pixelGridNoUIScale * pixelW;
    _ctrly = 4 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (1.5 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlCommit 0;

    // Flares flashlights text
    _ctrl = (_display displayCtrl IDC_TXT_ENVSETTINGS_FLARES);
    _ctrlx = 3 * pixelGridNoUIScale * pixelW;
    _ctrly = 4.1 * pixelGridNoUIScale * pixelH;
    _ctrlWidth = (8 * pixelGridNoUIScale * pixelW);
    _ctrlHeight = 1 * pixelGridNoUIScale * pixelH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlSetFontHeight ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
    _ctrl ctrlCommit 0;


    */