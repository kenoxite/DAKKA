#include "..\control_defines.hpp";

disableSerialization; 

waituntil { time > 0 };
call DAKKA_fnc_openMainDialog;

DAKKA_EH_playIntroMusic = addMusicEventHandler ["MusicStop", { [DAKKA_musicType] call DAKKA_fnc_playMusic;}];
playMusic "LeadTrack04_F_Tacops";

// DIALOG OPENED LOOP
DAKKA_mainMenu_loop = [] spawn {
    _display = findDisplay IDC_MENU_MISSION_EDIT;
    _tipShown = false;
    _timer = 0;
    // Load first tip
    _ctrl = _display displayCtrl IDC_TXT_TIPS;
    _ctrl ctrlSetText format ["TIP:\n%1", DAKKA_tips select 0];
    _tipIndex = 1;
    while { DAKKA_editingTask } do {
        if (!dialog) then {
            if (DAKKA_mainDialogOpened) then {
                // Destroy cameras when closing menu
                if (DAKKA_debug) then { diag_log format ["DAKKA: menuCheck - Terminating preview camera..."] };
                call DAKKA_fnc_cameraPreviewTerminate;
                waitUntil {DAKKA_cameraPreviewTerminateDone};
                call DAKKA_fnc_cameraIntroTerminate;
                call DAKKA_fnc_previewGroupDelete;
    
                // Delete wheelchocks
                private _wheelChocks = +DAKKA_wheelChockArr;
                private _wheelChocksDel = [];
                {
                    deleteVehicle _x;
                    _wheelChocksDel pushBackUnique _x;
                } forEach _wheelChocks;
                DAKKA_wheelChockArr = DAKKA_wheelChockArr - _wheelChocksDel;

                DAKKA_mainDialogOpened = false;
                DAKKA_selectedLocMrkr = "";
                _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
                _ctrl lbSetCurSel -1;
                DAKKA_locationPreview = [];
                // Delete location markers and things
                call DAKKA_fnc_deleteTaskMarkers;
                call DAKKA_fnc_deleteCompositionMarkers;
                [true] call DAKKA_fnc_compositionRemove;
                waitUntil {DAKKA_compositionsRemoved};

                // Restore visuals and sound
                setDate DAKKA_missionStart;
               [DAKKA_missionWeather, false] spawn DAKKA_fnc_setWeather;
               call DAKKA_fnc_resetWeatherEffects;
                setAperture 0; 
                setApertureNew [0, 0, 0, 0];
                0 fadeSound 1;
                enableRadio true;
                cutText ["", "BLACK IN"];
            };
        } else {
            if (DAKKA_mainDialogOpened) then {
                // Tip displaying control
                if ((_timer % 15) == 0) then {
                    // Show tips
                    if(!_tipShown) then {
                        _ctrl = _display displayCtrl IDC_TXT_TIPS;
                        _ctrl ctrlSetText format ["TIP:\n%1", DAKKA_tips select _tipIndex];
                        _tipIndex = _tipIndex + 1;
                        if (_tipIndex > ((count DAKKA_tips) - 1)) then { _tipIndex = 0 };
                        _tipShown = true;
                    };
                } else {
                    _tipShown = false;
                };

                // Animations of location markers
                if (DAKKA_selectedLocMrkr !=  "") then
                {
                    // Rotate selected location marker
                    _mrkr = DAKKA_selectedLocMrkr;
                    _mrkr setMarkerDir (markerDir _mrkr) + 10;
                };
            };
        };

        sleep 0.5;
        _timer = _timer + 0.5;
    };
};