// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [6, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 0.4;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2699.14,8695.95,0],0],
                [[3562.91,8394.32,0],0],
                [[6766.4,8329.42,0],0],
                [[6574.28,7692.91,0],0],
                [[4595.99,5707.26,0],0],
                [[7562.4,7762.67,0],0],
                [[9128.99,6249.66,0],0],
                [[1332.49,5814.96,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[3493.14,6998.62,0],0],
                [[1922.96,7422.48,0],295],
                [[9164.53,9166.02,0],120],
                [[7495.61,6222.41,0],160],
                [[4423.74,5346.71,0],170]
            ]
        ]
    ];
