#include "script_component.hpp"

_valueData params [["_items",[],[[]]],["_selection",0,[0]]];

CREATE_DESCRIPTION;

if (!_forceDefault) then {
	_selection = GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",_selection];
};

private _ctrl = _display ctrlCreate [QGVAR(Combobox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [CONTROL_X,_posY];
_ctrl ctrlCommit 0;

{
	_x params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

	private _index = _ctrl lbAdd _text;
	_ctrl lbSetTooltip [_index,_tooltip];
	_ctrl lbSetPicture [_index,_icon];
	_ctrl lbSetColor [_index,_RGBA];
} forEach _items;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_items,_selection]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_selection];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];

_ctrl lbSetCurSel _selection;
_controls pushBack _ctrl;

[_ctrl,"LBSelChanged",{
	params ["_ctrl","_selection"];

	_ctrl setVariable [QGVAR(value),_selection];

	[_selection,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_HEIGHT + SPACING_H;
