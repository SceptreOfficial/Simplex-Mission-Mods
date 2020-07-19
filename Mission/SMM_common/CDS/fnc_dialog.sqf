#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre + ideas from Zeus Enhanced by mharis001
Creates a dialog with defined control types.

Parameters:
0: Title <STRING>
1: Content <ARRAY>
	[
		0: Control type <STRING>
		1: Description <STRING,ARRAY>
		2: Value data <ARRAY>
		3: Force default value <BOOL>
		4: 'onValueChanged' <CODE>
			0: _currentValue <BOOL,SCALAR,STRING>
			1: _customArguments <ANY>
			2: _ctrl <CONTROL>
		5: 'enableCondition' <CODE>
			0: _currentValue <BOOL,SCALAR,STRING>
			1: _customArguments <ANY>
			2: _ctrl <CONTROL>
	]
2: 'onConfirm' <CODE>
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
3: 'onCancel' <CODE>
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
4: Custom arguments <ANY>

Returns:
Dialog created <BOOL> 
//-----------------------------------------------------------------------------------------------*/
disableSerialization;

params [
	["_title","",[""]],
	["_content",[],[[]]],
	["_onConfirm",{},[{}]],
	["_onCancel",{},[{}]],
	["_arguments",[]]
];

if (!isNull (uiNamespace getVariable [QGVAR(parent),displayNull])) exitWith {false};

if (isNil QGVAR(cache)) then {
	GVAR(cache) = [] call CBA_fnc_createNamespace;
};

uiNamespace setVariable [QGVAR(title),_title];
uiNamespace setVariable [QGVAR(onConfirm),_onConfirm];
uiNamespace setVariable [QGVAR(onCancel),_onCancel];
uiNamespace setVariable [QGVAR(arguments),_arguments];

private _zeusDisplay = findDisplay IDD_RSCDISPLAYCURATOR;
private _controlData = if (!isNull _zeusDisplay && visibleMap) then {
	private _parent = _zeusDisplay ctrlCreate [QGVAR(dialog_zeus),-1];
	ctrlSetFocus _parent;

	[
		(safezoneWAbs / 2) - (CONTENT_WIDTH / 2),
		_zeusDisplay,
		_parent,
		_parent controlsGroupCtrl 1,
		_parent controlsGroupCtrl 2,
		_parent controlsGroupCtrl 3,
		_parent controlsGroupCtrl 4,
		_parent controlsGroupCtrl 5
	]
} else {
	createDialog QGVAR(dialog);
	private _parent = uiNamespace getVariable QGVAR(parent);

	[
		(safezoneXAbs + (safezoneWAbs / 2)) - (CONTENT_WIDTH / 2),
		_parent,
		_parent,
		_parent displayCtrl 1,
		_parent displayCtrl 2,
		_parent displayCtrl 3,
		_parent displayCtrl 4,
		_parent displayCtrl 5
	]
};

_controlData params ["_posX","_display","_parent","_ctrlBG","_ctrlTitle","_ctrlGroup","_ctrlCancel","_ctrlConfirm"];

private _controls = [];
private _posY = 0;

// because listNbox makes first control disappear for some reason
private _dummy = _display ctrlCreate ["RscText",-1,_ctrlGroup];
_dummy ctrlSetPosition [0,0,0,0];
_dummy ctrlCommit 0;

{
	_x params [
		["_type","",[""]],
		["_description","",["",[]]],
		["_valueData",[],[true,"",[],{}]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{},true]]
	];

	if (_enableCondition isEqualType true) then {
		_enableCondition = [{false},{true}] select _enableCondition;
	};

	_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
	_description = [_descriptionText,_descriptionTooltip];

	switch (toUpper _type) do {
		case "CHECKBOX" : FUNC(ctrlCheckbox);
		case "EDITBOX" : FUNC(ctrlEditbox);
		case "SLIDER" : FUNC(ctrlSlider);
		case "COMBOBOX" : FUNC(ctrlCombobox);
		case "LISTNBOX" : FUNC(ctrlListNBox);
		case "BUTTON" : FUNC(ctrlButton);
		case "BUTTON2" : FUNC(ctrlButton2);
		case "TREE" : FUNC(ctrlTree);
		case "CARGOBOX" : FUNC(ctrlCargobox);
		case "CARGOBOX2" : FUNC(ctrlCargobox2);
	};
} forEach _content;

uiNamespace setVariable [QGVAR(controls),_controls];

// Init all onValueChanged functions
{[_x getVariable QGVAR(value),_arguments,_x] call (_x getVariable QGVAR(onValueChanged))} forEach _controls;

