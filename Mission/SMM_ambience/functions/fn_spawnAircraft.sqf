#include "script_component.hpp"

params [["_aircraftClass","",[""]],["_startPos",[],[[]]],["_endPos",[],[[]]],["_altitude",500,[0]]];

_startPos set [2,_altitude];

// Spawn vehicle
private _aircraft = createVehicle [_aircraftClass,[0,0,_altitude],[],0,"FLY"];
if (isNull _aircraft) exitWith {};
{_aircraft removeWeapon _x} forEach weapons _aircraft;
_aircraft setDir (_startPos getDir _endPos);
_aircraft setPos _startPos;
_aircraft setVelocityModelSpace [0,100,0];

// Spawn AI pilot
private _group = createGroup [civilian,true];
private _pilot = _group createUnit ["C_man_pilot_F",[0,0,0],[],0,"CAN_COLLIDE"];
_pilot moveInDriver _aircraft;
_pilot setBehaviour "CARELESS";
_pilot setSkill 1;
_pilot allowFleeing 0;

// Move to the end pos
private _wp = _group addWaypoint [_endPos,0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 300;
_wp setWaypointStatements ["true",QUOTE(
	private _group = group this;
	private _vehicle = vehicle this;

	if (local _group) then {
		{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
		deleteGroup	_group;
		deleteVehicle _vehicle;
	};
)];

_aircraft flyInHeight _altitude;
