#include "script_component.hpp"

if (GVAR(isRunning)) then {
	[QGVAR(toggle)] call CBA_fnc_serverEvent;
	[objNull,"Ambient Civilians Disabled"] call BIS_fnc_showCuratorFeedbackMessage;
} else {
	["Enable Ambient Civilians",[
		["COMBOBOX",["Locality","Start on specified machine"],[["Server"] + (EGVAR(common,headlessClients) apply {"HC: " + str _x}),0],false]
	],{
		(_this # 0) params ["_localitySelection"];
		[QGVAR(toggle),_localitySelection] call CBA_fnc_serverEvent;
		[objNull,"Ambient Civilians Enabled"] call BIS_fnc_showCuratorFeedbackMessage;
	},{},_pos] call SMM_CDS_fnc_dialog;
};
