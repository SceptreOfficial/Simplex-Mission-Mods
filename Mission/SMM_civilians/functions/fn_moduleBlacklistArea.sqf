#include "script_component.hpp"

params ["_posASL","_obj"];

private _pos = ASLToAGL _posASL;
private _isRectangle = false;
private _width = "100";
private _height = "100";
private _direction = 0;
private _markers = allMapMarkers select {markerPos _x distance2D _posASL < 100 && {toUpper markerShape _x in ["RECTANGLE","ELLIPSE"]}};
private _useDefaultValue = false;

if !(_markers isEqualTo []) then {
	_markers = _markers apply {[markerPos _x distance2D _posASL,_x]};
	_markers sort true;
	private _nearestMarker = _markers # 0 # 1;
	_pos = markerPos _nearestMarker;
	_isRectangle = markerShape _nearestMarker == "RECTANGLE";
	_width = str (markerSize _nearestMarker # 0);
	_height = str (markerSize _nearestMarker # 1);
	_direction = markerDir _nearestMarker;
	_useDefaultValue = true;
};

GVAR(tempMarker) = createMarkerLocal [QGVAR(str CBA_missionTime) + str random 1,_pos];
GVAR(tempMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _isRectangle);
GVAR(tempMarker) setMarkerSizeLocal [parseNumber _width,parseNumber _height];
GVAR(tempMarker) setMarkerDirLocal _direction;

["Blacklist Area",[
	["CHECKBOX","Rectangle",_isRectangle,_useDefaultValue,{
		params ["_bool"];
		GVAR(tempMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _bool);
	}],
	["EDITBOX","Width",_width,_useDefaultValue,{
		params ["_text"];
		GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber _text,abs parseNumber (2 call SMM_CDS_fnc_getCurrentValue)];
	}],
	["EDITBOX","Height",_height,_useDefaultValue,{
		params ["_text"];
		GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber (1 call SMM_CDS_fnc_getCurrentValue),abs parseNumber _text];
	}],
	["SLIDER","Direction",[[0,360,0],_direction],_useDefaultValue,{
		params ["_direction"];
		GVAR(tempMarker) setMarkerDirLocal _direction;
	}]
],{
	deleteMarkerLocal GVAR(tempMarker);

	params ["_values","_pos"];
	_values params ["_isRectangle","_width","_height","_direction"];
	_width = abs parseNumber _width;
	_height = abs parseNumber _height;
	
	[QGVAR(addBlacklist),[[_pos,_width,_height,_direction,_isRectangle]]] call CBA_fnc_serverEvent;

	[objNull,"Blacklist added"] call BIS_fnc_showCuratorFeedbackMessage;
},{deleteMarkerLocal GVAR(tempMarker)},_pos] call SMM_CDS_fnc_dialog;
