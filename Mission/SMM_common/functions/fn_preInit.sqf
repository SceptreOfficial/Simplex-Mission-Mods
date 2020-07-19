#include "script_component.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////
// Keep track of headless clients

if (isNil QGVAR(headlessClients)) then {
	GVAR(headlessClients) = [];
};

if (isServer) then {
	[QGVAR(HCJoined),{
		params ["_headlessClient"];

		if (_headlessClient in GVAR(headlessClients)) exitWith {};

		GVAR(headlessClients) pushBack _headlessClient;
		publicVariable QGVAR(headlessClients);
	}] call CBA_fnc_addEventHandler;
};

///////////////////////////////////////////////////////////////////////////////////////////////
// Vehicle respawn functionality

[QGVAR(respawnVehicle),{
	params ["_oldVehicle","_class","_respawnTime","_posASL","_dir","_respawnCode","_wreckTimeout","_respawnWhenDisabled"];

	if (_oldVehicle getVariable [QGVAR(respawning),false]) exitWith {};

	_oldVehicle setVariable [QGVAR(respawning),true,true];

	if (_wreckTimeout >= 0) then {
		[{
			params ["_oldVehicle"];

			if (isNull _oldVehicle) exitWith {};

			if ({alive _x} count crew _oldVehicle == 0) then {
				{_oldVehicle deleteVehicleCrew _x} forEach crew _oldVehicle;
				deleteVehicle _oldVehicle;
			};
		},_oldVehicle,_wreckTimeout] call CBA_fnc_waitAndExecute;
	};

	[{
		params ["_oldVehicle","_class","_respawnTime","_posASL","_dir","_respawnCode","_wreckTimeout","_respawnWhenDisabled"];

		{
			private _obj = _x;
			if ((_oldVehicle == _obj || !alive _obj) && {_obj isKindOf "LandVehicle" || _obj isKindOf "Air" || _obj isKindOf "Ship"}) then {
				{_obj deleteVehicleCrew _x} forEach crew _obj;
				deleteVehicle _obj;
			};
		} forEach (ASLToAGL _posASL nearObjects (sizeOf _class + 1));

		private _vehicle = createVehicle [_class,[0,0,999 + round random 999],[],0,"CAN_COLLIDE"];
		_vehicle allowDamage false;
		_vehicle setDir _dir;
		
		[{
			params ["_vehicle","_posASL"];
			_vehicle setVelocity [0,0,0];
			_vehicle setDir _dir;
			_vehicle setVehiclePosition [ASLToAGL _posASL,[],0,"NONE"];
			[{_this allowDamage true},_vehicle] call CBA_fnc_execNextFrame;
		},[_vehicle,_posASL],1] call CBA_fnc_waitAndExecute;

		_vehicle setVariable [QGVAR(respawnPosASL),_posASL,true];
		_vehicle setVariable [QGVAR(respawnDir),_dir,true];
		_vehicle setVariable [QGVAR(respawnTime),_respawnTime,true];
		_vehicle setVariable [QGVAR(respawnCode),_respawnCode,true];
		_vehicle setVariable [QGVAR(wreckTimeout),_wreckTimeout,true];
		_vehicle setVariable [QGVAR(respawnWhenDisabled),_respawnWhenDisabled,true];

		[_vehicle,_respawnTime,_respawnCode] call FUNC(vehicleRespawn);

		_vehicle call _respawnCode;
	},_this,_respawnTime] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////
