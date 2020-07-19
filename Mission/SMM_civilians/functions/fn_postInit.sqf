#include "script_component.hpp"

if (!hasInterface) exitWith {};

///////////////////////////////////////////////////////////////////////////////////////////////////
// Zeus modules

["Simplex Civilians","Add Panic Feature",FUNC(moduleAddPanic)] call ZEN_custom_modules_fnc_register;
["Simplex Civilians","Ambient Civ Configuration",FUNC(moduleConfiguration)] call ZEN_custom_modules_fnc_register;
["Simplex Civilians","Ambient Civ Toggle",FUNC(moduleToggle)] call ZEN_custom_modules_fnc_register;
["Simplex Civilians","Ambient Civ Blacklist Area",FUNC(moduleBlacklistArea)] call ZEN_custom_modules_fnc_register;
["Simplex Civilians","Populate Area",FUNC(modulePopulate)] call ZEN_custom_modules_fnc_register;

///////////////////////////////////////////////////////////////////////////////////////////////////
// "Go away!" action

["CAManBase",1,["ACE_SelfActions"],
	[QGVAR(shoo),"""Go away!""","SMM_civilians\leave.paa",{
		"ace_gestures_point" call ace_gestures_fnc_playSignal;
		
		private _dir = getDirVisual _player;
		private _center = _player getPos [18,_dir];
		private _area = [_center,10,18,_dir,false];

		{
			if (side _x isEqualTo civilian && {_x inArea _area}) then {
				[_x,_x getPos [150 + random 150,_dir + random [-60,0,60]]] remoteExecCall ["doMove",_x];
			};
		} forEach (_center nearEntities 20);
	},{true}] call ace_interact_menu_fnc_createAction,
true] call ace_interact_menu_fnc_addActionToClass;

///////////////////////////////////////////////////////////////////////////////////////////////////
