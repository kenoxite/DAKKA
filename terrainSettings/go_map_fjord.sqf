// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.7; // average overcast
DAKKA_rain = [1.2, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [9, 2]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

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
                [[1350.84,7517.68,0],0],
                [[1661.85,8838.25,0],0],
                [[1824.2,11191,0],0],
                [[828.485,12839.5,0],0],
                [[4438.28,6780.6,0],0],
                [[11568.2,6474.18,0],0],
                [[12673,4042.52,0],0],
                [[5692.12,2367,0],0],
                [[7645.11,8991.55,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2618.5,3107.96,0],70],
                [[7803.55,12332.6,0],90],
                [[12192.6,5332.63,0],35],
                [[12581.4,2986.32,0],0],
                [[11727.9,1655.74,0],90]
            ]
        ]
    ];
