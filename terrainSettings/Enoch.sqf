// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.3; // average overcast
DAKKA_rain = [0.8, 2.8]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [6, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 200;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[7097.6,8799.69,0],0],
                [[9972.77,5305.38,0],0],
                [[1421.69,2885.96,0],0],
                [[2153.29,4371.2,0],0],
                [[7626.22,1385.66,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[5005.74,10093.5,0],35],
                [[8114.79,8725.75,0],85],
                [[7646.25,5284.09,0],315],
                [[6047.3,4135.81,0],155],
                [[3271.92,2129.08,0],75],
                [[3110.11,6817.88,0],310],
                [[1729.26,7355.74,0],65],
                [[3710.19,11738.3,0],80],
                [[9269.6,10827.8,0],310],
                [[9823.84,8531.93,0],20],
                [[8831.55,6626.44,0],60],
                [[11147.9,4311.49,0],50],
                [[4801.1,7565.06,0],0],
                [[6040.19,8105.69,0],45],
                [[3979.97,7967.78,0],60],
                [[1476.78,9727.11,0],40]
            ]
        ]
    ];