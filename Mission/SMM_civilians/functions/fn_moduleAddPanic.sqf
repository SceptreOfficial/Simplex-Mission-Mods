#include "script_component.hpp"

params ["_posASL","_obj"];

if (isNull _obj) then {
	[{
		private _civilians = [];
		
		{
			if (side _x == civilian) then {
				_civilians append units _x;
			};
		} forEach (_this # 0 # 1);

		{
			if !(_x getVariable [QGVAR(willPanic),false]) then {
				_x setVariable [QGVAR(willPanic),true,true];
				[_x,"FiredNear",FUNC(panic)] remoteExecCall ["CBA_fnc_addBISEventHandler",0]
			};
		} forEach _civilians;
	}] call EFUNC(common,zeusMultiSelect);
} else {
	if (side group _obj == civilian) then {
		if !(_obj getVariable [QGVAR(willPanic),false]) then {
			_obj setVariable [QGVAR(willPanic),true,true];
			[_obj,"FiredNear",FUNC(panic)] remoteExecCall ["CBA_fnc_addBISEventHandler",0]
		};
		[objNull,"SELECTION SUBMITTED"] call BIS_fnc_showCuratorFeedbackMessage;
	} else {
		[objNull,"NOT A CIVILIAN"] call BIS_fnc_showCuratorFeedbackMessage;
	};
};
