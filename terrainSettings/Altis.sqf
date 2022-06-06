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
                [[10697.8,17840.1,0],0],
                [[10503.2,18090.1,0],0],
                [[9938.32,18048,0],0],
                [[9633.05,17332.5,0],0],
                [[8330.88,17303.1,0],0],
                [[7736.02,18275.6,0],0],
                [[5643.31,18674.9,0],0],
                [[3686.54,18693.8,0],0],
                [[3308.7,19475.9,0],0],
                [[6094.53,20948.4,0],0],
                [[7638.58,16812.2,0],0],
                [[20645.8,18257,0],0],
                [[23409.5,21956.1,0],0],
                [[23050.2,21520.3,0],0],
                [[26237.6,22714.1,0],0],
                [[23850.4,23035.5,0],0],
                [[20240.3,13256.4,0],0],
                [[20734.8,13070.9,0],0],
                [[21728.8,14725.9,0],0],
                [[21946.5,14635.7,0],0],
                [[8380.96,14102.4,0],0],
                [[6808.61,13431.4,0],0],
                [[13565.3,21827.2,0],0],
                [[14342.4,22073.6,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[20370.6,8865.04,0],325],
                [[20231.7,11728.7,0],40],
                [[19160,13633,0],55],
                [[20951.2,16955,0],40],
                [[21353.8,16355.7,0],270],
                [[25710.2,21306.1,0],95],
                [[27035.8,23251,0],0],
                [[13384.2,18591.6,0],0],
                [[14605,20772.6,0],75],
                [[5829.52,20124,0],115],
                [[6134.25,16131.3,0],100],
                [[3701.18,13146.4,0],0],
                [[10595.3,12279.5,0],85],
                [[12310,15682.3,0],95],
                [[18852.5,16660.7,0],60]
            ]
        ]
    ];