// Handle enable conditions
GVAR(PFHID) = [{
	disableSerialization;
	params ["_parent","_PFHID"];

	if (isNull _parent) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	{
		_x params ["_ctrl"];

		private _enableCtrl = [_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(enableCondition));
		private _ctrlDescription = _ctrl getVariable [QGVAR(ctrlDescription),controlNull];

		if (!_enableCtrl && ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable false;

			if (!isNull _ctrlDescription) then {
				_ctrlDescription ctrlSetTextColor [COLOR_DISABLED];
			};
			
			if ((_ctrl getVariable QGVAR(parameters)) # 0 == "SLIDER") then {
				(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable false;
			};
		};

		if (_enableCtrl && !ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable true;

			if (!isNull _ctrlDescription) then {
				_ctrlDescription ctrlSetTextColor [1,1,1,1];
			};

			if ((_ctrl getVariable QGVAR(parameters)) # 0 == "SLIDER") then {
				(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable true;
			};
		};
	} forEach (uiNamespace getVariable QGVAR(controls));
},0,_parent] call CBA_fnc_addPerFrameHandler;

// Update positions
private _contentHeight = MIN_HEIGHT max (_posY - SPACING_H) min MAX_HEIGHT;
private _contentY = if (_parent isEqualType displayNull) then {
	(safezoneY + (safezoneH / 2)) - (_contentHeight / 2)
} else {
	(safezoneH / 2) - (_contentHeight / 2)
};

_ctrlBG ctrlSetPosition [_posX - BUFFER_W,_contentY - BUFFER_H,CONTENT_WIDTH + (BUFFER_W * 2),_contentHeight + (BUFFER_H * 2)];
_ctrlBG ctrlCommit 0;
_ctrlTitle ctrlSetPosition [_posX - BUFFER_W,_contentY - BUFFER_H - SPACING_H - TITLE_HEIGHT,CONTENT_WIDTH + (BUFFER_W * 2),TITLE_HEIGHT];
_ctrlTitle ctrlCommit 0;
_ctrlGroup ctrlSetPosition [_posX,_contentY,CONTENT_WIDTH + BUFFER_H,_contentHeight];
_ctrlGroup ctrlCommit 0;
_ctrlCancel ctrlSetPosition [_posX - BUFFER_W,_contentY + _contentHeight + BUFFER_H + SPACING_H,MENU_BUTTON_WIDTH,MENU_BUTTON_HEIGHT];
_ctrlCancel ctrlCommit 0;
_ctrlConfirm ctrlSetPosition [_posX + CONTENT_WIDTH - MENU_BUTTON_WIDTH + BUFFER_W,_contentY + _contentHeight + BUFFER_H + SPACING_H,MENU_BUTTON_WIDTH,MENU_BUTTON_HEIGHT];
_ctrlConfirm ctrlCommit 0;

// Set title and focus
_ctrlTitle ctrlSetText _title;
ctrlSetFocus _ctrlConfirm;

// Handle ESC key
GVAR(keyDownEHID) = [_display,"KeyDown",{
	private _key = _this # 1;

	if (_key in [DIK_UP,DIK_DOWN,DIK_LEFT,DIK_RIGHT]) exitWith {false};

	if (_key == DIK_ESCAPE) then {
		call FUNC(cancel);
	};

	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR && visibleMap) exitWith {
		if (_key in [DIK_BACKSPACE,DIK_DELETE]) then {
			private _ctrl = uiNamespace getVariable [QGVAR(editFocus),controlNull];
			
			if (isNull _ctrl) exitWith {};

			private _text = ctrlText _ctrl;

			if (_key == DIK_BACKSPACE) then {
				_text = _text select [0,count _text - 1];
			};

			if (_key == DIK_DELETE) then {
				_text = _text select [1,count _text - 1];
			};

			// Whenever the dev command comes out use this code
			//ctrlTextSelection _ctrl params ["_start","_length","_selectedText"];
			//
			//if (_length != 0) exitWith {
			//	_text = toArray _text;
			//	_text deleteRange [_start,_length];
			//	_text = toString _text;
			//
			//	_ctrl ctrlSetText _text;
			//};
			//
			//if (_key == DIK_BACKSPACE) then {
			//	_text = toArray _text;
			//	_text deleteAt _start;
			//	_text = toString _text;
			//};
			//
			//if (_key == DIK_DELETE) then {
			//	_text = toArray _text;
			//	_text deleteAt (_start + 1);
			//	_text = toString _text;
			//};

			_ctrl ctrlSetText _text;
		};

		true
	};

	false
}] call CBA_fnc_addBISEventHandler;

true
