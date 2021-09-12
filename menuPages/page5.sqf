// INIT 5
// AO LOCATION

#include "..\control_defines.hpp";
#define CURRENTPAGE 5

disableSerialization;

_display = findDisplay IDC_MENU_MISSION_EDIT;

DAKKA_lastPage = CURRENTPAGE;

[false] call DAKKA_fnc_displayVehicleInfo;

// Fill current saved data menu
_ctrl = (_display displayCtrl IDC_GRP_CURRENTSAVEDDATA);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;

// Hide maps for the time being (will be shown later)
cutText ["Preparing AO preview...", "BLACK IN", 999];
["Please, wait while the placed compositions are being created..."] spawn DAKKA_fnc_displayMessage;
_ctrl = (_display displayCtrl IDC_MAP_AO_SEL_T);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_MAP_AO_SEL_S);
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_GRP_AO_MAP_CONTROLS);
_ctrl ctrlShow false;

// Buttons - PAGE NAVIGATION
_ctrl = (_display displayCtrl IDC_BT_NEXT);
_ctrl ctrlSetText "NEXT";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, true] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_BT_BACK);
_ctrl ctrlSetText "BACK";
_ctrl ctrlSetEventHandler ["ButtonClick", ' [CURRENTPAGE, false] call DAKKA_fnc_buttonChangePage; '];
_ctrl ctrlSetTooltip "";
_ctrl ctrlShow false;


// COMPOSITION EDIT CONTROLS
_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_ROTLEFT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["rotleft", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Rotate Left";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_UP);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["up", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Move Up";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_ROTRIGHT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["rotright", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Rotate Right";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_LEFT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["left", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Move Left";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_DOWN);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["down", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Move Down";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_RIGHT);
_ctrl ctrlSetEventHandler ["ButtonClick", ' ["right", IDC_TREE_GRP1] call DAKKA_fnc_compositionEditControls; '];
_ctrl ctrlSetTooltip "Move Right";

_ctrl = (_display displayCtrl IDC_BT_COMPEDIT_CONTROLS_CLOSE);
_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, "top", true] call DAKKA_fnc_compositionEdit; '];
_ctrl ctrlSetText "DONE";
_ctrl ctrlSetTooltip "Finish editing the composition";

// CAMERA TYPE
_ctrl = (_display displayCtrl IDC_BT_CAM_TYPE_TOP);
_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, "top"] call DAKKA_fnc_compositionEdit; '];
_ctrl ctrlSetTooltip "Top";

_ctrl = (_display displayCtrl IDC_BT_CAM_TYPE_HIGH);
_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, "high"] call DAKKA_fnc_compositionEdit; '];
_ctrl ctrlSetTooltip "High Angle";

_ctrl = (_display displayCtrl IDC_BT_CAM_TYPE_CIRCLING);
_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_GRP1, "circling"] call DAKKA_fnc_compositionEdit; '];
_ctrl ctrlSetTooltip "Circling";

// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DAKKA_Task,
	toUpper (call compile format ["DAKKA_Task%1_Title", DAKKA_Task]),
	"→      ",
	"SET AO LOCATIONS"
	];

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];


// LOCATIONS
_ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_CAT);
_ctrl ctrlSetText "Categories";
_ctrl ctrlEnable false;

// Categories
_ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
[IDC_COMBO_AO_SELECTION_CAT] call DAKKA_fnc_updateLocationCatCombo;
_ctrl lbSetCurSel ((lbCurSel _ctrl) max 0); 
_ctrl ctrlSetEventHandler ["LBSelChanged", ' [IDC_COMBO_AO_SELECTION_LOC, _this select 1] call DAKKA_fnc_LocationCatCombo_selChanged; '];
_ctrl ctrlEnable true;

// Locations text
_ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_LOC);
_ctrl ctrlSetText "Locations";
_ctrl ctrlEnable false;

