// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [0, 6]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [4, 10]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 10;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[1842.47,13162.4,0],0],
                [[1969.86,9289.57,0],0],
                [[1973.46,8228.58,0],0],
                [[1766.09,6453.95,0],0],
                [[4206.79,4359.53,0],0],
                [[7300.37,3170.7,0],0],
                [[7687.72,7179.75,0],0],
                [[6913.86,12918.9,0],0],
                [[11944.8,12785.8,0],0],
                [[10636.1,9970.39,0],0],
                [[12909.8,7366.84,0],0],
                [[13231.5,4497.69,0],0],
                [[13966.6,10083.9,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[4138.25,6635.5,0],315],
                [[5226.53,3879.01,0],75],
                [[7019.66,11588,0],295],
                [[12641.3,5706.26,0],35],
                [[13229.8,9181.41,0],320],
                [[3309.63,12378.5,0],40],
                [[1969.43,9538.66,0],275],
                [[8884.64,4907.64,0],10],
                [[11859.6,2707.97,0],75],
                [[10011.7,8009.61,0],0],
                [[6656.12,8868.87,0],35],
                [[12810.4,14114,0],85],
                [[5539.55,14503.5,0],15],
                [[9029.02,14414.6,0],335],
                [[12673.2,12721.3,0],330],
                [[8887.87,12115.7,0],290],
                [[10775.2,10413.6,0],0]
            ]
        ]
    ];
