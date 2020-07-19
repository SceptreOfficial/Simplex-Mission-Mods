#include "script_component.hpp"

if (GVAR(isRunning)) then {
	// End
	GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
	GVAR(PFHID) = nil;

	missionNamespace setVariable [QGVAR(isRunning),false,true];
	{[_x,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
} else {
	// Start
	GVAR(PFHID) = [{
		private _playerList = allPlayers select {!(_x isKindOf "HeadlessClient_F")};
		
		if (_playerList isEqualTo []) exitWith {
			{[_x,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
		};

		private _active = [];
		private _inactive = [];
		private _isolated = [];
		private _distArray = [-log 0,-log 0,-log 0];
		private _nullArray = [objNull,objNull,objNull];
		private _spawnRadii = [GVAR(pedSpawnRadius),GVAR(driverSpawnRadius),GVAR(parkedSpawnRadius)];

		{
			private _player = _x;

			if (alive _player) then {
				private _nearestDistances = +_distArray;
				private _nearestSpawnPoints = +_nullArray;

				{
					private _spawnPoint = _x;
					private _spawnRadius = triggerArea _spawnPoint # 0;
					private _type = _spawnPoint getVariable QGVAR(type);
					private _distance = _spawnPoint distance2D _player;

					if (_distance < (_nearestDistances # _type)) then {
						_nearestDistances set [_type,_distance];
						_nearestSpawnPoints set [_type,_spawnPoint];
					};

					switch true do {
						case (_distance <= (_spawnRadius * 1.15)) : {
							_active pushBackUnique _spawnPoint;
						};
						case (_distance >= (_spawnRadius * 2)) : {
							_isolated pushBackUnique _spawnPoint;
						};
						default {
							_inactive pushBackUnique _spawnPoint;
						};
					};
				} forEach +GVAR(spawnPoints);

				{
					private _nearestDist = _nearestDistances # _forEachIndex;

					switch true do {
						case (_nearestDist >= _x) : {// Create new since none nearby
							_active pushBackUnique ([getPos _player,_x,_forEachIndex] call FUNC(create));
						};
						case (_nearestDist >= (_x / 2)) : {// Sequential creation
							private _nearest = _nearestSpawnPoints # _forEachIndex;
							_active pushBackUnique ([_nearest getPos [_x,_nearest getDir _player],_x,_forEachIndex] call FUNC(create));
						};
					};
				} forEach _spawnRadii;
			};
		} forEach _playerList;

		{// Active
			_x setVariable [QGVAR(expiring),nil];
			_x setVariable [QGVAR(expiration),nil];
		} forEach _active;

		{// Inactive
			if (_x getVariable [QGVAR(expiration),CBA_missionTime + 10] < CBA_missionTime) then {
				_x call FUNC(remove);
			} else {
				if !(_x getVariable [QGVAR(expiring),false]) then {
					_x setVariable [QGVAR(expiring),true];
					_x setVariable [QGVAR(expiration),CBA_missionTime + 10];
				};
			};
		} forEach (_inactive - _active);

		{// Isolated
			[_x,true] call FUNC(remove);
		} forEach (_isolated - (_active + _inactive));
	},1] call CBA_fnc_addPerFrameHandler;

	missionNamespace setVariable [QGVAR(isRunning),true,true];
};
