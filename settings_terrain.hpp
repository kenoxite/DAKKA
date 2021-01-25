// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DMORBAT_overcast = 0.3; // average overcast
DMORBAT_rain = [0.1, 0.5]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DMORBAT_rainMonths = [9, 4]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DMORBAT_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DMORBAT_fogDecay = 0.05; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DMORBAT_fogBase = 50;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DMORBAT_locations_Task1 = [
        ["Outposts",
            [
                [[10013, 18032.7], 0],
                [[19925.8,14313.3,0],0],
                [[23033.4,22056.9,0],0]
            ]
        ]
    ];

DMORBAT_locations_Task2 = [
        ["Contested Areas",
            [
                [[5792.47, 20035.1], 112.986],
                [[13352.3, 18616.7], 11.471],
                [[20960.3, 16923.6], 48.697],
                [[27011.2,23266.2,0],35],
                [[3653.38,13040.2,0],0],
                [[20520,8870.47,0],330]
            ]
        ]
    ];