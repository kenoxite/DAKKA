// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.3; // average overcast
DAKKA_rain = [0.1, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [9, 4]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 50;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2286.31,3786.35,0],0],
                [[1655.01,3352.09,0],0],
                [[3561.92,1318.55,0],0],
                [[4009.6,1418.36,0],0],
                [[5465.93,1147.72,0],0],
                [[5997.47,2897.83,0],0],
                [[6916.22,2722.33,0],0],
                [[6127.47,3335.25,0],0],
                [[6532.95,4621.52,0],0],
                [[1055.35,6895.62,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[4650.85,5388.33,0],85],
                [[2895.67,3010.9,0],0],
                [[6017.67,2156.72,0],15],
                [[4513.94,4117.65,0],315],
                [[2609.29,6132.82,0],90],
                [[6557.16,3502.98,0],340],
                [[1695.43,4235.58,0],335],
                [[1920.46,7087.62,0],60]
            ]
        ]
    ];