// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.7; // average overcast
DAKKA_rain = [1.6, 2.6]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 2]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 2;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]

DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[4190.98,8683.58,0],0],
                [[5457.73,5575.81,0],0],
                [[2334.53,11254.2,0],0],
                [[920.68,4382.85,0],0],
                [[7636.23,3421.77,0],0],
                [[10307.4,5289.71,0],0],
                [[15054.6,5645.81,0],0],
                [[11729,10862.8,0],0],
                [[8016.82,15826.3,0],0],
                [[3716.38,15150.8,0],0],
                [[5336.28,11643.4,0],0],
                [[10775,14627.5,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[1863.68,8098.99,0],70],
                [[8093.78,3141.34,0],140],
                [[9960.47,5286.7,0],85],
                [[13479.7,6570.26,0],15],
                [[14824.6,14713.4,0],60],
                [[8808.24,16253.9,0],40],
                [[1556.57,14291.5,0],10],
                [[3761.72,12270,0],335],
                [[8158.36,10546.6,0],20],
                [[10963.3,12951.1,0],0],
                [[12714.6,8341.38,0],55],
                [[6544.36,12836.5,0],95],
                [[6107.45,9026.39,0],315]
            ]
        ]
    ];
