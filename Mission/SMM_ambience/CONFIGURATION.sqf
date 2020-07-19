GVAR(aircraftChance) = 0.5; // Chance of aircraft spawning after random time has elapsed
GVAR(aircraftMinTime) = 180; // Minimum time between spawn chances
GVAR(aircraftMaxTime) = 480; // Maximum time between spawn chances
GVAR(aircraftAltitude) = 600; // Aircraft flying height
GVAR(aircraftClassesWeighted) = [ // Array of aircraft classes and the chance they will spawn (weighted array)
	"C_Heli_Light_01_civil_F",1,
	"C_Plane_Civil_01_F",1,
	"B_Plane_CAS_01_Cluster_F",1,
	"B_Plane_Fighter_01_Cluster_F",1
];
