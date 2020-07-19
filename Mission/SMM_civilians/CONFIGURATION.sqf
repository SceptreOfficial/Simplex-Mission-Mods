GVAR(pedSpawnRadius) = 450; // Radius of "spawn sector" around players to spawn pedestrians
GVAR(driverSpawnRadius) = 550; // Radius of "spawn sector" around players to spawn driving vehicles
GVAR(parkedSpawnRadius) = 500; // Radius of "spawn sector" around players to spawn parked vehicles
GVAR(pedCount) = 6; // Max amount of pedestrians to spawn in every sector
GVAR(driverCount) = 3; // Max amount of driving vehicles to spawn in every sector
GVAR(parkedCount) = 5; // Max amount of parked vehicles to spawn in every sector
GVAR(unitClasses) = []; // Civilian unit classes, leave empty for defaults
GVAR(vehClasses) = []; // Vehicle classes, leave empty for defaults
GVAR(blacklist) = []; // Blacklist areas (Can be of type: marker, trigger, location, area array)

// DEVELOPMENT/EXPERIMENTAL

GVAR(pedSpawnDelay) = 0.5; // Delay between each pedestrian being spawned
GVAR(driverSpawnDelay) = 0.65; // Delay between each driving vehicle being spawned
GVAR(parkedSpawnDelay) = 0.8; // Delay between each parked vehicle being spawned
GVAR(minPanicTime) = 120; // Minimum amount time civilians will stay in a panicked state
