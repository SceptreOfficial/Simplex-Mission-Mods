#include "script_component.hpp"
#include "..\CONFIGURATION.sqf"

GVAR(spawnPoints) = [];
GVAR(runner) = objNull;
GVAR(isRunning) = false;

if (isServer) then {
	if (isNil QGVAR(brainEFID)) then {
		GVAR(brainList) = [];
		GVAR(brainIndex) = 0;
		GVAR(brainEFID) = addMissionEventHandler ["EachFrame",{call FUNC(brain)}];
	};

	// Handle HC disconnect
	addMissionEventHandler ["HandleDisconnect",{
		params ["_unit"];

		if (isNull GVAR(runner)) exitWith {false};

		if (_unit isEqualTo GVAR(runner) && GVAR(isRunning)) then {
			missionNamespace setVariable [QGVAR(isRunning),false,true];
			missionNamespace setVariable [QGVAR(runner),objNull,true];
		};

		false
	}];

	[QGVAR(toggle),{
		params [["_localitySelection",0,[0]]];

		// End on HC
		if (!isNull GVAR(runner)) exitWith {
			[] remoteExecCall [QFUNC(toggle),owner GVAR(runner)];
			missionNamespace setVariable [QGVAR(runner),objNull,true];
		};

		// End on server
		if (GVAR(isRunning)) exitWith {
			[] call FUNC(toggle);
		};

		if (_localitySelection > count EGVAR(common,headlessClients)) exitWith {
			diag_log "Headless client(s) disconnected during selection. Cancelling occupation.";
		};

		// Server exec
		if (_localitySelection == 0) exitWith {
			missionNamespace setVariable [QGVAR(runner),objNull,true];
			[] call FUNC(toggle);
		};

		// HC exec
		if (_localitySelection > 0) then {
			private _headlessClient = EGVAR(common,headlessClients) # (_localitySelection - 1);
			missionNamespace setVariable [QGVAR(runner),_headlessClient,true];
			
			private _headlessClientID = owner _headlessClient;
			[] remoteExecCall [QFUNC(toggle),_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(localityExec),{
		params ["_localitySelection","_params","_fncVar"];

		if (_localitySelection > (count EGVAR(common,headlessClients) + 1)) exitWith {
			diag_log ("Headless client(s) disconnected during selection. Cancelling execution of " + _fncVar);
		};

		if (_localitySelection == 1) exitWith {
			_params call (missionNamespace getVariable _fncVar);
		};

		if (_localitySelection > 1) then {
			private _headlessClientID = owner (EGVAR(common,headlessClients) # (_localitySelection - 2));
			_params remoteExecCall [_fncVar,_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(addBlacklist),{
		params [["_area",[],["",objNull,locationNull,[]],5]];

		_area = [_area] call CBA_fnc_getArea;

		if (_area isEqualTo []) exitWith {};

		GVAR(blacklist) pushBack _area;
		publicVariable QGVAR(blacklist);
	}] call CBA_fnc_addEventHandler;
};
