
// LOAD LIBRARIES
#include "control_defines.hpp";

// Load weather settings for this terrain
#include "settings_terrain.hpp";

// GLOBAL VARIABLES
DMORBAT_debug = false;

// Weather and date settings
DMORBAT_missionStart = date;
DMORBAT_customDate = DMORBAT_missionStart;
DMORBAT_missionWeather = [overcast, fog];
DMORBAT_customWeather = DMORBAT_missionWeather;
DMORBAT_weatherEffectsList = [
                                ["none", 
                                    [
                                    "None",
                                    "No weather effects will be applied.\n\nIt might take some time for the particles, sounds and effects related to a weather\neffect to disappear if there was one previously selected."
                                    ]
                                ],
                                ["snow_light", 
                                    [
                                    "Snow - Light",
                                    "Light snowfall.\n\nAll the other weather settings will be overriden to accomodate to this weather effect.\nBe advised that activating this will have an impact on performance."
                                    ]
                                ],
                                ["snow", 
                                    [
                                    "Snow - Moderate",
                                    "Moderate snowfall.\n\nAll the other weather settings will be overriden to accomodate to this weather effect.\nBe advised that activating this will have an impact on performance."
                                    ]
                                ],
                                ["duststorm", 
                                    [
                                    "Dust Storm",
                                    "Dust storm. This effect doesn't have a preview. It will activate once the task starts.\n\nAll the other weather settings will be overriden to accomodate to this weather effect.\nBe advised that activating this will have an impact on performance."
                                    ]
                                ],
                                ["monsoon", 
                                    [
                                    "Monsoon",
                                    "Monsoon. This effect doesn't have a preview. It will activate once the task starts.\n\nAll the other weather settings will be overriden to accomodate to this weather effect.\nBe advised that activating this will have an impact on performance."
                                    ]
                                ],
                                ["earthquake", 
                                    [
                                    "Earthquakes",
                                    "Periodic earthquakes of random intensity. Buildings will be damaged (but not in the preview)."
                                    ]
                                ],
                                ["postapocalyptic", 
                                    [
                                    "Post-apocalyptic",
                                    "After a global disaster of your choice you'll find yourself in a desolated and ruined new world (but not in the preview) with sudden changes of weather."
                                    ]
                                ]
                            ];
DMORBAT_weatherEffect = "None";
DMORBAT_weatherEffectPreviews = ["snow_light", "snow", "earthquake", "postapocalyptic"]; // Weather effects that can be previewed
DMORBAT_snow = false;
DMORBAT_sandstorm = false;
DMORBAT_earthquake = false;
DMORBAT_duststorm = false;
DMORBAT_monsoon = false;
DMORBAT_postapocalyptic = false;

DMORBAT_environment = [true, true];

// Factions
DMORBAT_faction = "";
DMORBAT_factionInd = 0;
DMORBAT_PlayerFaction = "";
DMORBAT_PlayerFactions = ["IND_F", "BLU_F"]; // [<friendly faction for task1>, <friendly faction for task 2>,...]
DMORBAT_EnemyFactions = ["BLU_G_F", "OPF_F"]; // [<enemy faction for task1>, <enemy faction for task 2>,...]

// Menus
DMORBAT_editingTask = true;
DMORBAT_mainDialogOpened = false;
DMORBAT_lastPage = 0;
DMORBAT_crewSlotRoles = ["Driver", "Commander", "Gunner"];
DMORBAT_customGroupsSelection = [1, [0]];

// Preview area
DMORBAT_wheelChock = [];
DMORBAT_previewGroup = grpNull;
DMORBAT_PreviewGroupName = "";
DMORBAT_PreviewGroupID = "";
DMORBAT_previewUnit = objNull;
DMORBAT_SelectedPreviewUnit = objNull;
DMORBAT_previewUnitisPlayer = false;
DMORBAT_locationPreview = []; // Array of objects used as reference to preview locations

