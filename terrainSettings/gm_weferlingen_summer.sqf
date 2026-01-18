// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1.6, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [6, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 60;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2388.13,2947.63,0],0],
                [[2135.04,4499.4,0],0],
                [[871.545,4837.08,0],0],
                [[11832.3,1030.58,0],0],
                [[14535.2,2118.65,0],0],
                [[18818.3,3287.84,0],0],
                [[14679.8,6923.99,0],0],
                [[11895.3,9702.59,0],0],
                [[8565.49,12912.4,0],0],
                [[6925.79,12377.9,0],0],
                [[11065,14936,0],0],
                [[14296.8,17158.7,0],0],
                [[2887.47,19265.5,0],0],
                [[1062.67,11217.3,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[3364.24,1383.75,0],265],
                [[5530.43,3551.29,0],60],
                [[15479.1,2939.9,0],80],
                [[19757.4,4572.02,0],0],
                [[17043.3,5064.37,0],105],
                [[16258,7174.07,0],225],
                [[13106.3,8441.98,0],335],
                [[10314,7601.88,0],15],
                [[5361.14,6456.61,0],280],
                [[6739.67,10907.4,0],325],
                [[3176.05,12711.4,0],65],
                [[1611.62,13822.7,0],330],
                [[5787.71,14092,0],75],
                [[3791.57,15036.6,0],0],
                [[9425.72,16428.2,0],260],
                [[11123.2,17655.3,0],325],
                [[15800.3,14247.5,0],305],
                [[14691.9,11947.1,0],130],
                [[16401.6,9690.15,0],45],
                [[10765.3,12800.7,0],325]
            ]
        ]
    ];
