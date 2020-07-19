#include "script_component.hpp"
#include "modules.sqf"

///////////////////////////////////////////////////////////////////////////////////////////////
// Throw grenade feature

[["Throw_Grenade_Parent","Throw Grenade","SMM_zeus\frag.paa",{},{
	_entity = _this # 5;
	_entity isEqualType objNull && {_entity isKindOf "CAManBase"} && {!isPlayer _entity}
}] call zen_context_menu_fnc_createAction,[],98] call zen_context_menu_fnc_addAction;

[["Throw_Grenade_SmokeWhite","Smoke - White","SMM_zeus\smoke.paa",{
	[_this # 5,{
		params ["_success","_object","_posASL"];
		if (!_success) exitWith {};
		[_object,"SmokeShell","SmokeShellMuzzle",ASLtoAGL _posASL] call FUNC(throwGrenade);
	}] call ace_zeus_fnc_getModuleDestination;
}] call zen_context_menu_fnc_createAction,["Throw_Grenade_Parent"],2] call zen_context_menu_fnc_addAction;

[["Throw_Grenade_SmokeRed","Smoke - Red","SMM_zeus\smoke.paa",{
	[_this # 5,{
		params ["_success","_object","_posASL"];
		if (!_success) exitWith {};
		[_object,"SmokeShellRed","SmokeShellRedMuzzle",ASLtoAGL _posASL] call FUNC(throwGrenade);
	}] call ace_zeus_fnc_getModuleDestination;
}] call zen_context_menu_fnc_createAction,["Throw_Grenade_Parent"],1] call zen_context_menu_fnc_addAction;

[["Throw_Grenade_SmokeGreen","Smoke - Green","SMM_zeus\smoke.paa",{
	[_this # 5,{
		params ["_success","_object","_posASL"];
		if (!_success) exitWith {};
		[_object,"SmokeShellGreen","SmokeShellGreenMuzzle",ASLtoAGL _posASL] call FUNC(throwGrenade);
	}] call ace_zeus_fnc_getModuleDestination;
}] call zen_context_menu_fnc_createAction,["Throw_Grenade_Parent"],1] call zen_context_menu_fnc_addAction;

[["Throw_Grenade_Frag","Frag","SMM_zeus\frag.paa",{
	[_this # 5,{
		params ["_success","_object","_posASL"];
		if (!_success) exitWith {};
		[_object,"HandGrenade","HandGrenadeMuzzle",ASLtoAGL _posASL] call FUNC(throwGrenade);
	}] call ace_zeus_fnc_getModuleDestination;
}] call zen_context_menu_fnc_createAction,["Throw_Grenade_Parent"],0] call zen_context_menu_fnc_addAction;

///////////////////////////////////////////////////////////////////////////////////////////////