// Cameras
DMORBAT_cameraIntro = objNull;
DMORBAT_cameraIntroPlaying = false;
DMORBAT_previewCamera = objNull;
DMORBAT_previewCameraPlaying = false;

DMORBAT_cameraZoom = 0.75;
DMORBAT_cameraRelPos = [];
DMORBAT_cameraTargetPos = [];
DMORBAT_mouseButtonPressed = -1;
DMORBAT_cameraX = 0;
DMORBAT_cameraY = 0;

// Locations
DMORBAT_selectedLocMrkr = "";
DMORBAT_mapCoords = [0, 0];
DMORBAT_mapSatellite = false;
DMORBAT_compositionsLoaded = 0;

// Compositions
DMORBAT_spawnCompRefs = [];

// Unit editing
DMORBAT_arsenalOpened = false;
DMORBAT_editedUnit = objNull;
DMORBAT_editAccepted = false;
DMORBAT_skillLevels = ["Untrained", "Normal", "Elite"];
DMORBAT_editReference = objNull;

// Profile settings management
DMORBAT_saveSlots = [0, 0];
DMORBAT_saveSlotName = "Default";
DMORBAT_knownMods = [""];

// Mission
DMORBAT_automated = false;
DMORBAT_PlayerNewGroup = group p1;
DMORBAT_playerGroupReady = false;
DMORBAT_loadedSavegame = false;
DMORBAT_martaHide = [];
DMORBAT_noNightAuto = false;

// TASK SETUP
DMORBAT_TasksArr = [1, 2];
DMORBAT_Task = 1; 
// Task 1
DMORBAT_Task1_Title = "Neutralize Enemy Outpost";
DMORBAT_Task1_Image = "images\task1.paa";
DMORBAT_Task1_Desc_Short = "Find the enemy outpost and eliminate all resistance.";
DMORBAT_Task1_Desc_Editor = "The objective is to locate the enemy outpost and then eliminate all resistance. Once completed, the player's group should proceed to extract.\nWhile this task was conceived for stealth and low unit count numbers, you can modify it to be as big and noisy as you want.";
// Task 2
DMORBAT_Task2_Title = "Stop the Enemy Advance";
DMORBAT_Task2_Image = "images\task2.paa";
DMORBAT_Task2_Desc_Short = "Join the battle and help stop the enemy advance.";
DMORBAT_Task2_Desc_Editor = "Your goal is to stop the enemy advancement towards a strategic position. Contact with the enemy will happen in the first minutes and it will last until no enemies are present in the contested area or they retreat.\nThis task gives you an opportunity to try your best in a combined arms battle, although all this will depend on the type and amount of units you use.";

// Default tasks data
DMORBAT_TaskData_default = [

	[
		// TASK 1
		["Player group", 
			[]
		],	// Player group: [[<group name>, [[<unit1 class>, <unit1 rank>, <unit1 loadout>, <unit1 presence>, <unit1 skill>], [<unit2 class>, ...], ...], [<group mod dependencies>]]]
		["Friendly groups",
			[
				["NONE"]
			]
		],
		["Enemy groups",
			[
				["Patrols",
						[]
				],
				["Defenders",
						[]
				]
			]
		],
		["Player data",
			[0, 0, []]
		],	// Player data [<index in group>, <index in DMORBAT_crewSlotRoles>, <loadout of playable unit>]
		["Locations",
			[
				["Altis",
					[
						["Outposts",
							[]
						]
					]
				]
			]
		],	// AO locations [<marker position>, <marker rotation>]
		["Compositions",
			[
				["Altis",
					[]
				]
			]
		],
		["Support groups",
			[
				["Artillery",
					[[-1], []]
				],
				["Air Transport",
					[[-1], []]
				],
				["CAS",
					[[-1], []]
				]
			]
		]
	],

	// TASK 2
	[
		["Player group", 
			[]
		],
		["Friendly groups", 
			[
				["Infantry",
						[]
				],
				["Land Vehicles",
						[]
				],
				["Air Vehicles",
						[]
				]
			]
		],
		["Enemy groups", 
			[
				["Infantry",
						[]
				],
				["Land Vehicles",
						[]
				],
				["Air Vehicles",
						[]
				]
			]
		],
		["Player data", 
			[0, 0, []]			
		],
		["Locations", 
			[
				["Altis",
					[
						["Contested Areas",
							[]
						]
					]
				]
			]
		],
		["Compositions",
			[
				["Altis",
					[]
				]
			]
		],
		["Support groups", 
			[
				["Artillery",
					[[-1], []]
				],
				["Air Transport",
					[[-1], []]
				],
				["CAS",
					[[-1], []]
				]
			]
		]
	]

];	

