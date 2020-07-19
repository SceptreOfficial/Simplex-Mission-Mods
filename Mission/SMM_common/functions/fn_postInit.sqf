#include "script_component.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////
// Keep track of headless clients

addMissionEventHandler ["HandleDisconnect",{
	params ["_unit"];

	if (_unit in GVAR(headlessClients)) then {
		GVAR(headlessClients) deleteAt (GVAR(headlessClients) find _unit);
		publicVariable QGVAR(headlessClients);
	};

	false
}];

if (!isServer && !hasInterface) then {
	[QGVAR(HCJoined),[player]] call CBA_fnc_serverEvent;
};

///////////////////////////////////////////////////////////////////////////////////////////////
