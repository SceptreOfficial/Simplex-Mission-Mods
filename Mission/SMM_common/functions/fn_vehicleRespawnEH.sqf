#include "script_component.hpp"

params ["_vehicle"];

if (_thisType == "Killed") exitWith {
	if (!local _vehicle) exitWith {};

	[QGVAR(respawnVehicle),[
		_vehicle,
		typeOf _vehicle,
		_vehicle getVariable QGVAR(respawnTime),
		_vehicle getVariable QGVAR(respawnPosASL),
		_vehicle getVariable QGVAR(respawnDir),
		_vehicle getVariable QGVAR(respawnCode),
		_vehicle getVariable QGVAR(wreckTimeout),
		_vehicle getVariable QGVAR(respawnWhenDisabled)
	]] call CBA_fnc_serverEvent;

	_vehicle removeEventHandler [_thisType,_thisID];
};

if (_thisType == "Hit") exitWith {
	if (!local _vehicle) exitWith {};

	if (!canMove _vehicle) then {
		[QGVAR(respawnVehicle),[
			_vehicle,
			typeOf _vehicle,
			_vehicle getVariable QGVAR(respawnTime),
			_vehicle getVariable QGVAR(respawnPosASL),
			_vehicle getVariable QGVAR(respawnDir),
			_vehicle getVariable QGVAR(respawnCode),
			_vehicle getVariable QGVAR(wreckTimeout),
			_vehicle getVariable QGVAR(respawnWhenDisabled)
		]] call CBA_fnc_serverEvent;

		_vehicle removeEventHandler [_thisType,_thisID];
	};
};

if (_thisType == "GetOut") exitWith {
	if (!canMove _vehicle) then {
		[QGVAR(respawnVehicle),[
			_vehicle,
			typeOf _vehicle,
			_vehicle getVariable QGVAR(respawnTime),
			_vehicle getVariable QGVAR(respawnPosASL),
			_vehicle getVariable QGVAR(respawnDir),
			_vehicle getVariable QGVAR(respawnCode),
			_vehicle getVariable QGVAR(wreckTimeout),
			_vehicle getVariable QGVAR(respawnWhenDisabled)
		]] call CBA_fnc_serverEvent;
	};
};
