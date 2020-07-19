#include "script_component.hpp"

params [
	["_unit",objNull,[objNull]],
	["_grenadeMagazine","",[""]],
	["_grenadeMuzzle","",[""]],
	["_targetPos",_unit getPos [20,getDir _unit],[[]],3]
];

if (!alive _unit) exitWith {};

if (!local _unit) then {
	_this remoteExecCall [QFUNC(throwGrenade),_unit];
};

private _fireDelay = 0.5;

if !(_grenadeMagazine in magazines _unit) then {
	_fireDelay = 3.5;
	_unit addMagazine _grenadeMagazine;
};

_unit addMagazine _grenadeMagazine;

private _target = (createGroup [sideLogic,true]) createUnit ["Logic",_targetPos vectorAdd [0,0,(_unit distance _targetPos) * 0.2],[],0,"CAN_COLLIDE"];

doStop _unit;
_unit doTarget _target;

private _fnc_throw = {
	[{
		params ["_unit","_target","_grenadeMuzzle"];
		_unit forceWeaponFire [_grenadeMuzzle,_grenadeMuzzle];

		[{
			params ["_unit","_target","_grenadeMuzzle"];

			deleteVehicle _target;
			_unit doFollow _unit;
			_unit doWatch objNull;
		},_this,1] call CBA_fnc_waitAndExecute;
	},_this,_this # 3] call CBA_fnc_waitAndExecute;		
};

[{
	params ["_unit","_target"];
	private _beg = eyePos _unit;
	private _end = getPosASL _target;
	((_beg vectorAdd ((_unit weaponDirection (currentWeapon _unit)) vectorMultiply (_beg distance _end))) distanceSqr _end) < 30 // tolerance
},_fnc_throw,[_unit,_target,_grenadeMuzzle,_fireDelay],2,_fnc_throw] call CBA_fnc_waitUntilAndExecute;
