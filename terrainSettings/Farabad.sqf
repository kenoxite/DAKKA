// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.2; // average overcast
DAKKA_rain = [0, 1.5]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [11, 3]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 12;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[1592.24,4614.49,0],0],
                [[2576.44,4175.7,0],0],
                [[1732.1,3307.63,0],0],
                [[7272.16,5819.24,0],0],
                [[9734.57,7965.22,0],0],
                [[8747.28,8606.82,0],0],
                [[7227.98,9304.42,0],0],
                [[10136.1,9363.98,0],0],
                [[4885.38,8014.21,0],0],
                [[4308.59,8732.87,0],0],
                [[4192.81,9270.29,0],0],
                [[1756.61,9363.05,0],0],
                [[8317.62,8195.61,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[3029.91,1471,0],0],
                [[5608.45,2527,0],55],
                [[4557.37,5343.26,0],20],
                [[6291.53,4000.36,0],305],
                [[8753.8,7270.48,0],95],
                [[3173.56,6016.9,0],5],
                [[3934.34,9973.97,0],65],
                [[9620.82,9057.63,0],320],
                [[6494.72,7056.85,0],50],
                [[8820.59,3562.52,0],0],
                [[8491.95,1212.89,0],270]
            ]
        ]
    ];