// Tasks data saved in profile
DMORBAT_TaskData = +DMORBAT_TaskData_default;

// TIPS
DMORBAT_tips = [
	"You can mix units from different factions when you build your groups. You can also have squads from different factions working together.",

	"All friendly groups will become BLUFOR and enemy groups will become OPFOR, overriding their original side.",

	"You can delete whole groups or individual units from your groups by selecting them and pressing the REMOVE button.",

	"You can set the playable unit to anyone in the player group. If you don't want to be the leader, simply choose any unit but the first.",

	"The crew slot of the effective commander of a vehicle (the one who can give orders) will have an asterisk besides its name.",

	"When editing the AO locations you can also place compositions. While not necessary, they might come handy in some scenarios and may help to identify objective locations.",

	"You can always go back and change the selected task and other settings before starting the mission.",

	"Hovering over your created groups and units will display a tooltip with a lot of useful information.",

	"A random AO location will be chosen if there's more than one defined.",

	"You can set attributes for all the group units by selecting them and clicking ATTRIBUTES.",

	"Adding a unit will create a new group unless an existing group is selected, then the unit will be added to that group.",

	"You can create different profiles, each one with different factions, groups, locations, etc.",

	"All the task settings will be set to default when you create a new profile.",

	"You can rename, delete and create new profiles for each task.",

	"Rename your profiles with appropriate descriptions (such as the name of the factions you are using) so it's easier for you to identify them next time you play the mission.",

    "You can use a spectrum analyzer with an SD jammer antenna to be able to jam signal of enemy drones, stopping them on their tracks!"
];
DMORBAT_tips call BIS_fnc_arrayShuffle;

// Toggleable features
DMORBAT_randomTime = false;
DMORBAT_randomWeather = false;
DMORBAT_noNight = false;
DMORBAT_forceFlashlights = false;
DMORBAT_flares = false;

// Global settings
DMORBAT_settings = [
	["Player Factions",
		DMORBAT_PlayerFactions
	],
	["Enemy Factions",
		DMORBAT_EnemyFactions
	],
	["Selected Profiles",
		DMORBAT_saveSlots
	],
	["Selected Task",
		[DMORBAT_Task]
	],
	["Known mods",
		[""]
	],
	["Date",
		DMORBAT_customDate
	],
	["Random Time",
		[DMORBAT_randomTime]
	],
	["No night",
		[DMORBAT_noNight]
	],
	["Weather",
		DMORBAT_customWeather
	],
	["Random Weather",
		[DMORBAT_randomWeather]
	],
	["Weather Effect",
		["None"]
	],
	["Forced Flashlights",
		[DMORBAT_forceFlashlights]
	],
	["Flares",
		[DMORBAT_flares]
	]
];

// Load global settings
call DMORBAT_fnc_globalSettingsLoad;

// Delete tasks settings
// call DMORBAT_fnc_settingsDelete;

// Load tasks settings
call DMORBAT_fnc_settingsLoad;

waituntil { time > 0 };

// Arsenal management
[ missionNamespace, "arsenalClosed", {
    DMORBAT_arsenalOpened = false;
}] call BIS_fnc_addScriptedEventHandler;
DMORBAT_arsenalGroup = "playerGroup";

