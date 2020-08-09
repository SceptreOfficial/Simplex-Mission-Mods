#include "script_component.hpp"

["Ambient Civ Configuration",[
	["SLIDER",["Pedestrian spawn radius","Radius of ""spawn sector"" around players to spawn pedestrians"],[[250,1500,0],GVAR(pedSpawnRadius)]],
	["SLIDER",["Driving vehicle spawn radius","Radius of ""spawn sector"" around players to spawn driving vehicles"],[[250,1500,0],GVAR(driverSpawnRadius)]],
	["SLIDER",["Parked vehicle spawn radius","Radius of ""spawn sector"" around players to spawn parked vehicles"],[[250,1500,0],GVAR(parkedSpawnRadius)]],
	["SLIDER",["Pedestrians","Amount of pedestrians to spawn in every ""spawn sector"""],[[0,30,0],GVAR(pedCount)]],
	["SLIDER",["Driving vehicles","Amount of driven/moving vehicles to spawn in every ""spawn sector"""],[[0,20,0],GVAR(driverCount)]],
	["SLIDER",["Parked vehicles","Amount of parked/unnoccupied vehicles to spawn in every ""spawn sector"""],[[0,20,0],GVAR(parkedCount)]],
	["EDITBOX",["Unit classes","Civilian unit classes, leave empty for defaults"],str GVAR(unitClasses)],
	["EDITBOX",["Vehicle classes","Vehicle classes, leave empty for defaults"],str GVAR(vehClasses)]
],{
	(_this # 0) params ["_pedSpawnRadius","_driverSpawnRadius","_parkedSpawnRadius","_pedCount","_driverCount","_parkedCount","_unitClasses","_vehClasses"];

	_unitClasses = parseSimpleArray _unitClasses;
	_vehClasses = parseSimpleArray _vehClasses;

	missionNamespace setVariable [QGVAR(pedSpawnRadius),_pedSpawnRadius,true];
	missionNamespace setVariable [QGVAR(driverSpawnRadius),_driverSpawnRadius,true];
	missionNamespace setVariable [QGVAR(parkedSpawnRadius),_parkedSpawnRadius,true];
	missionNamespace setVariable [QGVAR(pedCount),_pedCount,true];
	missionNamespace setVariable [QGVAR(driverCount),_driverCount,true];
	missionNamespace setVariable [QGVAR(parkedCount),_parkedCount,true];
	missionNamespace setVariable [QGVAR(unitClasses),_unitClasses,true];
	missionNamespace setVariable [QGVAR(vehClasses),_vehClasses,true];

	[objNull,"Ambient Civilians Updated"] call BIS_fnc_showCuratorFeedbackMessage;
},{},_pos] call SMM_CDS_fnc_dialog;
