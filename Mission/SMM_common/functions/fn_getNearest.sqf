#include "script_component.hpp"

params ["_center","_list"];

private _max = -log 0;
private _nearest = objNull;
private "_dist";

{
	_dist = _x distanceSqr _center;
	if (_dist < _max) then {
		_max = _dist;
		_nearest = _x;
	};
} forEach _list;

_nearest