// Locations combo
_ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
[IDC_COMBO_AO_SELECTION_LOC] call DAKKA_fnc_updateLocationsCombo;
_ctrl lbSetCurSel ((lbCurSel _ctrl) max 0); 
_ctrl ctrlSetEventHandler ["LBSelChanged", ' [IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, _this select 1] call DAKKA_fnc_LocationsCombo_selChanged; '];
ctrlSetFocus _ctrl;
_ctrl ctrlEnable true;

    // Buttons - Locations
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_SET);
    _ctrl ctrlSetText "Update coordinates";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_COMBO_AO_SELECTION_LOC] call DAKKA_fnc_locationSet;'];
    _ctrl ctrlSetTooltip "Move the location to the coordinates displayed in the map";
    _ctrl ctrlEnable false;
    
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_REMOVE);
    _ctrl ctrlSetText "Remove location";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_COMBO_AO_SELECTION_LOC] call DAKKA_fnc_locationRemove;'];
    _ctrl ctrlSetTooltip "Removes the selected location";
    _ctrl ctrlEnable false;
    
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ADD);
    _ctrl ctrlSetText "Add to locations";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_COMBO_AO_SELECTION_LOC] call DAKKA_fnc_locationAdd;'];
    _ctrl ctrlSetTooltip "Add current map coordinates as a new location";
    _ctrl ctrlEnable true;
    
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ROTATE_LEFT);
    _ctrl ctrlSetText "Rotate Left";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_COMBO_AO_SELECTION_LOC, false] call DAKKA_fnc_locationRotate;'];
    _ctrl ctrlSetTooltip "Rotate the current location to the left";
    _ctrl ctrlEnable false;
    if (DAKKA_Task == 2) then {
        _ctrl ctrlShow true;
    } else {
        _ctrl ctrlShow false;
    };
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ROTATE_RIGHT);
    _ctrl ctrlSetText "Rotate Right";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_COMBO_AO_SELECTION_LOC] call DAKKA_fnc_locationRotate;'];
    _ctrl ctrlSetTooltip "Rotate the current location to the right";
    _ctrl ctrlEnable false;
    if (DAKKA_Task == 2) then {
        _ctrl ctrlShow true;
    } else {
        _ctrl ctrlShow false;
    };

// COMPOSITIONS

// Text (Left)
_ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_COMP);
_ctrl ctrlSetText "Compositions";
_ctrl ctrlEnable false;

// Tree list (Left)
_ctrl = (_display displayCtrl IDC_TREE_AO_SELECTION_COMP);
[IDC_TREE_AO_SELECTION_COMP] call DAKKA_fnc_updateCompositionsTreeList;
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_AO_SELECTION_COMP, _this select 1] call DAKKA_fnc_TreeCompositions_selChanged; '];
_ctrl ctrlEnable true;

	// Buttons - Compositions (Left)
	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_COMP_ADD);
	_ctrl ctrlSetText "Place composition";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_AO_SELECTION_COMP] call DAKKA_fnc_compositionPlace; '];
	_ctrl ctrlSetTooltip "Places the selected composition at the current map coordinates";
	_ctrl ctrlEnable false;

// Bottom panel
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUPS);
_ctrl ctrlShow true;

// Text (Bottom)
_ctrl = (_display displayCtrl IDC_TITLE_GROUP1);
_ctrl ctrlSetText "PLACED COMPOSITIONS";
_ctrl ctrlEnable false;

// Tree list (Bottom)
_ctrl = (_display displayCtrl IDC_TREE_PLAYER_GRP1);
_ctrl ctrlShow false;

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
[IDC_TREE_GRP1] call DAKKA_fnc_updatePlacedCompositionsTreeList;
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_AO_SELECTION_COMP, _this select 1] call DAKKA_fnc_TreePlacedCompositions_selChanged; '];
_ctrl ctrlEnable true;

	// Buttons - Compositions (Bottom)
    // Remove
	_ctrl = (_display displayCtrl IDC_BT_1_GRP1);
	_ctrl ctrlSetText "Remove";
	_ctrl ctrlSetEventHandler ["ButtonClick", '[false] call DAKKA_fnc_compositionRemove;'];
	_ctrl ctrlSetTooltip "Remove the selected composition";
	_ctrl ctrlEnable false;

    // Edit
	_ctrl = (_display displayCtrl IDC_BT_2_GRP1);
	_ctrl ctrlSetText "Edit";
	_ctrl ctrlSetEventHandler ["ButtonClick", '[IDC_TREE_GRP1] call DAKKA_fnc_compositionEdit;'];
	_ctrl ctrlSetTooltip "Edit the selected composition";
	_ctrl ctrlEnable false;

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
tvClear _ctrl;
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP2);
_ctrl ctrlSetText "";
_ctrl ctrlEnable false;