// MUSIC
DMORBAT_EH_playIntroMusic = addMusicEventHandler ["MusicStop", { [DMORBAT_musicType] call DMORBAT_fnc_playMusic;}];
2 fadeMusic 0.3;
playMusic "LeadTrack04_F_Tacops";
DMORBAT_musicType = "intro";

// SOUND
0 fadeSound 0;

// Intro camera
[] spawn DMORBAT_fnc_cameraIntro;

// Start loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
if (!_loadingScreen) then { systemChat "Loading screen could not be opened!" };

// EXTRACT FACTIONS DATA
private _initTime = time;
DMORBAT_availableFactionsData = call DMORBAT_fnc_extractFactionData;
systemChat format ["Faction data extracted in %1s", time - _initTime];

// PLAYER SETUP
(units p1) joinSilent (createGroup [west, true]);
p1 setCaptive true;
removeAllWeapons p1;         
removeAllItems p1;             
removeUniform p1;         
removeVest p1;         
removeBackpack p1;         
removeHeadgear p1;         
removeGoggles p1; 

// Spectate EH
// p1 addEventHandler ["killed", { [_this] spawn DMORBAT_fnc_spectate; } ];

DMORBAT_EH_OpenMenu = player addAction ["Open Menu", { call DMORBAT_fnc_openMainDialog;}];


// GLOBAL MISSION PARAMETERS
// Disable ambient fauna
// enableEnvironment [false, true];

// Close loading screen
private _display = findDisplay IDC_LOADING_SCREEN;
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};

// MAIN MENU
// call DMORBAT_fnc_createDialogs;

_display = findDisplay IDC_MENU_MISSION_EDIT;
// call DMORBAT_fnc_openMainDialog;


// ---------------------------------------------------------------------------------
// FLARE FIX - recommended for vanilla missions and assets only, with mods you might have problems

// flare intensity, replace 30 with desired value
al_flare_intensity = 30;
publicvariable "al_flare_intensity";

// flare range, replace 500 with desired value
al_flare_range = 300;
publicvariable "al_flare_range";

al_mortar_flare_intensity = 100;
publicvariable "al_mortar_flare_intensity";

al_mortar_flare_range = 700;
publicvariable "al_mortar_flare_range";

// ---------------------------------------------------------------------------------
// SIGNAL JAMMING - by [STELS]BendeR

[] execVM "Signal_jamming\spectrum_device.sqf";
[] execVM "Signal_jamming\sa_ewar.sqf";

// ---------------------------------------------------------------------------------

// Menu check
[] execVM "scripts\menuCheck.sqf";

