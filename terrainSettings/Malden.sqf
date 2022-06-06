// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.3; // average overcast
DAKKA_rain = [0.1, 0.5]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [9, 4]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

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
                [[5063.57,5879.98,0],0],
                [[8095.91,7421.9,0],0],
                [[4263.26,7069.53,0],0],
                [[6561.92,9571.47,0],0],
                [[6230.77,9490.8,0],0],
                [[5872.24,9764.04,0],0],
                [[5366.18,10063.6,0],0],
                [[5209.62,10234.5,0],0],
                [[5714.78,10423.2,0],0],
                [[5960.44,7471.83,0],0],
                [[4158.8,7201.81,0],0],
                [[4658.51,5453.16,0],0],
                [[5137.64,5762.82,0],0],
                [[5076.78,4944.39,0],0],
                [[2859.33,4686.43,0],0],
                [[2867.68,5058.71,0],0],
                [[2761.78,4470.9,0],0],
                [[2694.46,4205.67,0],0],
                [[2658.5,3965.19,0],0],
                [[2523.27,3894.94,0],0],
                [[2680.37,3301.08,0],0],
                [[2499.1,2895.17,0],0],
                [[4225.91,2462.34,0],0],
                [[6927.29,4922.55,0],0],
                [[6505.75,5337.65,0],0],
                [[6969.81,5375.97,0],0],
                [[7882.52,7331.11,0],0],
                [[6942.12,8378.22,0],0],
                [[6754.05,7620.34,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[5236.23,2856.83,0],250],
                [[7256.09,7901.42,0],305],
                [[5532.01,6984.22,0],315],
                [[5848.42,3564.96,0],90],
                [[3702.47,4838.27,0],315],
                [[3144.5,6390.61,0],0],
                [[6118.21,8685.44,0],95],
                [[7023.54,7133.89,0],180],
                [[7831.99,4173.49,0],335],
                [[10772.1,4184.89,0],80]
            ]
        ]
    ];