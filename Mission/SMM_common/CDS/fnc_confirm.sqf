#include "script_component.hpp"

disableSerialization;
GVAR(PFHID) call CBA_fnc_removePerFrameHandler;

private _values = (uiNamespace getVariable QGVAR(controls)) apply {
	private _value = _x getVariable QGVAR(value);
	private _params = _x getVariable QGVAR(parameters);

	switch (_params # 0) do {
		case "CHECKBOX";
		case "EDITBOX" : {
			GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_params # 1,_params # 0] joinString "~",_value];
		};
		case "SLIDER";
		case "COMBOBOX";
		case "LISTNBOX" : {
			GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_params # 1,_params # 0,_params # 2 # 0] joinString "~",_value];
		};
		//case "BUTTON";
		//case "BUTTON2";
		//case "CARGOBOX";
		//case "TREE";
	};

	_value
};

[{isNull (uiNamespace getVariable QGVAR(parent))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
},[_values,uiNamespace getVariable QGVAR(arguments),uiNamespace getVariable QGVAR(onConfirm)]] call CBA_fnc_waitUntilAndExecute;

private _parent = uiNamespace getVariable QGVAR(parent);

if (_parent isEqualType displayNull) then {
	closeDialog 0;
} else {
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(keyDownEHID)];
	[{ctrlDelete _this},_parent] call CBA_fnc_execNextFrame;
};
