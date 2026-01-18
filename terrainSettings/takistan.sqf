// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [1, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [10, 3]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 150;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2253.6,10935.3,0],0],
                [[946.52,10512.3,0],0],
                [[7339.65,6407.43,0],0],
                [[3348.09,7665.4,0],0],
                [[3275.27,7383.02,0],0],
                [[3207.57,7209.83,0],0],
                [[1579.34,6901.82,0],0],
                [[930.541,6844.66,0],0],
                [[987.595,7086.55,0],0],
                [[1059.29,7281.72,0],0],
                [[1297.39,7457.5,0],0],
                [[2256.1,6775.22,0],0],
                [[1264.05,6131.52,0],0],
                [[1156.62,4734.07,0],0],
                [[363.873,4806.7,0],0],
                [[1898.06,3262.18,0],0],
                [[900.237,2106.05,0],0],
                [[10032,3935.51,0],0],
                [[9797.62,4364.64,0],0],
                [[9661.54,4509.8,0],0],
                [[9565.37,4674.01,0],0],
                [[9632.83,5903.43,0],0],
                [[10654.3,6081.42,0],0],
                [[10368.4,10341.5,0],0],
                [[10906.6,11473.7,0],0],
                [[12142.2,12209,0],0],
                [[10550.7,7800.39,0],0],
                [[8164.88,8445.5,0],0],
                [[6534.1,4077.44,0],0],
                [[6748.73,3046.04,0],0],
                [[5494.81,2002.34,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[8126.3,11250.3,0],130],
                [[5265.75,6126.99,0],60],
                [[3441.29,4116.86,0],30],
                [[1482.22,3604.57,0],225],
                [[7908.3,2039.64,0],80],
                [[10170.7,2337.32,0],90],
                [[8909.16,5291.89,0],10],
                [[8266.33,7747.91,0],305],
                [[5661.65,8926.41,0],345],
                [[9851.04,11489,0],130],
                [[9314.52,10009.7,0],25]
            ]
        ]
    ];
