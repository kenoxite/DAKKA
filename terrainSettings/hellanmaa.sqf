// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 33;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]

DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[1422.44,674.263,0],0],
                [[891.427,1819.61,0],0],
                [[2811.75,3009.74,0],0],
                [[5734.26,3144.29,0],0],
                [[1734.17,6810.2,0],0],
                [[4935.84,4916.88,0],0],
                [[5380.18,6409.84,0],0],
                [[2774.21,4913.2,0],0],
                [[5934.28,1638.32,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[3629.29,4949.48,0],55],
                [[6281.11,6798.45,0],90],
                [[2565.5,948.138,0],75],
                [[1569.61,3497.18,0],0],
                [[4530.16,3176.96,0],75]
            ]
        ]
    ];
