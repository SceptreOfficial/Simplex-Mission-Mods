#include "script_component.hpp"

if (canSuspend) exitWith {
	[FUNC(vehicleRespawn),_this] call CBA_fnc_directCall;
};

params [["_vehicle",objNull,[objNull]],["_respawnTime",30,[0]],["_respawnCode",{},[{}]],["_wreckTimeout",120,[0]],["_respawnWhenDisabled",true,[false]]];

if (isNull _vehicle || {_vehicle getVariable [QGVAR(respawnEnabled),false]}) exitWith {};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(vehicleRespawn),2];
};

[_vehicle,"Killed",{_this call FUNC(vehicleRespawnEH)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0,_vehicle];
[_vehicle,"Hit",{_this call FUNC(vehicleRespawnEH)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0,_vehicle];
[_vehicle,"GetOut",{_this call FUNC(vehicleRespawnEH)}] call CBA_fnc_addBISEventHandler;

_vehicle setVariable [QGVAR(respawnEnabled),true,true];

if (isNil {_vehicle getVariable QGVAR(respawnPosASL)}) then {
	_vehicle setVariable [QGVAR(respawnPosASL),getPosASLVisual _vehicle,true];
	_vehicle setVariable [QGVAR(respawnDir),getDirVisual _vehicle,true];
	_vehicle setVariable [QGVAR(respawnTime),_respawnTime,true];
	_vehicle setVariable [QGVAR(respawnCode),_respawnCode,true];
	_vehicle setVariable [QGVAR(wreckTimeout),_wreckTimeout,true];
	_vehicle setVariable [QGVAR(respawnWhenDisabled),_respawnWhenDisabled,true];
};