// Preview unit HUD
DMORBAT_draw3D_EH_previewUnit = addMissionEventHandler [
"Draw3D",
{
	if (!isNull DMORBAT_previewUnit) then {
		private ["_unitClass", "_rank", "_unit", "_observerPos", "_texture", "_color", "_pos", "_position", "_text", "_width", "_height", "_angle", "_shadow", "_text_size", "_font", "_text_align", "_arrows", "_zoom", "_adjIconSize", "_iconWidth", "_iconHeight", "_adjTextSize", "_textSize"];
		_unitClass = typeOf DMORBAT_previewUnit;
		_rank = rank DMORBAT_previewUnit;
		_unit = vehicle DMORBAT_previewUnit;
		_observerPos = getMarkerPos "DMORBAT_groupPreviewPos";
		// _observerPos = vehicle player;
		_texture = [_rank, "texture"] call BIS_fnc_rankParams;
		_color = if (DMORBAT_previewUnitisPlayer) then { [0.38, 0.6, 0.816, 1] } else { [1, 1, 1, 1] };
		_pos = (DMORBAT_previewUnit selectionPosition "head");
		_position = DMORBAT_previewUnit modelToWorldVisual [
			(_pos select 0),
			_pos select 1,
			(((_pos select 2) + 0.5)) max 0
			];
		_text = getText (configFile >> "CfgVehicles" >> _unitClass >> "displayname");
		
		private _resolution = getResolution;
		private _resHeight = _resolution select 1; 
		_width = _resHeight * 0.001;
		_height = _resHeight * 0.001;
		_text_size = if (_resHeight >= 1080) then { 0.03 } else { 0.025 };

		_angle = 0;
		_shadow = true;
		_font = "RobotoCondensed";
		_text_align = "center";
		_arrows = false;

		_zoom = 0;
		_adjIconSize = 0;
		_iconWidth = 0;
		_iconHeight = 0;
		_adjTextSize = 0;
		_textSize = 0;
						
		// Adjust sizes to distance
		_zoom = call DMORBAT_fnc_trueZoom;
		_adjIconSize = (_observerPos distance _unit) / 1000;

		_iconWidth = (1 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
		_iconHeight = (1 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;

		_adjTextSize = (_observerPos distance _unit) / 10000;
		_textSize = (_zoom / 1000) + ((0.03 - _adjTextSize) max 0);
		// systemChat format ["DMORBAT: _text:%1 _texture:%2 _position: %3", _text, _texture, _position];
		if (_text != "" || _texture !=  "") then {
			drawIcon3D 
			[
				_texture,
				_color,
				_position,
				_width,
				_height,
				_angle,
				_text,
				_shadow, // (optional)
				_text_size, // (optional)
				_font, // (optional)
				_text_align, // (optional)
				_arrows // (optional)
			];	
		};
	};
}];

// Preview location HUD
DMORBAT_draw3D_EH_previewLocation = addMissionEventHandler [
"Draw3D",
{
	{
		private ["_unitClass", "_rank", "_unit", "_observerPos", "_texture", "_color", "_pos", "_position", "_text", "_width", "_height", "_angle", "_shadow", "_text_size", "_font", "_text_align", "_arrows", "_zoom", "_adjIconSize", "_iconWidth", "_iconHeight", "_adjTextSize", "_textSize"];
		_observerPos = [getPos _x, 50, 180] call BIS_fnc_relPos;
		_texture = "\a3\ui_f\data\igui\cfg\simpletasks\types\default_ca.paa";
		_color = [1, 1, 1, 1];
		_position = getPos _x;
		_text = if (_forEachIndex > 0) then { format ["Location %1", _forEachIndex] } else { "" };
		_unit = _x;

		private _resolution = getResolution;
		private _resHeight = _resolution select 1; 
		_width = _resHeight * 0.001;
		_height = _resHeight * 0.001;
		_text_size = if (_resHeight >= 1080) then { 0.03 } else { 0.025 };

		_angle = 0;
		_shadow = true;
		_font = "RobotoCondensed";
		_text_align = "center";
		_arrows = false;

		_zoom = 0;
		_adjIconSize = 0;
		_iconWidth = 0;
		_iconHeight = 0;
		_adjTextSize = 0;
		_textSize = 0;
						
		// Adjust sizes to distance
		_zoom = call DMORBAT_fnc_trueZoom;
		_adjIconSize = (_observerPos distance _unit) / 1000;

		_iconWidth = (1 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
		_iconHeight = (1 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;

		_adjTextSize = (_observerPos distance _unit) / 10000;
		_textSize = (_zoom / 1000) + ((0.03 - _adjTextSize) max 0);

		if (!isNull _x) then {
			// systemChat format ["DMORBAT: _text:%1 _texture:%2 _position: %3", _text, _texture, _position];
			drawIcon3D 
			[
				_texture,
				_color,
				_position,
				_width,
				_height,
				_angle,
				_text,
				_shadow, // (optional)
				_text_size, // (optional)
				_font, // (optional)
				_text_align, // (optional)
				_arrows // (optional)
			];	
		};
	} forEach DMORBAT_locationPreview;
}];

