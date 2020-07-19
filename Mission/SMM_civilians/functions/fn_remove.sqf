#include "script_component.hpp"

params [["_spawnPoint",objNull],["_isolated",false]];

if (isNull _spawnPoint) exitWith {
	GVAR(spawnPoints) deleteAt (GVAR(spawnPoints) find _spawnPoint);
};

private _spawnRadius = triggerArea _spawnPoint # 0;

{
	if (!isNull _x) then {
		private _vehicle = vehicle _x;

		if (crew _vehicle isEqualTo []) then {
			private _PFHID = [{
				params ["_args","_PFHID"];
				_args params ["_vehicle","_isolated","_spawnRadius"];

				if (!_isolated && {_vehicle getVariable [QGVAR(firstExec),true]}) exitWith {
					_vehicle setVariable [QGVAR(firstExec),false];
				};

				if (!alive _vehicle || !(crew _vehicle isEqualTo [])) exitWith {
					_PFHID call CBA_fnc_removePerFrameHandler;
				};

				if ((allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_vehicle distance _x < (_spawnRadius / 2)}}) isEqualTo -1) then {
					deleteVehicle _vehicle;
				};
			},30,[_vehicle,_isolated,_spawnRadius]] call CBA_fnc_addPerFrameHandler;

			[_vehicle,"GetIn",{
				params ["_vehicle"];
				_vehicle removeEventHandler [_thisType,_thisID];
				_thisArgs call CBA_fnc_removePerFrameHandler;
			},_PFHID] call CBA_fnc_addBISEventHandler;
		} else {
			if (side group _vehicle == civilian) then {
				{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
				deleteVehicle _vehicle;
			};
		};
	};
} forEach (_spawnPoint getVariable [QGVAR(objects),[]]);

GVAR(spawnPoints) deleteAt (GVAR(spawnPoints) find _spawnPoint);
deleteVehicle _spawnPoint;
