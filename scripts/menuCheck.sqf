#include "..\control_defines.hpp";

disableSerialization; 

waituntil { time > 0 };
call DMORBAT_fnc_openMainDialog;

DMORBAT_EH_playIntroMusic = addMusicEventHandler ["MusicStop", { [DMORBAT_musicType] call DMORBAT_fnc_playMusic;}];
playMusic "LeadTrack04_F_Tacops";

// DIALOG OPENED LOOP
DMORBAT_mainMenu_loop = [] spawn {
    _display = findDisplay IDC_MENU_MISSION_EDIT;
    _tipShown = false;
    _timer = 0;
    // Load first tip
    _ctrl = _display displayCtrl IDC_TXT_TIPS;
    _ctrl ctrlSetText format ["TIP:\n%1", DMORBAT_tips select 0];
    _tipIndex = 1;
    while { DMORBAT_editingTask } do {
        if (!dialog) then {
            if (DMORBAT_mainDialogOpened) then {
                // Destroy cameras when closing menu
                call DMORBAT_fnc_cameraPreviewTerminate;
                call DMORBAT_fnc_cameraIntroTerminate;
                call DMORBAT_fnc_previewGroupDelete;
                DMORBAT_mainDialogOpened = false;
                DMORBAT_selectedLocMrkr = "";
                _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
                _ctrl lbSetCurSel -1;
                DMORBAT_locationPreview = [];
                // Delete location markers and things
                call DMORBAT_fnc_deleteTaskMarkers;
                call DMORBAT_fnc_deleteCompositionMarkers;
                [true] call DMORBAT_fnc_compositionRemove;
                // Delete wheelchocks
                {
                  deleteVehicle _x;
                } forEach DMORBAT_wheelChock;
                DMORBAT_wheelChock = []; 
                // Restore visuals and sound
                setDate DMORBAT_missionStart;
               [DMORBAT_missionWeather, false] spawn DMORBAT_fnc_setWeather;
               call DMORBAT_fnc_resetWeatherEffects;
                0 fadeSound 1;
                enableRadio true;
                cutText ["", "BLACK IN"];
            };
        } else {
            if (DMORBAT_mainDialogOpened) then {
                // Tip displaying control
                if ((_timer % 30) == 0) then {
                    // Show tips
                    if(!_tipShown) then {
                        _ctrl = _display displayCtrl IDC_TXT_TIPS;
                        _ctrl ctrlSetText format ["TIP:\n%1", DMORBAT_tips select _tipIndex];
                        _tipIndex = _tipIndex + 1;
                        if (_tipIndex > ((count DMORBAT_tips) - 1)) then { _tipIndex = 0 };
                        _tipShown = true;
                    };
                } else {
                    _tipShown = false;
                };

                // Animations of location markers
                if (DMORBAT_selectedLocMrkr !=  "") then
                {
                    // Rotate selected location marker
                    _mrkr = DMORBAT_selectedLocMrkr;
                    _mrkr setMarkerDir (markerDir _mrkr) + 10;
                };
            };
        };

        sleep 0.5;
        _timer = _timer + 0.5;
    };
};