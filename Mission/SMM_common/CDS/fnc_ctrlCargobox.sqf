#include "script_component.hpp"

_valueData params [["_items",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]]];
_height = ITEM_HEIGHT * ((round _height) max 1);

private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_WIDTH + SPACING_W + CONTROL_WIDTH,ITEM_HEIGHT];
_ctrlDescription ctrlCommit 0;
_ctrlDescription ctrlSetText _descriptionText;
_ctrlDescription ctrlSetTooltip _descriptionTooltip;

//private _cargoItems = if (!_forceDefault) then {
//	GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",[]];
//};

private _ctrlBG1 = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlBG1 ctrlSetPosition [0,_posY + ITEM_HEIGHT + SPACING_H,CARGOBOX_WIDTH,_height];
_ctrlBG1 ctrlSetBackgroundColor [0,0,0,0.9];
_ctrlBG1 ctrlCommit 0;

private _ctrlBG2 = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlBG2 ctrlSetPosition [CARGOBOX_WIDTH + SPACING_W + CARGOBOX_BUTTON_WIDTH + SPACING_W,_posY + ITEM_HEIGHT + SPACING_H,CARGOBOX_WIDTH,_height];
_ctrlBG2 ctrlSetBackgroundColor [0,0,0,0.9];
_ctrlBG2 ctrlCommit 0;

private _ctrl = _display ctrlCreate [QGVAR(Listbox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY + ITEM_HEIGHT + SPACING_H,CARGOBOX_WIDTH,_height];
_ctrl ctrlCommit 0;

private _ctrlCargo = _display ctrlCreate [QGVAR(Listbox),-1,_ctrlGroup];
_ctrlCargo ctrlSetPosition [CARGOBOX_WIDTH + SPACING_W + CARGOBOX_BUTTON_WIDTH + SPACING_W,_posY + ITEM_HEIGHT + SPACING_H,CARGOBOX_WIDTH,_height];
_ctrlCargo ctrlCommit 0;

private _ctrlAdd = _display ctrlCreate [QGVAR(Button),-1,_ctrlGroup];
_ctrlAdd ctrlSetPosition [CARGOBOX_WIDTH + SPACING_W,_posY + ITEM_HEIGHT + SPACING_H + (_height / 2 - CARGOBOX_BUTTON_HEIGHT - (SPACING_H / 2)),CARGOBOX_BUTTON_WIDTH,CARGOBOX_BUTTON_HEIGHT];
_ctrlAdd ctrlCommit 0;
_ctrlAdd ctrlSetText "->";

private _ctrlRemove = _display ctrlCreate [QGVAR(Button),-1,_ctrlGroup];
_ctrlRemove ctrlSetPosition [CARGOBOX_WIDTH + SPACING_W,_posY + ITEM_HEIGHT + SPACING_H + (_height / 2 + (SPACING_H / 2)),CARGOBOX_BUTTON_WIDTH,CARGOBOX_BUTTON_HEIGHT];
_ctrlRemove ctrlCommit 0;
_ctrlRemove ctrlSetText "<-";

{
	_x params [["_item","",["",[]]],["_data","",[""]],["_weight",0,[0]]];
	_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

	private _index = _ctrl lbAdd _text;
	_ctrl lbSetTooltip [_index,_tooltip];
	_ctrl lbSetPicture [_index,_icon];
	_ctrl lbSetColor [_index,_RGBA];
	_ctrl lbSetData [_index,_data];
	_ctrl lbSetValue [_index,_weight];
} forEach _items;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_items,_height,_countLimit,_weightLimit,_method]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),[]];
_ctrl setVariable [QGVAR(count),0];
_ctrl setVariable [QGVAR(countLimit),_countLimit];
_ctrl setVariable [QGVAR(weight),0];
_ctrl setVariable [QGVAR(weightLimit),_weightLimit];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
_ctrl setVariable [QGVAR(ctrlBG),[_ctrlBG1,_ctrlBG2]];