// GROUP 3
_ctrl = (_display displayCtrl IDC_GRP_TASK_GROUP3);
tvClear _ctrl;
_ctrl ctrlShow false;
_ctrl = (_display displayCtrl IDC_TITLE_GROUP3);
_ctrl ctrlSetText "";
_ctrl ctrlEnable false;

/*// TURRETS
// Text
_ctrl = (_display displayCtrl IDC_TITLE_AO_SEL_TURRETS);
_ctrl ctrlSetText "(Optional)\nPlace static weapons:";

// Combo
_ctrl = (_display displayCtrl IDC_COMBO_AO_SEL_TURRETS_FACTION);
[IDC_COMBO_AO_SEL_TURRETS_FACTION, false] call DAKKA_fnc_updateFactionCombo;
if ((lbCurSel _ctrl) < 0) then { 
	_ctrl lbSetCurSel 0; 
};
_ctrl ctrlSetEventHandler ["LBSelChanged", ' [IDC_COMBO_AO_SEL_TURRETS_FACTION, _this select 1] call DAKKA_fnc_turretFactionsCombo_selChanged; '];
_ctrl ctrlEnable true;

// Tree list
_ctrl = (_display displayCtrl IDC_TREE_AO_SEL_TURRETS);
[lbData [IDC_COMBO_AO_SEL_TURRETS_FACTION, lbCurSel IDC_COMBO_AO_SEL_TURRETS_FACTION], "turret"] call DAKKA_fnc_updateUnitsTreeList;
if (((tvCurSel _ctrl) select 0) < 0) then { 
	_ctrl tvSetCurSel [0]; 
};
_ctrl ctrlSetEventHandler ["TreeSelChanged", ' [IDC_TREE_AO_SEL_TURRETS, _this select 1] call DAKKA_fnc_TreeTurrets_selChanged; '];
_ctrl ctrlEnable true;

	// Buttons - Turrets
	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_TURRETS_ADD);
	_ctrl ctrlSetText "Place turret";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_TREE_AO_SEL_TURRETS] call DAKKA_fnc_turretPlace; '];
	_ctrl ctrlSetTooltip "Places the selected turret at the current map coordinates";
	_ctrl ctrlEnable false;*/


// Load compositions
call DAKKA_fnc_compositionLoad;
_nul = [] spawn {
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
    if (!isNil "_compositionsData") then {
        waitUntil { DAKKA_compositionsLoaded == count _compositionsData };
        if (DAKKA_compositionsLoaded > 0) then {
            ["Placed compositions have been created"] spawn DAKKA_fnc_displayMessage;
        } else {
            [""] spawn DAKKA_fnc_displayMessage;
        };
    };
};

cutText ["", "BLACK IN", 2];

// Enable buttons
_ctrl = (_display displayCtrl IDC_BT_NEXT);
_ctrl ctrlShow true;
_ctrl = (_display displayCtrl IDC_BT_BACK);
_ctrl ctrlShow true;

// Hide maps for the time being (will be shown later)
_ctrl = (_display displayCtrl IDC_GRP_AO_MAP_CONTROLS);
_ctrl ctrlShow true;

// Terrain map
_ctrl = (_display displayCtrl IDC_MAP_AO_SEL_T);
_ctrl ctrlSetEventHandler ["MouseZChanged", ' [IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S] call DAKKA_fnc_mapMoving; '];
_ctrl ctrlSetEventHandler ["MouseMoving", ' [IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S] call DAKKA_fnc_mapMoving; '];
if (DAKKA_mapSatellite) then {
	_ctrl ctrlShow false;
} else {
	_ctrl ctrlShow true;
};

