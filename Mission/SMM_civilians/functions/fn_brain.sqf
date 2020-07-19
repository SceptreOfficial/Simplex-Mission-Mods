#include "script_component.hpp"

private _list = GVAR(brainList);
private _index = GVAR(brainIndex);

if (_list isEqualTo [] || _index >= count _list) exitWith {
	GVAR(brainList) = allUnits select {local _x && {side group _x isEqualTo civilian && {_x getVariable [QGVAR(hasBrain),false]}}};
	GVAR(brainIndex) = 0;
};

GVAR(brainIndex) = _index + 1;
private _civ = _list # _index;

if (
	alive _civ && 
	{!(_civ getVariable [QGVAR(panicking),false])} && 
	{(unitReady _civ || _civ getVariable [QGVAR(moveTick),-1] < CBA_missionTime)}
) then {
	_civ setVariable [QGVAR(moveTick),CBA_missionTime + 200];

	doStop _civ;

	[{
		private _civ = _this;

		if (!alive _civ) exitWith {};

		private _area = _civ getVariable [QGVAR(inhabitancy),[getPos _civ,100,100,0,false]];

		// Get random position
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			surfaceIsWater _randPos
		} do {};

		if (_civ in _civ) then {
			// 50% chance to base random pos from civ current position
			if (random 1 < 0.5) then {
				while {
					_randPos = _civ getPos [60 + random 40,random 360];
					surfaceIsWater _randPos
				} do {};
			};

			private _buildings = nearestObjects [_randPos,["Building"],100,true];

			// Move to a nearby building if possible
			if !(_buildings isEqualTo []) then {
				_randPos = _buildings # 0 getPos [random 15,random 360];
			};
		} else {
			// Try to find a road position to send vehicles
			private _try = 0;
			while {
				while {
					_randPos = [_area,false] call CBA_fnc_randPosArea;
					surfaceIsWater _randPos
				} do {};
				
				private _road = [_randPos,_randPos nearRoads 450] call TRIPLES(DOUBLES(SMM,common),fnc,getNearest);;

				if (!isNull _road) exitWith {
					_randPos = getPos _road;
					false
				};

				if (_try > 2) exitWith {false};
					
				_try = _try + 1;

				true
			} do {};
		};

		_civ doFollow _civ;
		_civ setSpeedMode "LIMITED";
		_civ doMove _randPos;
	},_civ,3] call CBA_fnc_waitAndExecute;
};