_ctrl setVariable [QGVAR(ctrlCargo),_ctrlCargo];
_ctrl setVariable [QGVAR(ctrlAdd),_ctrlAdd];
_ctrl setVariable [QGVAR(ctrlRemove),_ctrlRemove];
_ctrlCargo setVariable [QGVAR(ctrlAdd),_ctrlAdd];
_ctrlCargo setVariable [QGVAR(ctrlRemove),_ctrlRemove];
_ctrlAdd setVariable [QGVAR(lists),[_ctrl,_ctrlCargo]];
_ctrlRemove setVariable [QGVAR(lists),[_ctrl,_ctrlCargo]];

_ctrl lbSetCurSel 0;
_controls pushBack _ctrl;

private _fnc_add = {
	params ["_ctrlAdd"];
	(_ctrlAdd getVariable QGVAR(lists)) params ["_ctrl","_ctrlCargo"];

	private _selection = lbCurSel _ctrl;

	// Count check
	private _count = (_ctrl getVariable QGVAR(count)) + 1;
	private _countLimit = _ctrl getVariable QGVAR(countLimit);

	if (_countLimit != -1 && _count > _countLimit) exitWith {
		systemChat "Unable to add item: Limit reached";
	};

	// Weight check
	private _weight = (_ctrl getVariable QGVAR(weight)) + (_ctrl lbValue _selection);
	private _weightLimit = _ctrl getVariable QGVAR(weightLimit);

	if (_weightLimit != -1 && _weight > _weightLimit) exitWith {
		systemChat "Unable to add item: Overweight";
	};

	_ctrl setVariable [QGVAR(count),_count];
	_ctrl setVariable [QGVAR(weight),_weight];

	// Add
	private _index = _ctrlCargo lbAdd (_ctrl lbText _selection);

	_ctrlCargo lbSetPicture [_index,_ctrl lbPicture _selection];
	_ctrlCargo lbSetColor [_index,_ctrl lbColor _selection];
	_ctrlCargo lbSetValue [_index,_ctrl lbValue _selection];

	private _value = +(_ctrl getVariable QGVAR(value));
	_value pushBack (_ctrl lbData _selection);
	_ctrl setVariable [QGVAR(value),_value];

	_ctrlCargo lbSetCurSel _index;

	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
};

private _fnc_remove = {
	params ["_ctrlRemove"];
	(_ctrlRemove getVariable QGVAR(lists)) params ["_ctrl","_ctrlCargo"];

	private _selection = lbCurSel _ctrlCargo;

	if (_selection == -1) exitWith {};

	// Count
	_ctrl setVariable [QGVAR(count),(_ctrl getVariable QGVAR(count)) - 1];

	// Weight
	_ctrl setVariable [QGVAR(weight),(_ctrl getVariable QGVAR(weight)) - (_ctrlCargo lbValue _selection)];

	// Remove
	private _value = +(_ctrl getVariable QGVAR(value));
	_value deleteAt _selection;
	_ctrl setVariable [QGVAR(value),_value];

	_ctrlCargo lbDelete _selection;

	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
};

private _fnc_mouseMoving = {
	(_this # 0) setVariable [QGVAR(mouseOver),_this # 3];
};

private _fnc_doubleClick = {
	if ((_this # 0) getVariable QGVAR(mouseOver)) then {
		(_thisArgs # 0) call (_thisArgs # 1);
	};
};

[_ctrlAdd,"ButtonClick",_fnc_add] call CBA_fnc_addBISEventHandler;
[_ctrlRemove,"ButtonClick",_fnc_remove] call CBA_fnc_addBISEventHandler;
[_ctrl,"MouseMoving",_fnc_mouseMoving] call CBA_fnc_addBISEventHandler;
[_ctrlCargo,"MouseMoving",_fnc_mouseMoving] call CBA_fnc_addBISEventHandler;
[_ctrl,"MouseButtonDblClick",_fnc_doubleClick,[_ctrlAdd,_fnc_add]] call CBA_fnc_addBISEventHandler;
[_ctrlCargo,"MouseButtonDblClick",_fnc_doubleClick,[_ctrlRemove,_fnc_remove]] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_HEIGHT + SPACING_H + _height + SPACING_H;