// Map crosshair and marker
_mapCenter = [worldSize / 2, worldSize / 2, 0];
_pos = markerPos DAKKA_selectedLocMrkr;
if (_pos isEqualTo [0,0,0]) then {
    _pos = _mapCenter;
};
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_MapCenter", _pos, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 0, ""] call BIS_fnc_stringToMarker;

_areaX = safezoneX + (20 * pixelGridNoUIScale * pixelW);
_areaY = safezoneY + (11 * pixelGridNoUIScale * pixelH);
_areaWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
_areaheight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
_crossHairWidth = (1.5 * pixelGridNoUIScale * pixelW);
_crossHairHeight = (1.5 * pixelGridNoUIScale * pixelH);

_ctrl = (_display displayCtrl IDC_IMG_MAPCROSSHAIR);
_ctrlx = _areaX + (_areaWidth / 2) - (_crossHairWidth / 2);
_ctrly = _areaY +  + (_areaheight / 2) - (_crossHairHeight / 2);
_ctrlWidth = _crossHairWidth;
_ctrlHeight = _crossHairHeight;
_ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlSetText "\a3\ui_f\data\map\groupicons\waypoint.paa";
// _ctrl ctrlSetText "\a3\ui_f\data\map\groupicons\selector_selectedmission_ca.paa";
_ctrl ctrlSetText "\a3\ui_f\data\map\groupicons\selector_selectable_ca.paa";
_ctrl ctrlSetTextColor [0,0,0,1];
_ctrl ctrlCommit 0;


// Satellite map
_ctrl = (_display displayCtrl IDC_MAP_AO_SEL_S);
_ctrl ctrlSetEventHandler ["MouseZChanged", ' [IDC_MAP_AO_SEL_S, IDC_MAP_AO_SEL_T] call DAKKA_fnc_mapMoving; '];
_ctrl ctrlSetEventHandler ["MouseMoving", ' [IDC_MAP_AO_SEL_S, IDC_MAP_AO_SEL_T] call DAKKA_fnc_mapMoving; '];
if (DAKKA_mapSatellite) then {
	_ctrl ctrlShow true;
} else {
	_ctrl ctrlShow false;
};

[IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S] call DAKKA_fnc_mapDisplayLocations;
call DAKKA_fnc_mapDisplayCompositions;

	// Buttons - Map
	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_SWITCHMAP);
	_ctrl ctrlSetText "SWITCH MAP MODE";
	_ctrl ctrlSetEventHandler ["ButtonClick", ' [IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S] call DAKKA_fnc_switchMapMode; '];
	_ctrl ctrlSetTooltip "Switch between Terrain and Satellite modes";
	_ctrl ctrlEnable true;

	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_PREVIEW_COORDS);
	_ctrl ctrlSetText "PREVIEW COORDS";
	_ctrl ctrlSetEventHandler ["ButtonClick", '[] call DAKKA_fnc_locationPreview;'];
	_ctrl ctrlSetTooltip "Preview the area at the current coordinates";
	_ctrl ctrlEnable true;

// Kill fade
sleep 0.1;

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;
if ((count _locations) > 0) then {
    ctrlEnable [IDC_BT_AO_SEL_SET, true];
    ctrlEnable [IDC_BT_AO_SEL_REMOVE, true];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_LEFT, true];
    ctrlEnable [IDC_BT_AO_SEL_ROTATE_RIGHT, true];
};

_ctrl = (_display displayCtrl IDC_TREE_AO_SELECTION_COMP);
if (((tvCurSel _ctrl) select 0) < 0) then { 
    _ctrl tvSetCurSel [0, 0, 0]; 
};

_ctrl = (_display displayCtrl IDC_TREE_GRP1);
if (((tvCurSel _ctrl) select 0) < 0) then { 
    _ctrl tvSetCurSel [0, 0, 0]; 
};

cutText ["", "BLACK IN"];


/////////////////////////////////////////////////////////////


// // AO selection
// _ctrl = (_display displayCtrl IDC_GRP_AO_SELECTION);
// _ctrlx = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
// _ctrly = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (20 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = safezoneH - (10 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;

