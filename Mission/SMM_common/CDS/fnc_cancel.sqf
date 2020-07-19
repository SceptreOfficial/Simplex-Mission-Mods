#include "script_component.hpp"

disableSerialization;
GVAR(PFHID) call CBA_fnc_removePerFrameHandler;

private _values = (uiNamespace getVariable QGVAR(controls)) apply {_x getVariable QGVAR(value)};

[{isNull (uiNamespace getVariable QGVAR(parent))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
},[_values,uiNamespace getVariable QGVAR(arguments),uiNamespace getVariable QGVAR(onCancel)]] call CBA_fnc_waitUntilAndExecute;

private _parent = uiNamespace getVariable QGVAR(parent);

if (_parent isEqualType displayNull) then {
	closeDialog 0;
} else {
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(keyDownEHID)];
	[{ctrlDelete _this},_parent] call CBA_fnc_execNextFrame;
};
