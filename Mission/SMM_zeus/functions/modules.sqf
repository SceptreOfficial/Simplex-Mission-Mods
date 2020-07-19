///////////////////////////////////////////////////////////////////////////////////////////////////
// Get class name tool

["Simplex Zeus Tools","Get Class Name(s)",{
	params ["_posASL","_obj"];

	if (isNull _obj) then {
		[{
			params ["_curatorSelected","_dialogFnc"];
			_curatorSelected params ["_objects"];

			str (_objects apply {typeOf _x}) call EFUNC(common,zeusCopyBox);
		}] call EFUNC(common,zeusMultiSelect);
	} else {
		[objNull,"Object selected"] call BIS_fnc_showCuratorFeedbackMessage;
		str [typeOf _obj] call EFUNC(common,zeusCopyBox);
	};
},"\a3\Modules_F\Data\iconTaskSetDescription_ca.paa"] call ZEN_custom_modules_fnc_register;

///////////////////////////////////////////////////////////////////////////////////////////////////