//     // Categories title
//     _ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_CAT);
//     _ctrlx = 2 * pixelGridNoUIScale * pixelW;
//     _ctrly = 5.6 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//     // Categories combo
//     _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
//     _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
//     _ctrly = 8 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//     // Locations title
//     _ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_LOC);
//     _ctrlx = 2 * pixelGridNoUIScale * pixelW;
//     _ctrly = 11.1 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//     // Locations combo
//     _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
//     _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
//     _ctrly = 13.5 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//         // Button Set
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_SET);
//         _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
//         _ctrly = 16 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;

//         // Button Remove
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_REMOVE);
//         _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
//         _ctrly = 18 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;

//         // Button Add
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ADD);
//         _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
//         _ctrly = 20 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;

//         // Button Rotate Left
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ROTATE_LEFT);
//         _ctrlx = 12.5 * pixelGridNoUIScale * pixelW;
//         _ctrly = 16 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 6 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;

//         // Button Rotate Right
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_ROTATE_RIGHT);
//         _ctrlx = 12.5 * pixelGridNoUIScale * pixelW;
//         _ctrly = 18 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 6 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;

//     // Compositions title
//     _ctrl = (_display displayCtrl IDC_TITLE_AO_SELECTION_COMP);
//     _ctrlx = 2 * pixelGridNoUIScale * pixelW;
//     _ctrly = 22.6 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 2 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//     // Compositions tree
//     _ctrl = (_display displayCtrl IDC_TREE_AO_SELECTION_COMP);
//     _ctrlx = 2.5 * pixelGridNoUIScale * pixelW;
//     _ctrly = 25 * pixelGridNoUIScale * pixelH;
//     _ctrlWidth = 16 * pixelGridNoUIScale * pixelW;
//     _ctrlHeight = 10 * pixelGridNoUIScale * pixelH;
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//         // Button Add
//         _ctrl = (_display displayCtrl IDC_BT_AO_SEL_COMP_ADD);
//         _ctrlx = 3.8 * pixelGridNoUIScale * pixelW;
//         _ctrly = 35.5 * pixelGridNoUIScale * pixelH;
//         _ctrlWidth = 8 * pixelGridNoUIScale * pixelW;
//         _ctrlHeight = 1.5 * pixelGridNoUIScale * pixelH;
//         _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//         _ctrl ctrlCommit 0;


// // Maps
// // _ctrl = (_display displayCtrl IDC_GRP_AO_SELECTION_MAP);
// // _ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
// // _ctrly = safezoneY + (11 * pixelGridNoUIScale * pixelH);
// // _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
// // _ctrlHeight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
// // _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// // _ctrl ctrlCommit 0;

//     // Reference
//     // _ctrl = (_display displayCtrl IDC_MAP_REFERENCE);
//     // _ctrlx = 0 * pixelGridNoUIScale * pixelW;
//     // _ctrly = 0 * pixelGridNoUIScale * pixelH;
//     // _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
//     // _ctrlHeight = (37 * pixelGridNoUIScale * pixelH);
//     // _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     // _ctrl ctrlShow false;
//     // _ctrl ctrlCommit 0;

//     // Terrain map
//     _ctrl = (_display displayCtrl IDC_MAP_AO_SEL_T);
// _ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
// _ctrly = safezoneY + (11 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
// _ctrlHeight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

//     // Satellite map
//     _ctrl = (_display displayCtrl IDC_MAP_AO_SEL_S);
// _ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
// _ctrly = safezoneY + (11 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
// _ctrlHeight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
//     _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
//     _ctrl ctrlCommit 0;

// // Map Controls
// _ctrl = (_display displayCtrl IDC_GRP_AO_MAP_CONTROLS);
// _ctrlx = SafeZoneX + (SafeZoneW - (10 * pixelGridNoUIScale * pixelW));
// _ctrly = safezoneY + (12 * pixelGridNoUIScale * pixelH);
// _ctrlWidth = (14 * pixelGridNoUIScale * pixelW);
// _ctrlHeight = (6 * pixelGridNoUIScale * pixelH);
// _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
// _ctrl ctrlCommit 0;
