// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [3, 12.5]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [3, 12]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 5;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[827.752,436.387,0],0],
                [[358.606,1279.33,0],0],
                [[2911.44,4417.89,0],0],
                [[4320.58,6286.34,0],0],
                [[5551.85,6271.13,0],0],
                [[5776.06,6688.3,0],0],
                [[6652.14,7476.7,0],0],
                [[6737.86,8279.16,0],0],
                [[3274.03,8142.35,0],0],
                [[2626.89,8059.18,0],0],
                [[2345.4,8332.08,0],0],
                [[2037.89,8866.82,0],0],
                [[7773.05,4882.06,0],0],
                [[8252.38,4798.26,0],0],
                [[8563.6,4031.47,0],0],
                [[5436.16,4825.09,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[797.479,962.064,0],325],
                [[3679.45,2178.58,0],265],
                [[5725.8,3052.59,0],350],
                [[9017.05,5206.89,0],0],
                [[7252.54,7535.8,0],270],
                [[6143.53,9130.99,0],75],
                [[2285.62,4059.3,0],240]
            ]
        ]
    ];
